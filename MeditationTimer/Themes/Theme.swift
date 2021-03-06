//
//  Themes.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import Foundation
import UIKit

// Defines different user-available themes
struct Theme {
    
    static let availableThemes = ["Dark", "Black", "Light"]
    static let themes: [String: Theme] = [
        "Dark": Theme(background: UIColor(hex: "222426"),
                      text: UIColor(hex: "c9cacc"),
                      textLight: UIColor(hex: "cccccc"),
                      textLighter: UIColor(hex: "eeeeee"),
                      accent: UIColor(hex: "ed7615"),
                      cell: UIColor(red:0.20, green:0.21, blue:0.22, alpha:1.0),
                      cellSelected: UIColor(red:0.30, green:0.31, blue:0.52, alpha:1.0),
                      nagivationBar: UIColor(red:0.03, green:0.04, blue:0.05, alpha:1.0),
                      statusBar: UIStatusBarStyle.lightContent,
                      keyboard: UIKeyboardAppearance.dark,
                      imageTheme: .light),
        "Black": Theme(background: UIColor.black,
                      text: UIColor(hex: "c9cacc"),
                      textLight: UIColor(hex: "cccccc"),
                      textLighter: UIColor(hex: "eeeeee"),
                      accent: UIColor(hex: "ed931f"),
                      cell: UIColor(red:0.06, green:0.07, blue:0.08, alpha:1.0),
                      cellSelected: UIColor(red:0.30, green:0.31, blue:0.52, alpha:1.0),
                      nagivationBar: UIColor(red:0.02, green:0.03, blue:0.04, alpha:1.0),
                      statusBar: UIStatusBarStyle.lightContent,
                      keyboard: UIKeyboardAppearance.dark,
                      imageTheme: .light),
        "Light": Theme(background: UIColor(hex: "efeff4"),
                      text: UIColor.darkGray,
                      textLight: UIColor.gray,
                      textLighter: UIColor.lightGray,
                      accent: UIColor(hex: "3766b2"),
                      cell: UIColor.white,
                      cellSelected: UIColor(hex: "d9d9d9"),
                      nagivationBar: UIColor(hex: "f7f7f8"),
                      statusBar: UIStatusBarStyle.default,
                      keyboard: UIKeyboardAppearance.light,
                      imageTheme: .dark),
        "Blue": Theme(background: UIColor(hex: "2F3F73"),
                       text: UIColor.darkGray,
                       textLight: UIColor.gray,
                       textLighter: UIColor.lightGray,
                       accent: UIColor(hex: "0C173A"),
                       cell: UIColor.white,
                       cellSelected: UIColor(hex: "d9d9d9"),
                       nagivationBar: UIColor(hex: "000001"),
                       statusBar: UIStatusBarStyle.lightContent,
                       keyboard: UIKeyboardAppearance.dark,
                       imageTheme: .light)
    ]
    static var currentTheme: Theme {
        return Theme.themes[UserDefaults.standard.string(forKey: DefaultsKeys.theme) ?? Theme.themes.keys.first!] ?? Theme.themes.first!.value
    }
    
    let background: UIColor
    let text: UIColor
    let textLight: UIColor
    let textLighter: UIColor
    let accent: UIColor
    let cell: UIColor
    let cellSelected: UIColor
    let nagivationBar: UIColor
    let statusBar: UIStatusBarStyle
    let keyboard: UIKeyboardAppearance
    let imageTheme: ImageTheme
}


// UIColor hex extension
// from: https://crunchybagel.com/working-with-hex-colors-in-swift-3/
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
