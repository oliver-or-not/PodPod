//
//  RowView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/23.
//

import SwiftUI

struct RowView: View {
    
    var rowData: (text: String, key: String, style: RowStyle, isShown: Bool)
    var isChosen: Bool
    
    var body: some View {
        ZStack {
            if isChosen {
                VStack(spacing: 0) {
                    Divider()
                        .background(DesignSystem.Soft.Color.chosenRowBottom)
                    LinearGradient(gradient: Gradient(colors: [DesignSystem.Soft.Color.chosenRowTop, DesignSystem.Soft.Color.chosenRowBottom]), startPoint: .top, endPoint: .bottom)
                }
            }
            HStack {
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.basicIndentation)
                Text(rowData.text)
                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                    .foregroundColor(isChosen ? .white : .black)
                Spacer()
                switch rowData.style {
                    case .list:
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.heavy)
                            .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.4)
                            .foregroundColor(isChosen ? .white : .black)
                    case .music:
                        EmptyView()
                    default:
                        EmptyView()
                }
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.basicIndentation)
            }
        }
        .frame(width: DesignSystem.Soft.Dimension.pw, height: DesignSystem.Soft.Dimension.rowHeight)
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(rowData: ("음악", "music", .list, true), isChosen: true)
    }
}
