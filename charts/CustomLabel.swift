//
//  CustomLabel.swift
//  Child Labor
//
//  Created by Zolon Tech on 29/06/22.
//  Copyright © 2022 U.S. Department of Labor. All rights reserved.
//

import Foundation
class CustomLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
