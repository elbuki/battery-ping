//
//  APN.swift
//  
//
//  Created by Marco Carmona on 6/14/23.
//

import Foundation

struct APN {
    
    private struct Config: Decodable {
        let deviceID: String
        let bundleID: String
        let tokenCommand: String
        
        enum CodingKeys: String, CodingKey {
            case deviceID = "deviceId"
            case bundleID = "bundleId"
            case tokenCommand = "tokenCommand"
        }
    }
    
    private struct APS: Codable {
        let contentAvailable: Int
        
        enum CodingKeys: String, CodingKey {
            case contentAvailable = "content-available"
        }
    }
    
    private struct Payload: Codable {
        let aps: APS
    }
    
    private enum InitializationError: Error {
        case openingConfigFile
    }
    
    private enum RequestError: Error {
        case buildingURL
        case parsingResponse
        case unexpectedStatusCode
        case buildToken
    }
    
    private let baseURL = "https://api.sandbox.push.apple.com/3/device/"
    private let statusOkCode = 200

    private var config: Config
    private var phpScriptPath: URL
    private var terminal: Terminal
    
    init() throws {
        let packageURL = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let fileURL = packageURL.appendingPathComponent("config.json")
        let createTokenURL = packageURL
            .appendingPathComponent("APN", isDirectory: true)
        
        self.terminal = Terminal()
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode(Config.self, from: data)
            
            self.phpScriptPath = createTokenURL
            
            config = decoded
        } catch {
            throw Self.InitializationError.openingConfigFile
        }
    }
    
    func send() async throws {
        let payload = Payload(aps: .init(contentAvailable: 1))
        let headers: [String: String] = [
            "apns-push-type": "background",
            "apns-expiration": "0",
            "apns-priority": "5",
            "apns-topic": config.bundleID,
        ]
        
        let phpTokenCommand = config.tokenCommand.replacingOccurrences(
            of: "%%PATH%%",
            with: phpScriptPath.path
        )
        
        guard var url = URL(string: baseURL) else {
            throw Self.RequestError.buildingURL
        }
        
        guard var token = try? terminal.runCommand(phpTokenCommand) else {
            throw Self.RequestError.buildToken
        }

        let encoded = try JSONEncoder().encode(payload)
        var request: URLRequest
        
        token = "Bearer \(token.trimmingCharacters(in: .whitespacesAndNewlines))"
        url = url.appendingPathComponent(config.deviceID)
        request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        for (header, value) in headers {
            request.setValue(value, forHTTPHeaderField: header)
        }

        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = encoded

        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Self.RequestError.parsingResponse
        }
        
        guard httpResponse.statusCode == statusOkCode else {
            throw Self.RequestError.unexpectedStatusCode
        }
        
        print("Successfully sent a notification via APN")
    }
    
}
