import ObfuscateSupport

@freestanding(expression)
public macro ObfuscatedString(
    _ string: String,
    method: ObfuscateMethod = .randomAll
) -> String = #externalMacro(module: "ObfuscateMacroPlugin", 
                             type: "ObfuscatedString")
