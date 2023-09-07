//
//  downInt.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/29.
//

import Foundation

func downInt(_ x: CGFloat) -> Int {
    if x >= 0 {
        return Int(x)
    } else {
        return Int(x) - 1
    }
}
