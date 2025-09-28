//
//  File.swift
//  ChidoriMenu
//
//  Created by qaq on 9/28/25.
//

import UIKit

enum Spring {
    static func animate(
        duration: TimeInterval = 0.5,
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.8,
            animations: animations,
            completion: completion
        )
    }
}
