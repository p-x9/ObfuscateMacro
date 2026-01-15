// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ObfuscateMacro",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "ObfuscateMacro",
            targets: ["ObfuscateMacro"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            "509.0.0"..<"603.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-algorithms",
            from: "1.1.0"
        ),
        .package(
            url: "https://github.com/apple/swift-crypto.git",
            "1.0.0"..<"5.0.0"
        )
    ],
    targets: [
        .target(
            name: "ObfuscateMacro",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Crypto", package: "swift-crypto"),
                "ObfuscateMacroPlugin",
                "ObfuscateSupport"
            ]
        ),
        .macro(
            name: "ObfuscateMacroPlugin",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Crypto", package: "swift-crypto"),
                "ObfuscateSupport"
            ]
        ),
        .target(name: "ObfuscateSupport"),
        .testTarget(
            name: "ObfuscateMacroTests",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                "ObfuscateMacro",
                "ObfuscateMacroPlugin"
            ]
        ),
    ]
)
