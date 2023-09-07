//
//  HeaderPlayingSymbolView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/20.
//

import SwiftUI

struct HeaderPlayingSymbolView: View {
    
    let playingColorVerticalArray = [
        DesignSystem.Soft.Color.playingStateStripe0,
        DesignSystem.Soft.Color.playingStateStripe0,
        DesignSystem.Soft.Color.playingStateStripe3,
        DesignSystem.Soft.Color.playingStateStripe0,
        DesignSystem.Soft.Color.playingStateStripe0,
    ]
    
    let playingColorHorizontalArray = [
        DesignSystem.Soft.Color.playingStateStripe3,
        DesignSystem.Soft.Color.playingStateStripe1,
        DesignSystem.Soft.Color.playingStateStripe1
    ]
    
    var headerHeight: CGFloat {
        DesignSystem.Soft.Dimension.headerHeight
    }
    
    var body: some View {
        
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: headerHeight * 0.08, y: headerHeight * 0.22))
                path.addLine(to: CGPoint(x: headerHeight * 0.08, y: headerHeight * 0.77))
                path.addLine(to: CGPoint(x: headerHeight * 0.62, y: headerHeight * 0.495))
                path.closeSubpath()
            }
            .fill(LinearGradient(colors: playingColorVerticalArray, startPoint: .top, endPoint: .bottom))
            Path { path in
                path.move(to: CGPoint(x: headerHeight * 0.08, y: headerHeight * 0.22))
                path.addLine(to: CGPoint(x: headerHeight * 0.08, y: headerHeight * 0.77))
                path.addLine(to: CGPoint(x: headerHeight * 0.62, y: headerHeight * 0.495))
                path.closeSubpath()
            }
            .fill(LinearGradient(colors: playingColorHorizontalArray, startPoint: .leading, endPoint: .trailing))
            .opacity(0.6)
        }.frame(width: headerHeight * 0.8)
    }
}

struct HeaderPlayingSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderPlayingSymbolView()
    }
}
