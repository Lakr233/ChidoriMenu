//
//  DeferredMenu.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 5/19/25.
//

import Foundation
import UIKit

// it does not actually supports caching & async update
public class DeferredMenu: UIMenu {
    var menuProvider: () -> UIMenu = { .init() }

    // dont use init, it will crash on sym lookup
}

public extension DeferredMenu {
    static func uncached(_ menuProvider: @escaping () -> UIMenu) -> DeferredMenu {
        let menu = DeferredMenu()
        menu.menuProvider = menuProvider
        return menu
    }
}
