// swift-tools-version:6.2.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "imgcopy",
        platforms: [.macOS(.v10_14)],
        products: [
            .executable(name: "imgcopy", targets: ["imgcopy"]),
            .executable(name: "imgfile", targets: ["imgfile"]),
            .executable(name: "imgview", targets: ["imgview"]),
        ],
        dependencies: [
            // Dependencies declare other packages that this package depends on.
            // .package(url: /* package url */, from: "1.0.0"),
            .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.7.1"),
        ],
        targets: [
            // Targets are the basic building blocks of a package. A target can define a module or a test suite.
            // Targets can depend on other targets in this package, and on products in packages which this package depends on.
            .executableTarget(
                    name: "imgfile",
                    dependencies: [
                        .product(name: "ArgumentParser", package: "swift-argument-parser"),
                        "ClipboardReaderMod",
                        "IOUtils",
                    ],
                    resources: [.embedInCode("version.txt")]
                    ),
            .executableTarget(
                    name: "imgcopy",
                    dependencies: ["ImgCopyMod"],
                    resources: [.embedInCode("version.txt")]
            ),
            .executableTarget(
                name: "imgview",
                dependencies: [
                    .product(name: "ArgumentParser", package: "swift-argument-parser"),
                    "ClipboardReaderMod",
                    "IOUtils",
                ],
                resources: [.embedInCode("version.txt")]
            ),
            .target(
                name: "IOUtils",
                dependencies: []),
            .target(
                name: "ImgCopyMod",
                dependencies: [/*"FileReaderMod"*/]),
            .target(
                    name: "ClipboardReaderMod",
                    dependencies: [],
            ),
            .testTarget(
                    name: "imgcopyTests",
                    dependencies: ["imgcopy"]),
            .testTarget(
                    name: "ImgCopyModTests",
                    dependencies: ["ImgCopyMod"]),
            .testTarget(
                    name: "ImgViewTests",
                    dependencies: ["imgview"]),
        ]
)
