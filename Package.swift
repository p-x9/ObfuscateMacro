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
            url: "https://github.com/swiftlang/swift-syntax.git",
            "509.0.0"..<"601.0.0-prerelease"
        ),
        .package(
            url: "https://github.com/apple/swift-algorithms",
            from: "1.1.0"
        ),
        .package(
            url: "https://github.com/apple/swift-crypto.git",
            "1.0.0"..<"4.0.0"
        ),
        .package(
            url: "https://github.com/stackotter/swift-macro-toolkit.git",
            branch: "main"
        ),
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
                .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "MacroToolkit", package: "swift-macro-toolkit"),
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
