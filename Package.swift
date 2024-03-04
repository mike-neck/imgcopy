// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "imgcopy",
        platforms: [.macOS(.v10_14)],
        products: [
            .executable(name: "imgcopy", targets: ["imgcopy"]),
            .executable(name: "imgfile", targets: ["imgfile"]),
        ],
        dependencies: [
            // Dependencies declare other packages that this package depends on.
            // .package(url: /* package url */, from: "1.0.0"),
            .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        ],
        targets: [
            // Targets are the basic building blocks of a package. A target can define a module or a test suite.
            // Targets can depend on other targets in this package, and on products in packages which this package depends on.
            .executableTarget(
                    name: "imgfile",
                    dependencies: [
                        .product(name: "ArgumentParser", package: "swift-argument-parser"),
                    ]),
            .executableTarget(
                    name: "imgcopy",
                    dependencies: ["ImgCopyMod"]),
            .target(
                    name: "ImgCopyMod",
                    dependencies: []),
            .testTarget(
                    name: "imgcopyTests",
                    dependencies: ["imgcopy"]),
            .testTarget(
                    name: "ImgCopyModTests",
                    dependencies: ["ImgCopyMod"]),
        ]
)
