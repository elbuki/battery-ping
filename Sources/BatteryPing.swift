//
//  BatteryPing.swift
//  
//
//  Created by Marco Carmona on 5/18/23.
//

import Foundation

struct PayloadMessage: Codable {
    let name: String
}

public final class BatteryPing {
    private let arguments: [String]

    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }

    public func run() async throws {
        print("Hello world")
        
        let lambda = try Lambda(region: .usEast1, functionName: "HelloWorld")
        let payload = PayloadMessage(name: "Carolina")
        let jsonData = try JSONEncoder().encode(payload)
        let response = try await lambda.invoke(payload: jsonData)
        
        dump(response)
        
//        let terminal = Terminal()
//        while true {
//            dump(try terminal.runCommand("ls -la"))
//
//            sleep(2)
//        }
    }
}
