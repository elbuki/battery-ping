//
//  BatteryPing.swift
//  
//
//  Created by Marco Carmona on 5/18/23.
//

import Foundation

public final class BatteryPing {

    enum Action: String {
        case undefined
        case charge
        case discharge
    }
    
    private let minimumBeforeTrigger = 10
    private let waitSeconds: UInt32 = 30

    public func run() async throws {
        let manager = BatteryManager()
        let apn = try APN()

        while true {
            let status = try manager.client.getCurrentStatus()
            var action = Action.undefined
            
            if status.percentage <= minimumBeforeTrigger && status.state == .discharging {
                action = .charge
            } else if status.state == .full {
                action = .discharge
            }
            
            if action != .undefined {
                print("sending notification to: \(action.rawValue)")
                
                try await apn.send(actionToPerform: action.rawValue)
            }

            sleep(waitSeconds)
        }
    }

}
