//
//  VideoPlayingSymbolView.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/05.
//

import SwiftUI

struct VideoPlayingSymbolView: View {
    
    private var w: CGFloat {
        DesignSystem.Soft.Dimension.w
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: w * 0.01)
                .foregroundColor(DesignSystem.Soft.Color.videoBlack)
                .frame(width: w * 0.0956, height: w * 0.0846)
            
            Image(systemName: "play.fill")
                .resizable()
                .scaledToFit()
                .frame(width: w * 0.1, height: w * 0.049)
                .scaleEffect(x: 1.15, anchor: .center)
                .foregroundColor(.white)
                .shadow(radius: w * 0.001, y: w * 0.005)
        }
    }
}

struct VideoPlayingSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayingSymbolView()
    }
}
