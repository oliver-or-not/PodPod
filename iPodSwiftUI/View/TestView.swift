//
//  TestView.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/07.
//

import SwiftUI

struct TestView: View {
    
    private var w: CGFloat {
        DesignSystem.Soft.Dimension.w
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.white)
                .scaledToFill()
                .frame(width: w * 0.32, height: w * 0.27)
                .clipped()
            
            Text("10:30")
                .font(.system(size: DesignSystem.Soft.Dimension.videoFontSize, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
                .padding([.bottom, .trailing], w * 0.02)
                .shadow(color: .black, radius: w * 0.06)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
