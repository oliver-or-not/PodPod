//
//  PageData.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/29.
//

import Foundation

final class PageData {
    var headerTitle: String
    var pageBodyStyle: PageBodyStyle
    var rowDataArray: [RowData]?
    
    init(headerTitle: String = "-", pageBodyStyle: PageBodyStyle = .empty, rowDataArray: [RowData]? = nil) {
        self.pageBodyStyle = pageBodyStyle
        self.headerTitle = headerTitle
        self.rowDataArray = rowDataArray
    }
}
