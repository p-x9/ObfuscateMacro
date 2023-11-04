import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
@testable import ObfuscateMacroPlugin
@testable import ObfuscateMacro

struct TestRandomNumberGenerator: RandomNumberGenerator {
    let seed: UInt64

    func next() -> UInt64 {
        seed
    }
}

final class ObfuscateMacroTests: XCTestCase {
    let macros: [String: Macro.Type] = [
        "ObfuscatedString": ObfuscatedString.self
    ]

    override class func setUp() {
        ObfuscatedString.randomNumberGenerator = TestRandomNumberGenerator(seed: 1)
    }

    func testDeObfuscatedString() {
        XCTAssertEqual(
            "hello, こんにちは, 👪",
            #ObfuscatedString("hello, こんにちは, 👪", method: .bitShift)
        )
        XCTAssertEqual(
            "hello, こんにちは, 👪",
            #ObfuscatedString("hello, こんにちは, 👪", method: .bitXOR)
        )
        XCTAssertEqual(
            "hello, こんにちは, 👪",
            #ObfuscatedString("hello, こんにちは, 👪", method: .base64)
        )
#if canImport(CryptoKit)
        XCTAssertEqual(
            "hello, こんにちは, 👪",
            #ObfuscatedString("hello, こんにちは, 👪", method: .AES)
        )
#endif
    }

    func testDeObfuscatedLongString() {
        let original = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        XCTAssertEqual(
            original,
            #ObfuscatedString(
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                method: .bitShift
            )
        )
        XCTAssertEqual(
            original,
            #ObfuscatedString(
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                method: .bitXOR
            )
        )
        XCTAssertEqual(
            original,
            #ObfuscatedString(
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                method: .base64
            )
        )
#if canImport(CryptoKit)
        XCTAssertEqual(
            original,
            #ObfuscatedString(
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                method: .AES
            )
        )
#endif
    }

    func testBitShift() {
        assertMacroExpansion(
            """
            let string = #ObfuscatedString(
                "hello, こんにちは, 👪",
                method: .bitShift
            )
            """,
            expandedSource: """
            let string = {
                String(
                    bytes: Data([105, 102, 109, 109, 112, 45, 33, 228, 130, 148, 228, 131, 148, 228, 130, 172, 228, 130, 162, 228, 130, 176, 45, 33, 241, 160, 146, 171]).indexed().map { i, c in
                        let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
                        return c &- (1 &+ (0 &* i))
                    },
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )
    }

    func testBitXOR() {
        assertMacroExpansion(
            """
            let string = #ObfuscatedString(
                "hello, こんにちは, 👪",
                method: .bitXOR
            )
            """,
            expandedSource: """
            let string = {
                String(
                    bytes: Data([105, 103, 111, 104, 106, 42, 39, 235, 136, 153, 232, 142, 158, 237, 142, 187, 242, 147, 178, 247, 148, 185, 59, 56, 233, 133, 138, 182]).indexed().map { i, c in
                        let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
                        return c ^ (1 &+ i)
                    },
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )
    }

    func testBase64() {
        assertMacroExpansion(
            """
            let string = #ObfuscatedString(
                "hello, こんにちは, 👪",
                method: .base64
            )
            """,
            expandedSource: """
            let string = {
                String(
                    bytes: Data(base64Encoded: "aGVsbG8sIOOBk+OCk+OBq+OBoeOBrywg8J+Rqg==")!,
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )
    }

#if canImport(CryptoKit)
    func testAES() {
        assertMacroExpansion(
            """
            let string = #ObfuscatedString(
                "hello, こんにちは, 👪",
                method: .AES
            )
            """,
            expandedSource: """
            let string = {
                let sb = try! AES.GCM.SealedBox(combined: Data([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 223, 66, 205, 116, 143, 77, 166, 74, 213, 199, 222, 24, 49, 109, 118, 142, 71, 240, 128, 241, 24, 96, 94, 98, 225, 144, 159, 161, 160, 205, 228, 140, 223, 237, 149, 198, 3, 111, 233, 223, 97, 98, 207, 140])) // sealedBox
                let dd = try! AES.GCM.open(sb, using: SymmetricKey(data: Data([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]))) // decryptedData
                return String(
                    bytes: dd,
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )
    }
#endif

    func testRandomAll() {
        let originalSource = """
        let string = #ObfuscatedString(
            "hello, こんにちは, 👪",
            method: .randomAll
        )
        """

        assertMacroExpansion(
            originalSource,
            expandedSource: """
            let string = {
                String(
                    bytes: Data([105, 102, 109, 109, 112, 45, 33, 228, 130, 148, 228, 131, 148, 228, 130, 172, 228, 130, 162, 228, 130, 176, 45, 33, 241, 160, 146, 171]).indexed().map { i, c in
                        let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
                        return c &- (1 &+ (0 &* i))
                    },
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )

        ObfuscatedString.randomNumberGenerator = TestRandomNumberGenerator(seed: UInt64.max / 4 * 2)
        assertMacroExpansion(
            originalSource,
            expandedSource: """
            let string = {
                String(
                    bytes: Data([150, 154, 108, 109, 109, 47, 36, 230, 135, 148, 235, 139, 153, 232, 141, 166, 237, 142, 177, 242, 147, 188, 56, 53, 230, 136, 137, 179]).indexed().map { i, c in
                        let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
                        return c ^ (254 &+ i)
                    },
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )

        ObfuscatedString.randomNumberGenerator = TestRandomNumberGenerator(seed: UInt64.max / 4 * 3)
        assertMacroExpansion(
            originalSource,
            expandedSource: """
            let string = {
                String(
                    bytes: Data(base64Encoded: "aGVsbG8sIOOBk+OCk+OBq+OBoeOBrywg8J+Rqg==")!,
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )
    }

    func testDiagnosticsEmptyCandidate() {
        assertMacroExpansion(
            """
            let string = #ObfuscatedString(
                "hello, こんにちは, 👪",
                method: .random([])
            )
            """,
            expandedSource: """
            let string = {
                String(
                    bytes: Data([105, 102, 109, 109, 112, 45, 33, 228, 130, 148, 228, 131, 148, 228, 130, 172, 228, 130, 162, 228, 130, 176, 45, 33, 241, 160, 146, 171]).indexed().map { i, c in
                        let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
                        return c &- (1 &+ (0 &* i))
                    },
                    encoding: .utf8
                )!
            }()
            """,
            diagnostics: [
                .init(
                    message: ObfuscateMacroDiagnostic.methodCandidateIsEmpty.message,
                    line: 3,
                    column: 22,
                    severity: .warning
                )
            ],
            macros: macros
        )
    }
}
