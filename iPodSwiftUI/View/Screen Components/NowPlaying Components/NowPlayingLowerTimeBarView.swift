//
//  NowPlayingLowerTimeBarView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/15.
//

import SwiftUI

struct NowPlayingLowerTimeBarView: View {
    
    var timePassed: Float?
    var totalTime: Float?
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: DesignSystem.Soft.Dimension.timeBarHeight * 0.07)
            
            // time bar
            Group {
                if let timePassed, let totalTime {
                    HorizontalBarView(value: timePassed, base: totalTime)
                } else {
                    HorizontalBarView(value: 0.0, base: 1.0)
                }
            }
                .frame(width: DesignSystem.Soft.Dimension.timeBarWidth, height: DesignSystem.Soft.Dimension.timeBarHeight)
            
            Spacer()
                .frame(height: DesignSystem.Soft.Dimension.w * 0.75 * 0.044)
            
            // numeric expression of time
            HStack(spacing: 0) {
                if let timePassed, let totalTime {
                    let totalTimeInt = Int(totalTime)
                    let passedTimeInt = Int(timePassed)
                    
                    Spacer()
                        .frame(width: DesignSystem.Soft.Dimension.nowPlayingHorizontalIndentation * 1.1)
                    
                    Text(getTimeString(passedTimeInt, blockCount: totalTimeInt >= 3600 ? 3 : 2))
                        .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                        .foregroundColor(.black)
                    Spacer()
                    Text("-" + getTimeString(totalTimeInt - passedTimeInt, blockCount: totalTimeInt >= 3600 ? 3 : 2))
                        .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                        .frame(width: DesignSystem.Soft.Dimension.nowPlayingHorizontalIndentation * 1.1)
                } else {
                    Spacer()
                        .frame(width: DesignSystem.Soft.Dimension.nowPlayingHorizontalIndentation * 1.1)
                    
                    Text("-:--")
                        .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                        .foregroundColor(.black)
                    Spacer()
                    Text("-:--")
                        .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                        .frame(width: DesignSystem.Soft.Dimension.nowPlayingHorizontalIndentation * 1.1)
                }
            }
        }
        .frame(width: DesignSystem.Soft.Dimension.w)
        
    }
}

struct NowPlayingLowerTimeBarView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingLowerTimeBarView(timePassed: 80, totalTime: 150)
    }
}
