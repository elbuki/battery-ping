//
//  Terminal.swift
//  
//
//  Created by Marco Carmona on 5/18/23.
//

import Foundation

struct Terminal {
    
    enum CommandError: Error {
        case couldNotParseOutput
    }
    
    func runCommand(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        var data: Data
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        
        task.launch()
        
        data = pipe.fileHandleForReading.readDataToEndOfFile()

        guard let output = String(data: data, encoding: .utf8) else {
            throw CommandError.couldNotParseOutput
        }
        
        return output
    }
}
