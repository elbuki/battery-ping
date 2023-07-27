//
//  Mock.swift
//  
//
//  Created by Marco Carmona on 5/23/23.
//

import Foundation

class MockManager: Dischargeable {
    
    var currentStatus = BatteryClient.CurrentStatus.init(percentage: 50, state: .discharging)
    
    func getCurrentStatus() throws -> BatteryClient.CurrentStatus {
        let (percentage, state) = rollTheDice()
        
        currentStatus = .init(percentage: percentage, state: state)
        
        return currentStatus
    }
    
    private func rollTheDice() -> (Int, BatteryClient.State) {
        switch currentStatus.state {
        case .discharging:
            return (10, .charging)
        case .charging:
            return (100, .full)
        case .full:
            return (50, .discharging)
        }
    }
    
}
