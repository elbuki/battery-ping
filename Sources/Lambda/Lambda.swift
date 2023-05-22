//
//  Lambda.swift
//  
//
//  Created by Marco Carmona on 5/19/23.
//

import Foundation
import AWSLambda

struct ResponseMessage: Codable {
    let message: String
}

enum InvokeError: Error {
    case noResponse
    case invalidResponse
}

struct Lambda {
    let client: LambdaClient
    let functionName: String
    
    enum Region: String {
        case usEast1 = "us-east-1"
    }
    
    init(region: Region, functionName: String) throws {
        self.client = try LambdaClient(region: region.rawValue)
        self.functionName = functionName
    }
    
    func invoke(payload: Data?) async throws -> ResponseMessage {
        let input = try buildInput(payload: payload)
        let output = try await client.invoke(input: input)
        
        guard let response = output.payload else {
            throw InvokeError.noResponse
        }
        
        return try JSONDecoder().decode(ResponseMessage.self, from: response)
    }
    
    private func buildInput(payload: Data?) throws -> InvokeInput {
        let input = InvokeInput(
            functionName: functionName,
            payload: payload
        )
        
        return input
    }
}
