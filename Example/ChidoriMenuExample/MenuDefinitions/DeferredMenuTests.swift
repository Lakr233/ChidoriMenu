//
//  DeferredMenuTests.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import UIKit

enum DeferredMenuTests {
    static let deferredMenu: MenuDefinition = .init(
        title: "UIDeferredMenuElement Test",
        menu: .init(children: [
            UIDeferredMenuElement.uncached {
                $0([
                    UIAction(
                        title: "Dynamic Item 1",
                        image: .init(systemName: "wind")
                    ) { _ in
                        showIndicator("Dynamic 1")
                    },
                    UIAction(
                        title: "Dynamic Item 2",
                        image: .init(systemName: "wind")
                    ) { _ in
                        showIndicator("Dynamic 2")
                    },
                    UIDeferredMenuElement.uncached {
                        $0([
                            UIAction(
                                title: "Nested Dynamic 1",
                                image: .init(systemName: "wind")
                            ) { _ in
                                showIndicator("Nested 1")
                            },
                            UIAction(
                                title: "Nested Dynamic 2",
                                image: .init(systemName: "wind"),
                                state: .on
                            ) { _ in
                                showIndicator("Nested 2")
                            },
                        ])
                    },
                ])
            },
        ])
    )

    static let backportMenu: MenuDefinition = .init(
        title: "iOS 14- DeferredMenu Test",
        menu: DeferredMenu.uncached {
            let item = Int.random(in: 1111 ... 9999)
            print("DeferredMenu returning new elements \(item)")
            return UIMenu(title: "DeferredMenu", children: [
                UIAction(title: String(item)) { _ in
                    showIndicator("Random: \(item)")
                },
            ])
        }
    )

    static let allTests: [MenuDefinition] = [
        deferredMenu,
        backportMenu,
    ]
}

private func showIndicator(_ message: String) {
    SPIndicatorView(title: message, preset: .done).present()
}
