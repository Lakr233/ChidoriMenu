//
//  AdvancedExamples.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import UIKit

enum AdvancedExamples {
    // MARK: - Deferred Menu Elements

    static let deferredMenu: MenuDefinition = .init(
        title: "Deferred Menu",
        menu: .init(children: [
            UIDeferredMenuElement.uncached {
                $0([
                    UIAction(title: "Dynamic Action 1", image: UIImage(systemName: "wind")) { _ in
                        showIndicator("Dynamic 1")
                    },
                    UIAction(title: "Dynamic Action 2", image: UIImage(systemName: "wind")) { _ in
                        showIndicator("Dynamic 2")
                    },
                ])
            },
        ])
    )

    // MARK: - Layout Examples

    static let layoutMenu: MenuDefinition = .init(
        title: "Layout Examples",
        menu: .init(children: [
            UIAction(title: "Short text") { _ in
                showIndicator("Short")
            },
            UIAction(title: "Very long text that demonstrates text wrapping and layout adaptation") { _ in
                showIndicator("Long text")
            },
            UIAction(title: "Action with icon", image: UIImage(systemName: "star")) { _ in
                showIndicator("Icon")
            },
            UIAction(title: "Multi-line text that spans across multiple lines for testing vertical centering", image: UIImage(systemName: "text.alignleft")) { _ in
                showIndicator("Multi-line")
            },
        ])
    )

    // MARK: - Production Example

    static let productionMenu: MenuDefinition = .init(
        title: "Production Example",
        menu: UIMenu(
            title: "Select Model",
            options: [.displayInline],
            children: [
                UIMenu(
                    title: "Local Models",
                    options: [.displayInline, .singleSelection],
                    children: [
                        UIAction(title: "Hugging Face") { _ in
                            showIndicator("Hugging Face")
                        },
                        UIAction(title: "Model Scope") { _ in
                            showIndicator("Model Scope")
                        },
                    ]
                ),
                UIMenu(
                    title: "Cloud Models",
                    options: [.displayInline, .singleSelection],
                    children: [
                        UIAction(title: "OpenAI", state: .on) { _ in
                            showIndicator("OpenAI")
                        },
                        UIAction(title: "Claude") { _ in
                            showIndicator("Claude")
                        },
                        UIAction(title: "Gemini") { _ in
                            showIndicator("Gemini")
                        },
                    ]
                ),
            ]
        )
    )

    static let allExamples: [MenuDefinition] = [
        deferredMenu,
        layoutMenu,
        productionMenu,
    ]
}

private func showIndicator(_ message: String) {
    SPIndicatorView(title: message, preset: .done).present()
}
