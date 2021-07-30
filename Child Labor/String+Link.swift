//
//  String+Link.swift
//  Child Labor
//
//  Created by Gnanendra Kumar on 23/07/21.
//  Copyright © 2021 U.S. Department of Labor. All rights reserved.
//

import Foundation
extension NSMutableAttributedString {

    public func SetAsLink(textToFind:String, linkURL:String) {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
        }
    }
    
}
