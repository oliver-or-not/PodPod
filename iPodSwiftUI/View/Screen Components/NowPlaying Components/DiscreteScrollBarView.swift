//
//  DiscreteScrollBarView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/03.
//

import SwiftUI

struct DiscreteScrollBarView: View {
    var focusedIndex: Int
    var discreteScrollMark: Int
    var rowCount: Int
    var range: Int
    
    let blueStripeColorArray: [Color] = [
        DesignSystem.Soft.Color.scrollBarStripe0,
        DesignSystem.Soft.Color.scrollBarStripe1,
        DesignSystem.Soft.Color.scrollBarStripe2,
        DesignSystem.Soft.Color.scrollBarStripe3,
        DesignSystem.Soft.Color.scrollBarStripe4
    ]
    private var whiteGlowArray: [Color] = []
    
    init(focusedIndex: Int, discreteScrollMark: Int, rowCount: Int, range: Int) {
        self.focusedIndex = focusedIndex
        self.discreteScrollMark = discreteScrollMark
        self.rowCount = rowCount
        self.range = range
        
        for _ in 0..<DesignSystem.Soft.Dimension.scrollBarWhiteGlowNum {
            self.whiteGlowArray += [.clear, DesignSystem.Soft.Color.scrollBarWhiteGlow]
        }
    }
    
    
    var body: some View {
        ZStack {
            // bar
            ZStack {
                // blue gradient stripe
                HStack(spacing: 0) {
                    LinearGradient(colors: blueStripeColorArray, startPoint: .leading, endPoint: .trailing)
                    DesignSystem.Soft.Color.scrollBarStripeLine
                        .frame(width: DesignSystem.Soft.Dimension.basicThinValue)
                }
                // white glow
                LinearGradient(colors: whiteGlowArray, startPoint: .top, endPoint: .bottom)
            }
            // non-bar
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    DesignSystem.Soft.Color.scrollBarBaseLeadingLine
                        .frame(width: DesignSystem.Soft.Dimension.basicThinValue)
                    LinearGradient(colors: [DesignSystem.Soft.Color.scrollBarBaseLeading, DesignSystem.Soft.Color.scrollBarBaseTrailing], startPoint: .leading, endPoint: .trailing)
                }
                .frame(height: DesignSystem.Soft.Dimension.bodyHeight * CGFloat(discreteScrollMark) / CGFloat(rowCount))
                Spacer()
                    .frame(minWidth: 0)
                HStack(spacing: 0) {
                    DesignSystem.Soft.Color.scrollBarBaseLeadingLine
                        .frame(width: DesignSystem.Soft.Dimension.basicThinValue)
                    LinearGradient(colors: [DesignSystem.Soft.Color.scrollBarBaseLeading, DesignSystem.Soft.Color.scrollBarBaseTrailing], startPoint: .leading, endPoint: .trailing)
                }
                .frame(height: DesignSystem.Soft.Dimension.bodyHeight * CGFloat(rowCount - min(discreteScrollMark + range, rowCount)) / CGFloat(rowCount))
            }
        }
        .frame(width: DesignSystem.Soft.Dimension.scrollBarWidth, height: DesignSystem.Soft.Dimension.bodyHeight)
    }
}

struct DiscreteScrollBarView_Previews: PreviewProvider {
    static var previews: some View {
        DiscreteScrollBarView(focusedIndex: 0, discreteScrollMark: 0, rowCount: 15, range: DesignSystem.Soft.Dimension.rangeOfRows)
    }
}
