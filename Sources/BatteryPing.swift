//
//  BatteryPing.swift
//  
//
//  Created by Marco Carmona on 5/18/23.
//

import Foundation

public final class BatteryPing {
    private let minimumBeforeTrigger = 10
    private let waitSeconds: UInt32 = 10
    private let lambdaFunctionName = "PlugTrigger"

    public func run() async throws {
//        let lambda = try Lambda(region: .usEast1, functionName: "HelloWorld")
//        let payload = PayloadMessage(name: "Carolina")
//        let jsonData = try JSONEncoder().encode(payload)
//        let response = try await lambda.invoke(payload: jsonData)
//
//        dump(response)
        
        let manager = BatteryManager()
//        let lambda = try Lambda(region: .usEast1, functionName: lambdaFunctionName)

        while true {
            let status = try manager.client.getCurrentStatus()
            var action = PayloadMessage.Action.undefined
            
            if status.percentage <= minimumBeforeTrigger && status.state == .discharging {
                action = .charge
            } else if status.state == .full {
                action = .discharge
            }
            
            if action != .undefined {
//                var payload = PayloadMessage(action: action)
//                let jsonData = try JSONEncoder().encode(payload)
//                let response = try await lambda.invoke(payload: jsonData)
//                
//                dump(response)
                dump(status)
                print("Invoked lambda function for action: \(action.rawValue)")
            }

            sleep(waitSeconds)
        }
    }

}
