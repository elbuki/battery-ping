// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BatteryPing",
    platforms: [
       .macOS(.v10_15),
       .iOS(.v13)
    ],
    dependencies: [],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "BatteryPing",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("config.json"),
                .process("APN/create_token.php")
            ]
        )
    ]
)
