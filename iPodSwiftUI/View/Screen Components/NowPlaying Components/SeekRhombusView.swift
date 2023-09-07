//
//  SeekRhombusView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/19.
//

import SwiftUI

struct SeekRhombusView: View {
    
    private let barColorArray = [
        DesignSystem.Soft.Color.horizontalBarStripe0,
        DesignSystem.Soft.Color.horizontalBarStripe1,
        DesignSystem.Soft.Color.horizontalBarStripe2,
        DesignSystem.Soft.Color.horizontalBarStripe3,
        DesignSystem.Soft.Color.horizontalBarStripe4
    ]
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(colors: barColorArray, startPoint: .topTrailing, endPoint: .bottomLeading))
                .frame(width: DesignSystem.Soft.Dimension.timeBarHeight * 0.68, height: DesignSystem.Soft.Dimension.timeBarHeight * 0.68)
                .rotationEffect(Angle(degrees: -45))
            
            Rectangle()
                .stroke(.black, lineWidth: DesignSystem.Soft.Dimension.basicThinValue * 0.707)
                .frame(width: DesignSystem.Soft.Dimension.timeBarHeight * 0.68, height: DesignSystem.Soft.Dimension.timeBarHeight * 0.68)
                .rotationEffect(Angle(degrees: -45))
        }
    }
}

struct SeekRhombusView_Previews: PreviewProvider {
    static var previews: some View {
        SeekRhombusView()
    }
}
