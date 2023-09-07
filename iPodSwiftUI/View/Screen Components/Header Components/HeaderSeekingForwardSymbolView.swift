//
//  HeaderSeekingForwardSymbolView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/20.
//

import SwiftUI

struct HeaderSeekingForwardSymbolView: View {
    
    let fastArray = [
        DesignSystem.Soft.Color.playingStateStripe1,
        DesignSystem.Soft.Color.playingStateStripe1,
        DesignSystem.Soft.Color.playingStateStripe1,
        DesignSystem.Soft.Color.playingStateStripe3,
        DesignSystem.Soft.Color.playingStateStripe1,
        DesignSystem.Soft.Color.playingStateStripe1,
        DesignSystem.Soft.Color.playingStateStripe1
    ]
    
    var headerHeight: CGFloat {
        DesignSystem.Soft.Dimension.headerHeight
    }
    
    var body: some View {
        ZStack() {
            Path { path in
                path.move(to: CGPoint(x: headerHeight * 0.05, y: headerHeight * 0.295))
                path.addLine(to: CGPoint(x: headerHeight * 0.05, y: headerHeight * 0.695))
                path.addLine(to: CGPoint(x: headerHeight * 0.415, y: headerHeight * 0.495))
                path.closeSubpath()
            }
            .fill(LinearGradient(colors: fastArray, startPoint: .top, endPoint: .bottom))
            
            Path { path in
                path.move(to: CGPoint(x: headerHeight * 0.38, y: headerHeight * 0.295))
                path.addLine(to: CGPoint(x: headerHeight * 0.38, y: headerHeight * 0.695))
                path.addLine(to: CGPoint(x: headerHeight * 0.745, y: headerHeight * 0.495))
                path.closeSubpath()
            }
            .fill(LinearGradient(colors: fastArray, startPoint: .top, endPoint: .bottom))
        }
    }
}

struct HeaderSeekingForwardSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderSeekingForwardSymbolView()
    }
}
