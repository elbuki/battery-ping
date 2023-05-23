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

    public func run() async throws {
//        let lambda = try Lambda(region: .usEast1, functionName: "HelloWorld")
//        let payload = PayloadMessage(name: "Carolina")
//        let jsonData = try JSONEncoder().encode(payload)
//        let response = try await lambda.invoke(payload: jsonData)
//
//        dump(response)
        
        let manager = BatteryManager()
        while true {
            dump(try manager.client.getCurrentStatus())

            sleep(2)
        }
    }

}
