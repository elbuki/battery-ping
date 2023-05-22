//
//  BatteryManager.swift
//  
//
//  Created by Marco Carmona on 5/19/23.
//

import Foundation
import Terminal

struct BatteryManager {

    static let current = BatteryManager()

    private let basePowerSupplyPath = "/sys/class/power_supply/BAT0/"
    private var terminal: Terminal

    private enum Property: String {
        case capacity = "capacity"
        case status = "status"
    }

    init() {
        self.terminal = terminal
    }

    func getPercentage() {
        let command = "cat \(basePowerSupplyPath)\(Property.capacity.rawValue)"

        terminal.runCommand(command)
    }

    func getStatus() {
        let command = "cat \(basePowerSupplyPath)\(Property.status.rawValue)"

        terminal.runCommand(command)
    }

    private func getFromTerminal(property: Property) throws -> String {
        let command = "cat \(basePowerSupplyPath)\(Property.capacity.rawValue)"

        terminal.runCommand(command)
    }

}
