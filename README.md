# ObfuscateMacro

Swift macros for obfuscation

<!-- # Badges -->

[![Github issues](https://img.shields.io/github/issues/p-x9/ObfuscateMacro)](https://github.com/p-x9/ObfuscateMacro/issues)
[![Github forks](https://img.shields.io/github/forks/p-x9/ObfuscateMacro)](https://github.com/p-x9/ObfuscateMacro/network/members)
[![Github stars](https://img.shields.io/github/stars/p-x9/ObfuscateMacro)](https://github.com/p-x9/ObfuscateMacro/stargazers)
[![Github top language](https://img.shields.io/github/languages/top/p-x9/ObfuscateMacro)](https://github.com/p-x9/ObfuscateMacro/)

## Usage

### ObfuscatedString

Obfuscate strings to make them harder to find in binary parsing.

#### Obfuscating Methods

- bit shift
- bit XOR
- base64
- AES
- random
  Randomly selected from the above methods.

#### Simple Usage

Simplest usage is as follows.

At this time, the obfuscation method of the string is randomly selected.

```swift
let string = #ObfuscatedString("Hello")
```

#### Specify Method

```swift
let string = #ObfuscatedString("Hello", method: .bitXOR)
```

#### Random Method

Randomly among all methods.

```swift
let string = #ObfuscatedString("Hello", method: .randomAll)
```

Randomly from among those selected.

```swift
let string = #ObfuscatedString("Hello", method: .random([.bitXOR, .AES]))
```

## License

ObfuscateMacro is released under the MIT License. See [LICENSE](./LICENSE)
