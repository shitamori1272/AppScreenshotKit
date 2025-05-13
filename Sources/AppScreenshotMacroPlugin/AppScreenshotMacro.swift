import SwiftCompilerPlugin
import SwiftSyntaxMacros
import SwiftSyntax

struct AppScreenshotMacro: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {

        guard let structDecl = declaration as? StructDeclSyntax else {
            throw MacroExpansionErrorMessage(
                "AppScreenShot macro can only be applied to structs"
            )
        }

        guard let inheritedTypes = structDecl.inheritanceClause?.inheritedTypes,
              inheritedTypes.contains(where: {
                  $0.type.trimmedDescription.split(separator: ".").last == "View"
              }) else {
            throw MacroExpansionErrorMessage(
                "AppScreenShot macro can only be applied to structs that conform to View"
            )
        }

        let extensions = try ExtensionDeclSyntax("extension \(type): AppScreenshot") {
            DeclSyntax(
                """
                nonisolated static var configuration: AppScreenshotConfiguration { AppScreenshotConfiguration(\(node.arguments)) }
                """
            )

            DeclSyntax(
                """
                @MainActor
                static func body(environment: AppScreenshotEnvironment) -> some View {
                    \(type)().environment(\\.appScreenshotEnvironment, environment)
                }
                """
            )
        }
        return [extensions]
    }
}
