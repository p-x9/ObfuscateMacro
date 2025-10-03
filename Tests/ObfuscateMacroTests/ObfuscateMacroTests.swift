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

    override func setUp() {
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
        XCTAssertEqual(
            "hello, こんにちは, 👪",
            #ObfuscatedString("hello, こんにちは, 👪", method: .AES)
        )
        XCTAssertEqual(
            "hello, こんにちは, 👪",
            #ObfuscatedString("hello, こんにちは, 👪", method: .chaChaPoly)
        )
        XCTAssertEqual(
            "hello, こんにちは, 👪",
            #ObfuscatedString("hello, こんにちは, 👪", repetitions: 5)
        )
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
        XCTAssertEqual(
            original,
            #ObfuscatedString(
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                method: .AES
            )
        )
        XCTAssertEqual(
            original,
            #ObfuscatedString(
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                method: .chaChaPoly
            )
        )
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
                var data = Data([105, 102, 109, 109, 112, 45, 33, 228, 130, 148, 228, 131, 148, 228, 130, 172, 228, 130, 162, 228, 130, 176, 45, 33, 241, 160, 146, 171])

                data = Data(data.indexed().map { i, c in
                    let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
                    return c &- (1 &+ (0 &* i))
                })

                return String(
                    bytes: data,
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
                var data = Data([105, 103, 111, 104, 106, 42, 39, 235, 136, 153, 232, 142, 158, 237, 142, 187, 242, 147, 178, 247, 148, 185, 59, 56, 233, 133, 138, 182])

                data = Data(data.indexed().map { i, c in
                    let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
                    return c ^ (1 &+ i)
                })

                return String(
                    bytes: data,
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
                var data = Data([97, 71, 86, 115, 98, 71, 56, 115, 73, 79, 79, 66, 107, 43, 79, 67, 107, 43, 79, 66, 113, 43, 79, 66, 111, 101, 79, 66, 114, 121, 119, 103, 56, 74, 43, 82, 113, 103, 61, 61])

                data = Data(base64Encoded: String(data: data, encoding: .utf8)!)!

                return String(
                    bytes: data,
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )
    }

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
                var data = Data([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 223, 66, 205, 116, 143, 77, 166, 74, 213, 199, 222, 24, 49, 109, 118, 142, 71, 240, 128, 241, 24, 96, 94, 98, 225, 144, 159, 161, 160, 205, 228, 140, 223, 237, 149, 198, 3, 111, 233, 223, 97, 98, 207, 140])

                data = try! AES.GCM.open(
                    try! AES.GCM.SealedBox(
                        combined: data
                    ),
                    using: SymmetricKey(
                        data: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
                    )
                )

                return String(
                    bytes: data,
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )
    }

    func testChaChaPoly() {
        assertMacroExpansion(
            """
            let string = #ObfuscatedString(
                "hello, こんにちは, 👪",
                method: .chaChaPoly
            )
            """,
            expandedSource: """
            let string = {
                var data = Data([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 153, 75, 135, 67, 211, 253, 144, 12, 70, 91, 197, 211, 13, 174, 59, 142, 242, 253, 96, 128, 122, 165, 138, 125, 34, 142, 193, 51, 49, 47, 130, 63, 235, 244, 3, 78, 29, 224, 83, 27, 251, 252, 78, 226])

                data = try! ChaChaPoly.open(
                    try! ChaChaPoly.SealedBox(
                        combined: data
                    ),
                    using: SymmetricKey(
                        data: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
                    )
                )

                return String(
                    bytes: data,
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )
    }

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
                var data = Data([105, 102, 109, 109, 112, 45, 33, 228, 130, 148, 228, 131, 148, 228, 130, 172, 228, 130, 162, 228, 130, 176, 45, 33, 241, 160, 146, 171])

                data = Data(data.indexed().map { i, c in
                    let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
                    return c &- (1 &+ (0 &* i))
                })

                return String(
                    bytes: data,
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
                var data = Data([97, 71, 86, 115, 98, 71, 56, 115, 73, 79, 79, 66, 107, 43, 79, 67, 107, 43, 79, 66, 113, 43, 79, 66, 111, 101, 79, 66, 114, 121, 119, 103, 56, 74, 43, 82, 113, 103, 61, 61])

                data = Data(base64Encoded: String(data: data, encoding: .utf8)!)!

                return String(
                    bytes: data,
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
                var data = Data([253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 244, 45, 224, 228, 182, 8, 100, 223, 147, 25, 127, 140, 7, 99, 193, 162, 101, 238, 50, 30, 115, 188, 43, 134, 186, 218, 81, 148, 58, 208, 193, 243, 219, 54, 105, 106, 236, 244, 55, 104, 224, 78, 143, 42])

                data = try! AES.GCM.open(
                    try! AES.GCM.SealedBox(
                        combined: data
                    ),
                    using: SymmetricKey(
                        data: [253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253]
                    )
                )

                return String(
                    bytes: data,
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )
    }

    func testRandomAllCrypto() {
        let originalSource = """
        let string = #ObfuscatedString(
            "hello, こんにちは, 👪",
            method: .randomAllCrypto
        )
        """

        assertMacroExpansion(
            originalSource,
            expandedSource: """
            let string = {
                var data = Data([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 223, 66, 205, 116, 143, 77, 166, 74, 213, 199, 222, 24, 49, 109, 118, 142, 71, 240, 128, 241, 24, 96, 94, 98, 225, 144, 159, 161, 160, 205, 228, 140, 223, 237, 149, 198, 3, 111, 233, 223, 97, 98, 207, 140])

                data = try! AES.GCM.open(
                    try! AES.GCM.SealedBox(
                        combined: data
                    ),
                    using: SymmetricKey(
                        data: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
                    )
                )

                return String(
                    bytes: data,
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
                var data = Data([254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 178, 215, 167, 56, 174, 219, 231, 10, 235, 83, 155, 41, 21, 84, 111, 41, 216, 54, 135, 233, 92, 224, 245, 245, 230, 225, 140, 242, 148, 39, 158, 237, 76, 240, 8, 112, 97, 181, 32, 134, 45, 48, 253, 31])

                data = try! AES.GCM.open(
                    try! AES.GCM.SealedBox(
                        combined: data
                    ),
                    using: SymmetricKey(
                        data: [254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254]
                    )
                )

                return String(
                    bytes: data,
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
                var data = Data([253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 52, 126, 79, 230, 217, 73, 41, 70, 155, 200, 205, 161, 254, 173, 137, 51, 107, 26, 16, 41, 40, 51, 165, 75, 114, 184, 77, 30, 7, 241, 119, 239, 165, 111, 218, 186, 226, 131, 106, 112, 244, 45, 49, 131])

                data = try! ChaChaPoly.open(
                    try! ChaChaPoly.SealedBox(
                        combined: data
                    ),
                    using: SymmetricKey(
                        data: [253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253]
                    )
                )

                return String(
                    bytes: data,
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )
    }

    func testRepetitions() {
        assertMacroExpansion(
            """
            let string = #ObfuscatedString(
                "hello, こんにちは, 👪",
                method: .base64,
                repetitions: 5
            )
            """,
            expandedSource: """
            let string = {
                var data = Data([86, 106, 70, 97, 86, 50, 69, 120, 87, 88, 108, 85, 87, 71, 120, 85, 89, 84, 74, 111, 85, 86, 85, 119, 86, 84, 70, 84, 77, 86, 112, 70, 85, 86, 82, 87, 85, 107, 49, 114, 87, 84, 70, 97, 82, 86, 112, 68, 86, 87, 115, 120, 100, 86, 82, 117, 98, 70, 100, 83, 82, 85, 112, 77, 87, 108, 86, 87, 101, 109, 81, 119, 79, 86, 90, 85, 98, 87, 120, 79, 89, 107, 90, 119, 85, 108, 90, 87, 89, 122, 70, 84, 77, 68, 86, 89, 86, 86, 104, 115, 87, 109, 86, 115, 83, 108, 86, 90, 86, 109, 104, 84, 86, 107, 90, 114, 101, 70, 112, 72, 99, 70, 66, 87, 97, 48, 112, 84, 86, 85, 90, 82, 100, 49, 66, 82, 80, 84, 48, 61])

                data = Data(base64Encoded: String(data: data, encoding: .utf8)!)!
                data = Data(base64Encoded: String(data: data, encoding: .utf8)!)!
                data = Data(base64Encoded: String(data: data, encoding: .utf8)!)!
                data = Data(base64Encoded: String(data: data, encoding: .utf8)!)!
                data = Data(base64Encoded: String(data: data, encoding: .utf8)!)!

                return String(
                    bytes: data,
                    encoding: .utf8
                )!
            }()
            """,
            macros: macros
        )
    }

    func testAcceptsUnicodeEscapeSequence() {
        XCTAssertEqual(
            "hello, こんにちは, 👪, †",
            #ObfuscatedString("hello, こんにちは, 👪, \u{2020}", method: .bitShift)
        )
    }

    func testMultilineString() {
        XCTAssertEqual(
            #ObfuscatedString(
            """
            Line 1
            Line 2
            hello, こんにちは, 👪
            3
            """, method: .bitShift),
            """
            Line 1\nLine 2\nhello, こんにちは, 👪\n3
            """.withPlatformNewLine
        )

        XCTAssertEqual(
            #ObfuscatedString("""
            Line 1\nLine 2\nhello, こんにちは, 👪\n3
            """, method: .bitShift),
            """
            Line 1
            Line 2
            hello, こんにちは, 👪
            3
            """.withPlatformNewLine
        )
    }

    func testDiagnosticNonStaticString() {
        assertMacroExpansion(
            """
            let string = #ObfuscatedString(
                "hello, \\(someVarForStringInterpolation), こんにちは, 👪",
                method: .AES
            )
            """,
            expandedSource: """
            let string = {
                var data = Data([])

                data = Data(data.indexed().map { i, c in
                    let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
                    return c &- (1 &+ (0 &* i))
                })

                return String(
                    bytes: data,
                    encoding: .utf8
                )!
            }()
            """,
            diagnostics: [
                .init(
                    message: ObfuscateMacroDiagnostic.stringIsNotStatic.message,
                    line: 2,
                    column: 5,
                    severity: .error
                )
            ],
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
                var data = Data([105, 102, 109, 109, 112, 45, 33, 228, 130, 148, 228, 131, 148, 228, 130, 172, 228, 130, 162, 228, 130, 176, 45, 33, 241, 160, 146, 171])

                data = Data(data.indexed().map { i, c in
                    let i: UTF8.CodeUnit = UTF8.CodeUnit(i % Int(UInt8.max))
                    return c &- (1 &+ (0 &* i))
                })

                return String(
                    bytes: data,
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

extension String {
  var withPlatformNewLine: String {
    #if os(Windows)
      return replacingOccurrences(of: "\n", with: "\r\n")
    #else
      return self
    #endif
  }
}
