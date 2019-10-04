//
//  UIColor+Nordic.swift
//  nRFMeshProvision_Example
//
//  Created by Aleksander Nowakowski on 01/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection) -> UIColor in
                return traitCollection.userInterfaceStyle == .light ? light : dark
            }
        } else {
            return light
        }
    }
    
    static let nordicBlue = #colorLiteral(red: 0, green: 0.7181802392, blue: 0.8448022008, alpha: 1)
    
    static let nordicLake = #colorLiteral(red: 0, green: 0.5483048558, blue: 0.8252354264, alpha: 1)
    
    static let nordicRed = #colorLiteral(red: 0.9567440152, green: 0.2853084803, blue: 0.3770255744, alpha: 1)
    static let nordicRedDark = #colorLiteral(red: 0.8138422955, green: 0.24269408, blue: 0.3188471754, alpha: 1)
    
    static let nordicSun = #colorLiteral(red: 1, green: 0.8319787979, blue: 0, alpha: 1)
    static let nordicGrass = #colorLiteral(red: 0.8486783504, green: 0.8850693107, blue: 0, alpha: 1)
    static let nordicFall = #colorLiteral(red: 0.9759542346, green: 0.5849055648, blue: 0.2069504261, alpha: 1)
    
    static let nordicDarkGray = #colorLiteral(red: 0.2590435743, green: 0.3151275516, blue: 0.353839159, alpha: 1)
    static let nordicMediumGray = #colorLiteral(red: 0.5353743434, green: 0.5965531468, blue: 0.6396299005, alpha: 1)
    static let nordicLightGray = #colorLiteral(red: 0.8790807724, green: 0.9051030278, blue: 0.9087315202, alpha: 1)
    
    static let almostWhite = #colorLiteral(red: 0.8550526997, green: 0.8550526997, blue: 0.8550526997, alpha: 1)
    
    static let tableViewSeparator = #colorLiteral(red: 0.8243665099, green: 0.8215891719, blue: 0.8374734521, alpha: 1)
    static let tableViewBackground = #colorLiteral(red: 0.9499699473, green: 0.9504894614, blue: 0.965736568, alpha: 1)
}
