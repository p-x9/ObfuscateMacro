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
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "ObfuscateMacro",
            targets: ["ObfuscateMacro"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            "509.0.1"..<"511.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-algorithms",
            from: "1.1.0"
        )
    ],
    targets: [
        .target(
            name: "ObfuscateMacro",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
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
                .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
                .product(name: "Algorithms", package: "swift-algorithms"),
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
