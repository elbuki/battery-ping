// The Swift Programming Language
// https://docs.swift.org/swift-book

let ping = BatteryPing()

do {
    try await ping.run()
} catch {
    print("Whoops! An error occurred: \(error.localizedDescription)")
}
