//
//  UIColor+Extensions.swift
//  ImageFeed
//
//  Created by artem on 03.02.2024.
//

import UIKit

extension UIColor {
    static var ypBackground: UIColor {UIColor(named: "YP Background") ?? UIColor.black.withAlphaComponent(50)}
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor.black }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor.white}
    static var ypWhiteAlpha50: UIColor { UIColor(named: "YP White (Alpha 50)") ?? UIColor.white.withAlphaComponent(50)}
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray}
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor.red}
    static var ypBlue: UIColor { UIColor(named: "YP Blue") ?? UIColor.blue}
}
