//
//  Dischargeable.swift
//  
//
//  Created by Marco Carmona on 5/23/23.
//

protocol Dischargeable {
    func getCurrentStatus() throws -> BatteryClient.CurrentStatus
}
