//
//  BatteryManager.swift
//  
//
//  Created by Marco Carmona on 5/23/23.
//

import Foundation

struct BatteryManager {
    
    private let mockArgument = "enable-mock"

    var client: Dischargeable
    
    init() {
        for argument in ProcessInfo.processInfo.arguments {
            if argument != mockArgument {
                continue
            }
            
            client = MockManager()
            return
        }

        client = BatteryClient()
    }

}
