//
//  NowPlayingLowerSeekBarView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/19.
//

import SwiftUI

struct NowPlayingLowerSeekBarView: View {
    
    var timePassed: Float?
    var totalTime: Float?
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: DesignSystem.Soft.Dimension.timeBarHeight * 0.07)
            
            // time bar
            ZStack {
                Group {
                    if let timePassed, let totalTime {
                        SeekBarView(value: timePassed, base: totalTime)
                    } else {
                        SeekBarView(value: 0.0, base: 1.0)
                    }
                }
                    .frame(width: DesignSystem.Soft.Dimension.timeBarWidth, height: DesignSystem.Soft.Dimension.timeBarHeight)
                    .clipped()
                    .shadow(color: Color(red: 0.6, green: 0.6, blue: 0.6), radius: DesignSystem.Soft.Dimension.w * 0.004, y: DesignSystem.Soft.Dimension.w * 0.0085)
                    
                
            }
            
            Spacer()
                .frame(height: DesignSystem.Soft.Dimension.h * 0.044)
            
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

struct NowPlayingLowerSeekBarView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingLowerSeekBarView(timePassed: 70, totalTime: 280)
    }
}
