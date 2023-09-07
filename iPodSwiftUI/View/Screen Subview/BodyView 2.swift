//
//  BodyView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/18.
//

import SwiftUI

struct BodyView: View {
    
    var key: String
    var rowNum: Int
    var style: BodyViewStyle?
    var rowData: [(text: String, key: String, style: RowStyle, isShown: Bool)]?
    
    var body: some View {
        Group {
            switch style {
                case .list:
                    VStack(spacing: 0) {
                        if let rowData {
                            VStack(spacing: 0) {
                                ForEach(0..<rowData.count) { i in
                                    RowView(rowData: rowData[i], isChosen: i == rowNum ? true : false)
                                }
                            }
                        } else {
                            Text("Empty")
                        }
                        Spacer()
                    }
                default:
                    Color(.cyan)
            }
        }
        .frame(width: DesignSystem.Soft.Dimension.pw, height: DesignSystem.Soft.Dimension.bodyHeight)
    }
}

struct BodyView_Previews: PreviewProvider {
    static var previews: some View {
        BodyView(key: "iPod", rowNum: 0, style: .list, rowData: [("음악", "music", .list, true),
                                                                 ("사진", "photo", .list, true),
                                                                 ("비디오", "video", .list, true),
                                                                 ("기타", "else", .list, true),
                                                                 ("설정", "setting", .list, true),
                                                                 ("노래 임의 재생", "musicRandomPlay", .music, true)])
    }
}
