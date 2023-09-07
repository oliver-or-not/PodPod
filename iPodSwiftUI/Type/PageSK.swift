//
//  PageSK.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/29.
//

import Foundation
import MusicKit

// Page State Keeper
// when frontier page becomes settled, some published properties are saved in a PageMK instance and the instance is appended on settledPageSKArray
final class PageSK {
    var focusedIndex: Int?
    // start index of discrete scroll 'range' of visible area
    var discreteScrollMark: Int?
    
    init(focusedIndex: Int? = nil, discreteScrollMark: Int? = nil) {
        self.focusedIndex = focusedIndex
        self.discreteScrollMark = discreteScrollMark
    }
}
