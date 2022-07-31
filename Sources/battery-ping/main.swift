//
//  main.swift
//  Battery Ping
//
//  Created by Marco Carmona on 7/31/22.
//

import Foundation
import IOKit.ps

enum BatteryError: Error {
    case parsing
    case propertyLookup(key: String)
    case notFound
}

enum ChargingState {
    case unplugged
    case charging
    // case charged
}

struct BatteryState {
    let computerName: String
    let percentage: UInt8
    let chargingState: ChargingState
}

let internalBatteryName = "InternalBattery"
let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
let processInfo = ProcessInfo()
var state: BatteryState? = nil

do {
    for source in sources {
        let description = IOPSGetPowerSourceDescription(snapshot, source).takeRetainedValue()
        var chargingState = ChargingState.unplugged
        var isCharging: CFBoolean
        
        guard let info = description as? [String: AnyObject] else {
            throw BatteryError.parsing
        }
        
        guard let name = info[kIOPSNameKey] as? String else {
            throw BatteryError.propertyLookup(key: kIOPSNameKey)
        }
        
        guard name.contains(internalBatteryName) else {
            continue
        }
        
        guard let percentage = info[kIOPSCurrentCapacityKey] as? Int else {
            throw BatteryError.propertyLookup(key: kIOPSCurrentCapacityKey)
        }
        
        guard let chargingValue = info[kIOPSIsChargingKey] else {
            throw BatteryError.propertyLookup(key: kIOPSIsChargingKey)
        }
        
        isCharging = chargingValue as! CFBoolean
        
        if Bool(truncating: isCharging) {
            chargingState = .charging
        }
        
        state = BatteryState(
            computerName: processInfo.hostName,
            percentage: UInt8(percentage),
            chargingState: chargingState
        )
    }
    
    guard let foundState = state else {
        throw BatteryError.notFound
    }
    
    dump(foundState)
} catch {
    fatalError(error.localizedDescription)
}
