import ObfuscateSupport

@freestanding(expression)
public macro ObfuscatedString(
    _ string: StaticString,
    method: ObfuscateMethod = .randomAll,
    repetitions: Int = 1
) -> String = #externalMacro(module: "ObfuscateMacroPlugin",
                             type: "ObfuscatedString")
