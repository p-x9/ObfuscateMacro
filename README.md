# ObfuscateMacro

Swift macros for string obfuscation to protect sensitive data from binary analysis.

<!-- # Badges -->

[![Github issues](https://img.shields.io/github/issues/p-x9/ObfuscateMacro)](https://github.com/p-x9/ObfuscateMacro/issues)
[![Github forks](https://img.shields.io/github/forks/p-x9/ObfuscateMacro)](https://github.com/p-x9/ObfuscateMacro/network/members)
[![Github stars](https://img.shields.io/github/stars/p-x9/ObfuscateMacro)](https://github.com/p-x9/ObfuscateMacro/stargazers)
[![Github top language](https://img.shields.io/github/languages/top/p-x9/ObfuscateMacro)](https://github.com/p-x9/ObfuscateMacro/)

## Overview

ObfuscateMacro transforms your strings at compile-time into obfuscated data, with runtime decoding when accessed. Each macro execution uses a different random seed, ensuring that only obfuscated data exists in your binary.

## Installation

In Xcode, add ObfuscateMacro as a Swift Package dependency to your project:
1. File → Add Package Dependencies
2. Enter: `https://github.com/p-x9/ObfuscateMacro.git`
3. Select version: `0.10.0` or higher

## Usage

Import and use the macro:
```swift
import ObfuscateMacro

let text = #ObfuscatedString("hello")
```

### Obfuscation Methods

Available methods:
- **bit shift**: Applies bit shifting operations
- **bit XOR**: Uses XOR operations
- **base64**: Base64 encoding with additional obfuscation
- **AES**: AES encryption
- **random**: Randomly selects from above methods

#### Specify Method
```swift
let string = #ObfuscatedString("Hello", method: .bitXOR)
```

#### Random Selection
```swift
// Use any method
let string = #ObfuscatedString("Hello", method: .randomAll)

// Choose from specific methods
let string = #ObfuscatedString("Hello", method: .random([.bitXOR, .AES]))
```

### Enhanced Security

Apply multiple layers of obfuscation:
```swift
#ObfuscatedString(
    "hello",
    repetitions: 5
)
```

## Best Practices

Use this macro for sensitive data like API keys, tokens, and internal URLs. While obfuscation adds protection, remember it's just one part of a complete security strategy.

## License

ObfuscateMacro is released under the MIT License. See [LICENSE](./LICENSE)
