//
//  VideoPausedSymbolView.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/05.
//

import SwiftUI

struct VideoPausedSymbolView: View {
    
    private var w: CGFloat {
        DesignSystem.Soft.Dimension.w
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: w * 0.01)
                .foregroundColor(DesignSystem.Soft.Color.videoBlack)
                .frame(width: w * 0.0956, height: w * 0.0846)

            HStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: w * 0.017, height: w * 0.0478)
                Spacer()
                    .frame(width: w * 0.015)
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: w * 0.017, height: w * 0.0478)
            }
            .shadow(radius: w * 0.001, y: w * 0.005)
        }
    }
}

struct VideoPausedSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPausedSymbolView()
    }
}
