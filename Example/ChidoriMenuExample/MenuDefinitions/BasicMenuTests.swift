//
//  BasicMenuTests.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import UIKit

enum BasicMenuTests {
    static let basicMenu: MenuDefinition = .init(
        title: "Basic Menu Set",
        menu: .init(children: [
            UIAction(
                title: "Copy",
                image: UIImage(systemName: "doc.on.doc"),
                state: .on
            ) { _ in
                showIndicator("Copied")
            },
            UIAction(
                title: "Paste",
                image: UIImage(systemName: "doc.on.doc"),
                attributes: .disabled,
                state: .off
            ) { _ in
                showIndicator("Pasted")
            },
            UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                attributes: .destructive,
                state: .mixed
            ) { _ in
                showIndicator("Deleted")
            },
        ])
    )

    static let stateManagementMenu: MenuDefinition = .init(
        title: "State Management Test",
        menu: .init(children: [
            UIAction(
                title: "Option A",
                image: UIImage(systemName: "a.circle"),
                state: .on
            ) { _ in
                showIndicator("Option A selected")
            },
            UIAction(
                title: "Option B",
                image: UIImage(systemName: "b.circle"),
                state: .off
            ) { _ in
                showIndicator("Option B selected")
            },
            UIAction(
                title: "Option C",
                image: UIImage(systemName: "c.circle"),
                state: .mixed
            ) { _ in
                showIndicator("Option C selected")
            },
            UIMenu(
                title: "Advanced Options",
                options: [.displayInline],
                children: [
                    UIAction(
                        title: "Sub Option 1",
                        state: .on
                    ) { _ in
                        showIndicator("Sub Option 1")
                    },
                    UIAction(
                        title: "Sub Option 2",
                        state: .off
                    ) { _ in
                        showIndicator("Sub Option 2")
                    },
                ]
            ),
        ])
    )

    static let allTests: [MenuDefinition] = [
        basicMenu,
        stateManagementMenu,
    ]
}

private func showIndicator(_ message: String) {
    SPIndicatorView(title: message, preset: .done).present()
}
