//
//  VideoSeekBarView.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/05.
//

import SwiftUI

struct VideoSeekBarView: View {
    
    var value: CGFloat? // seconds
    var base: CGFloat? // seconds
    
    private var w: CGFloat {
        DesignSystem.Soft.Dimension.w
    }
    
    private var thinValue: CGFloat {
        DesignSystem.Soft.Dimension.basicThinValue
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Capsule()
                    .stroke(DesignSystem.Soft.Color.videoWhite, lineWidth: thinValue)
                    .frame(width: w * 0.846 - thinValue * 0.5, height: w * 0.036 - thinValue * 0.5)
                
                HStack(spacing: 0) {
                    if let value, let base {
                        Rectangle()
                            .fill(DesignSystem.Soft.Color.videoWhite)
                            .frame(width: (w * 0.846 - thinValue * 4) * min(max(0, value / base), 1), height: w * 0.036 - thinValue * 4)
                    } else {
                        Rectangle()
                            .fill(DesignSystem.Soft.Color.videoWhite)
                            .frame(width: 0, height: w * 0.036 - thinValue * 4)
                    }
                    
                    Spacer()
                        .frame(minWidth: 0)
                }
                .frame(width: w * 0.846 - thinValue * 4, height: w * 0.036 - thinValue * 4)
                .clipShape(Capsule())
                .clipped()
            }
            
            Spacer()
                .frame(height: w * 0.0089)
            
            // numeric expression of time
            HStack(spacing: 0) {
                if let value, let base {
                let totalTimeInt = downInt(base)
                let passedTimeInt = downInt(value)
                
                    Spacer()
                        .frame(width: DesignSystem.Soft.Dimension.w * 0.077)
                    
                    Text(getTimeString(passedTimeInt, blockCount: totalTimeInt >= 3600 ? 3 : 2))
                        .font(.system(size: DesignSystem.Soft.Dimension.videoFontSize, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("-" + getTimeString(totalTimeInt - passedTimeInt, blockCount: totalTimeInt >= 3600 ? 3 : 2))
                        .font(.system(size: DesignSystem.Soft.Dimension.videoFontSize, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                        .frame(width: DesignSystem.Soft.Dimension.w * 0.077)
                    
                } else {
                    Spacer()
                        .frame(width: DesignSystem.Soft.Dimension.w * 0.077)
                    
                    Text("-:--")
                        .font(.system(size: DesignSystem.Soft.Dimension.videoFontSize, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("-:--")
                        .font(.system(size: DesignSystem.Soft.Dimension.videoFontSize, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                        .frame(width: DesignSystem.Soft.Dimension.w * 0.077)
                }
            }
        }
        .frame(width: w)
        .shadow(color: Color(red: 0.6, green: 0.6, blue: 0.6), radius: w * 0.002)
    }
}

struct VideoSeekBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            VideoSeekBarView(value: 1240.0, base: 2680.0)
        }
    }
}
