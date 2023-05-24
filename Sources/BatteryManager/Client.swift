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
        case state = "state"
    }
    
    struct CurrentStatus {
        let percentage: Int
        let state: State
    }
    
    enum PropertyError: Error {
        case parsePercentage
        case parseState
    }
    
    enum State: String, CaseIterable {
        case full = "Full"
        case discharging = "Discharging"
        case charging = "Charging"
    }

    init() {
        self.terminal = Terminal()
    }
    
    func getCurrentStatus() throws -> CurrentStatus {
        let percentage = try getPercentage()
        let state = try getState()
        
        return .init(percentage: percentage, state: state)
    }

    private func getPercentage() throws -> Int {
        let command = "cat \(basePowerSupplyPath)\(Property.capacity.rawValue)"
        let result = try terminal.runCommand(command)
        
        guard let percentage = Int(result) else {
            throw Self.PropertyError.parsePercentage
        }
        
        return percentage
    }

    private func getState() throws -> State {
        let command = "cat \(basePowerSupplyPath)\(Property.state.rawValue)"
        let result = try terminal.runCommand(command)
        
        guard let parsed = State(rawValue: result) else {
            throw Self.PropertyError.parseState
        }
        
        return parsed
    }

    private func getFromTerminal(property: Property) throws -> String {
        let command = "cat \(basePowerSupplyPath)\(Property.capacity.rawValue)"

        return try terminal.runCommand(command)
    }

}
