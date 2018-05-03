//
//  UITextFieldControllerExtension.swift
//  ScreenSaver
//
//  Created by madomedu on 2018-05-03.
//  Copyright © 2018 madomedu. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    /// Sets a delay
    /// After the specified delay has been met, execute the closure
    ///
    /// - Parameters:
    ///   - delay: time until closure should be executed
    ///   - closure: function to be executeed aftere delay
    func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}

