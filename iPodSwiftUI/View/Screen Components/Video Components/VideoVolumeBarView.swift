//
//  VideoVolumeBarView.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/05.
//

import SwiftUI

struct VideoVolumeBarView: View {
    var value: Float
    var base: Float
    
    private var w: CGFloat {
        DesignSystem.Soft.Dimension.w
    }
    
    private var thinValue: CGFloat {
        DesignSystem.Soft.Dimension.basicThinValue
    }
    
    private var barInnerWidth: CGFloat {
        w * 0.743 - 4 * thinValue
    }
    
    private var barInnerHeight: CGFloat {
        w * 0.036 - 4 * thinValue
    }
    
    
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "speaker.wave.1.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: DesignSystem.Soft.Dimension.volumeBarHeight * 0.98)
            
            Spacer()
                .frame(width: DesignSystem.Soft.Dimension.volumeBarWidth / 50.0)
            
            // volume bar
            ZStack {
                Rectangle()
                    .fill(.clear)
                    .border(DesignSystem.Soft.Color.videoWhite, width: thinValue)
                    .frame(width: w * 0.743, height: w * 0.036)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(DesignSystem.Soft.Color.videoWhite)
                        .frame(width: barInnerWidth * CGFloat(min(max(0, value / base), 1)), height: barInnerHeight)
                    
                    Spacer()
                        .frame(minWidth: 0)
                }
                .frame(width: barInnerWidth, height: barInnerHeight)
            }
            
            Spacer()
                .frame(width: DesignSystem.Soft.Dimension.volumeBarWidth / 50.0)
            
            Image(systemName: "speaker.wave.3.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: DesignSystem.Soft.Dimension.volumeBarHeight * 1.07)
        }
        .frame(width: w)
        .shadow(color: Color(red: 0.6, green: 0.6, blue: 0.6), radius: w * 0.002)
    }
}

struct VideoVolumeBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            VideoVolumeBarView(value: 4.0, base: 10.0)
        }
    }
}
