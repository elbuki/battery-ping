//
//  Mock.swift
//  
//
//  Created by Marco Carmona on 5/23/23.
//

import Foundation

struct MockManager: Dischargeable {
    
    func getCurrentStatus() throws -> BatteryClient.CurrentStatus {
        let (percentage, status) = rollTheDice()
        
        return .init(percentage: percentage, status: status)
    }
    
    private func rollTheDice() -> (Int, BatteryClient.Status) {
        guard let randomStatus = BatteryClient.Status.allCases.randomElement() else {
            fatalError("Could not get random element for BatteryManager status")
        }
        
        switch randomStatus {
        case .full:
            return (100, .full)
        default:
            return (Int.random(in: 1...99), randomStatus)
        }
    }
    
}
