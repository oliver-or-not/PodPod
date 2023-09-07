//
//  RowActionStyle.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/15.
//

import Foundation

enum RowActionStyle: Int {
    // move only
	case chevronMove
    // move and change something
	case emptyMove
    // change and retreat
    case changeBack
    // change a value
    case change
    // move to URL link
    case link
    // nothing
    case nothing
}
