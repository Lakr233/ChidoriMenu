//
//  AccessibilityTests.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import UIKit

enum AccessibilityTests {
    static let accessibilityMenu: MenuDefinition = .init(
        title: "Accessibility Test",
        menu: .init(children: [
            UIAction(
                title: "VoiceOver Friendly Action",
                image: UIImage(systemName: "speaker.wave.2")
            ) { _ in
                showIndicator("VoiceOver Action")
            },
            UIAction(
                title: "High Contrast Mode Test",
                image: UIImage(systemName: "eye")
            ) { _ in
                showIndicator("High Contrast")
            },
            UIAction(
                title: "Large Text Support",
                image: UIImage(systemName: "textformat.size")
            ) { _ in
                showIndicator("Large Text")
            },
            UIAction(
                title: "Reduced Motion Test",
                image: UIImage(systemName: "hare")
            ) { _ in
                showIndicator("Reduced Motion")
            },
        ])
    )

    static let screenReaderMenu: MenuDefinition = .init(
        title: "Screen Reader Test",
        menu: .init(children: [
            UIAction(
                title: "Action with clear description",
                image: UIImage(systemName: "checkmark.circle")
            ) { _ in
                showIndicator("Clear action")
            },
            UIAction(
                title: "Complex action with detailed explanation",
                image: UIImage(systemName: "info.circle")
            ) { _ in
                showIndicator("Complex action")
            },
            UIAction(
                title: "Destructive action - will delete item",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                showIndicator("Delete action")
            },
            UIAction(
                title: "Disabled action - not available",
                image: UIImage(systemName: "xmark.circle"),
                attributes: .disabled
            ) { _ in
                showIndicator("Should not appear")
            },
        ])
    )

    static let dynamicTypeMenu: MenuDefinition = .init(
        title: "Dynamic Type Test",
        menu: .init(children: [
            UIAction(
                title: "Short text",
                image: UIImage(systemName: "text.alignleft")
            ) { _ in
                showIndicator("Short")
            },
            UIAction(
                title: "Medium length text that should adapt to different font sizes",
                image: UIImage(systemName: "text.aligncenter")
            ) { _ in
                showIndicator("Medium")
            },
            UIAction(
                title: "Very long text that demonstrates how dynamic type affects menu layout and readability across different accessibility settings",
                image: UIImage(systemName: "text.alignright")
            ) { _ in
                showIndicator("Long")
            },
        ])
    )

    static let allTests: [MenuDefinition] = [
        accessibilityMenu,
        screenReaderMenu,
        dynamicTypeMenu,
    ]
}

private func showIndicator(_ message: String) {
    SPIndicatorView(title: message, preset: .done).present()
}
