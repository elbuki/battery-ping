//
//  Client.swift
//  
//
//  Created by Marco Carmona on 5/19/23.
//

import Foundation

struct BatteryClient: Dischargeable {

    private let basePowerSupplyPath = "/sys/class/power_supply/BAT0/"
    private var terminal: Terminal

    private enum Property: String {
        case capacity = "capacity"
        case status = "status"
    }
    
    struct CurrentStatus {
        let percentage: Int
        let status: Status
    }
    
    enum PropertyError: Error {
        case parsePercentage
        case parseStatus
    }
    
    enum Status: String, CaseIterable {
        case full = "Full"
        case discharging = "Discharging"
        case charging = "Charging"
    }

    init() {
        self.terminal = Terminal()
    }
    
    func getCurrentStatus() throws -> CurrentStatus {
        let percentage = try getPercentage()
        let status = try getStatus()
        
        return .init(percentage: percentage, status: status)
    }

    private func getPercentage() throws -> Int {
        let command = "cat \(basePowerSupplyPath)\(Property.capacity.rawValue)"
        let result = try terminal.runCommand(command)
        
        guard let percentage = Int(result) else {
            throw Self.PropertyError.parsePercentage
        }
        
        return percentage
    }

    private func getStatus() throws -> Status {
        let command = "cat \(basePowerSupplyPath)\(Property.status.rawValue)"
        let result = try terminal.runCommand(command)
        
        guard let parsed = Status(rawValue: result) else {
            throw Self.PropertyError.parseStatus
        }
        
        return parsed
    }

    private func getFromTerminal(property: Property) throws -> String {
        let command = "cat \(basePowerSupplyPath)\(Property.capacity.rawValue)"

        return try terminal.runCommand(command)
    }

}
