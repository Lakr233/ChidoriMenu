//
//  LongMenuTests.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import UIKit

enum LongMenuTests {
    static let longMenu: MenuDefinition = .init(
        title: "Long Menu Set",
        menu: .init(title: "Root Menu", children: [
            UIAction(title: "Copy 1", image: UIImage(systemName: "doc.on.doc")) { _ in
                showIndicator("Copied 1")
            },
            UIAction(title: "Paste 1", image: UIImage(systemName: "doc.on.doc"), attributes: .disabled) { _ in
                showIndicator("Pasted 1")
            },
            UIAction(title: "Delete 1", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                showIndicator("Deleted 1")
            },
            UIMenu(
                options: [.displayInline],
                children: [
                    UIAction(title: "Copy 2", image: UIImage(systemName: "doc.on.doc")) { _ in
                        showIndicator("Copied 2")
                    },
                    UIAction(title: "Paste 2", image: UIImage(systemName: "doc.on.doc"), attributes: .disabled) { _ in
                        showIndicator("Pasted 2")
                    },
                    UIAction(title: "Delete 2", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                        showIndicator("Deleted 2")
                    },
                ]
            ),
            UIMenu(
                options: [.displayInline],
                children: [
                    UIAction(title: "Copy 3", image: UIImage(systemName: "doc.on.doc")) { _ in
                        showIndicator("Copied 3")
                    },
                    UIAction(title: "Paste 3", image: UIImage(systemName: "doc.on.doc"), attributes: .disabled) { _ in
                        showIndicator("Pasted 3")
                    },
                    UIAction(title: "Delete 3", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                        showIndicator("Deleted 3")
                    },
                ]
            ),
            UIMenu(
                title: "Submenu",
                children: [
                    UIAction(title: "Copy 4", image: UIImage(systemName: "doc.on.doc")) { _ in
                        showIndicator("Copied 4")
                    },
                    UIAction(title: "Paste 4", image: UIImage(systemName: "doc.on.doc"), attributes: .disabled) { _ in
                        showIndicator("Pasted 4")
                    },
                    UIAction(title: "Delete 4", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                        showIndicator("Deleted 4")
                    },
                ]
            ),
        ])
    )

    static let allTests: [MenuDefinition] = [
        longMenu,
    ]
}

private func showIndicator(_ message: String) {
    SPIndicatorView(title: message, preset: .done).present()
}
