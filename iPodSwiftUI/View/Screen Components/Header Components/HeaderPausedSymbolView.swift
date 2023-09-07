//
//  HeaderPausedSymbolView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/20.
//

import SwiftUI

struct HeaderPausedSymbolView: View {
    
    let pausedColorArray = [
        DesignSystem.Soft.Color.playingStateStripe2,
        DesignSystem.Soft.Color.playingStateStripe3,
        DesignSystem.Soft.Color.playingStateStripe2
    ]
    
    var headerHeight: CGFloat {
        DesignSystem.Soft.Dimension.headerHeight
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            Spacer()
                .frame(width: headerHeight * 0.05)
            Rectangle()
                .fill(LinearGradient(colors: pausedColorArray, startPoint: .top, endPoint: .bottom))
                .frame(width: headerHeight * 0.19, height: headerHeight * 0.51)
            Spacer()
                .frame(width: headerHeight * 0.14)
            Rectangle()
                .fill(LinearGradient(colors: pausedColorArray, startPoint: .top, endPoint: .bottom))
                .frame(width: headerHeight * 0.19, height: headerHeight * 0.51)
        }
    }
}

struct HeaderPausedSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderPausedSymbolView()
    }
}
