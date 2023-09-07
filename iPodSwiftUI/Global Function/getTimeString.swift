//
//  getTimeString.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/14.
//

import Foundation

func getTimeString(_ n: Int, blockCount: Int) -> String {
    switch blockCount {
        case 1:
            return "\(n)"
        case 2:
            return String(n / 60) + ":" + String(format: "%02d", n % 60)
        case 3:
            return String(n / 3600) + ":" + String(format: "%02d", (n % 3600) / 60) + ":" + String(format: "%02d", n % 60)
        default:
            return " "
    }
}
