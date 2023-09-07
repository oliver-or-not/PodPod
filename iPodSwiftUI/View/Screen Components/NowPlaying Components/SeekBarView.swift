//
//  SeekBarView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/19.
//

import SwiftUI

struct SeekBarView: View {
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
                // base bar
                LinearGradient(colors: baseColorArray, startPoint: .top, endPoint: .bottom)
                
                // rhombus
                SeekRhombusView()
                    .offset(x: -geometry.size.width * 0.5 + geometry.size.width * CGFloat(max(0.0, min(value / base, 1.0))))
            }
        }
    }
}

struct SeekBarView_Previews: PreviewProvider {
    static var previews: some View {
        SeekBarView(value: 70.0, base: 180.0)
    }
}
