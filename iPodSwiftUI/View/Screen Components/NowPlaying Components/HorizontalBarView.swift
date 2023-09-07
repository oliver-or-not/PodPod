//
//  HorizontalBarView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/13.
//

import SwiftUI

struct HorizontalBarView: View {
    var value: Float
    var base: Float
    
    private let barColorArray = [
        DesignSystem.Soft.Color.horizontalBarStripe0,
        DesignSystem.Soft.Color.horizontalBarStripe1,
        DesignSystem.Soft.Color.horizontalBarStripe2,
        DesignSystem.Soft.Color.horizontalBarStripe3,
        DesignSystem.Soft.Color.horizontalBarStripe4
    ]
    
    private var glowColorArray: [Color] = []
    
    private let baseColorArray = [
        DesignSystem.Soft.Color.horizontalBarBaseStripe0,
        DesignSystem.Soft.Color.horizontalBarBaseStripe1,
        DesignSystem.Soft.Color.horizontalBarBaseStripe2,
        DesignSystem.Soft.Color.horizontalBarBaseStripe3,
        DesignSystem.Soft.Color.horizontalBarBaseStripe4
    ]
    
    init(value: Float, base: Float) {
        self.value = value
        self.base = base
        
        let tempArray = [DesignSystem.Soft.Color.scrollBarWhiteGlow, Color(.clear)]
        
        for _ in 0..<DesignSystem.Soft.Dimension.horizontalBarWhiteGlowNum {
            glowColorArray += tempArray
        }
        glowColorArray.append(DesignSystem.Soft.Color.scrollBarWhiteGlow)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // value bar
                LinearGradient(colors: barColorArray, startPoint: .top, endPoint: .bottom)
                    .shadow(color: Color(red: 0.6, green: 0.6, blue: 0.6), radius: DesignSystem.Soft.Dimension.w * 0.004, y: DesignSystem.Soft.Dimension.w * 0.0085)
                LinearGradient(colors: glowColorArray, startPoint: .leading, endPoint: .trailing)
                
                
                // base bar covering value bar
                HStack {
                    Spacer()
                        .frame(minWidth: 0)
                    LinearGradient(colors: baseColorArray, startPoint: .top, endPoint: .bottom)
                        .frame(width: geometry.size.width * CGFloat(max(0.0, min(1 - value / base, 1.0))))
                }
            }
        }
    }
}

struct HorizontalBarView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalBarView(value: 80.0, base: 180.0)
    }
}
