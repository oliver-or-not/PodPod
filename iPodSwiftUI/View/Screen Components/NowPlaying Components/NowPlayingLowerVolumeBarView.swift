//
//  NowPlayingLowerVolumeBarView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/19.
//

import SwiftUI

struct NowPlayingLowerVolumeBarView: View {
    
    var volume: Float
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "speaker.wave.1.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .frame(height: DesignSystem.Soft.Dimension.volumeBarHeight * 0.98)
                
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.volumeBarWidth / 50.0)
                
                // volume bar
                HorizontalBarView(value: volume, base: 1.0)
                    .frame(width: DesignSystem.Soft.Dimension.volumeBarWidth, height: DesignSystem.Soft.Dimension.volumeBarHeight)
                
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.volumeBarWidth / 50.0)

                
                Image(systemName: "speaker.wave.3.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .frame(height: DesignSystem.Soft.Dimension.volumeBarHeight * 1.07)
            }
            Spacer()
                .frame(height: DesignSystem.Soft.Dimension.bodyHeight / 7.5)
        }
        .frame(width: DesignSystem.Soft.Dimension.w)
    }
}

struct NowPlayingLowerVolumeBarView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingLowerVolumeBarView(volume: 0.02)
    }
}
