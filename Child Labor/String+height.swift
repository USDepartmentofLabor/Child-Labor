//
//  String+height.swift
//  Child Labor
//
//  Created by Gnanendra Kumar on 27/07/21.
//  Copyright © 2021 U.S. Department of Labor. All rights reserved.
//

import Foundation
extension String {
func height(constraintedWidth width: CGFloat) -> CGFloat {
    let label =  UILabel(frame: CGRect(x: 100, y: 0, width: width, height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.text = self
    label.sizeToFit()

    return label.frame.height
 }
}
