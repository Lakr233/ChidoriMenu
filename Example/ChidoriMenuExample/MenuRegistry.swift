//
//  MenuRegistry.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import UIKit

struct MenuDefinition {
    let title: String
    let menu: UIMenu
}

enum MenuRegistry {
    static let allMenus: [MenuDefinition] = BasicMenuTests.allTests +
        NestedMenuTests.allTests +
        LongMenuTests.allTests +
        DeferredMenuTests.allTests +
        AttributeTests.allTests +
        LayoutTests.allTests +
        ProductionExamplesTests.allExamples +
        AccessibilityTests.allTests
}
