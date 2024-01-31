//
//  ProgressHUD+Extentions.swift
//  ImageFeed
//
//  Created by artem on 30.01.2024.
//

import Foundation
import ProgressHUD

extension ProgressHUD {
    static func setup() {
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .lightGray
    }
}
