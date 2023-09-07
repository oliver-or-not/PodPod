//
//  VIdeoBatterySymbolView.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/05.
//

import SwiftUI

struct VideoBatterySymbolView: View {
    
    var batteryLevel: Float
    
    private var w: CGFloat {
        DesignSystem.Soft.Dimension.w
    }
    
    private var thinValue: CGFloat {
        DesignSystem.Soft.Dimension.basicThinValue
    }
    
    private var innerBatteryWidth: CGFloat {
        w * 0.0739 - 4 * thinValue
    }
    
    private var innerBatteryHeight: CGFloat {
        w * 0.039 - 4 * thinValue
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.black)
                .frame(width: w * 0.0739, height: w * 0.039)
                .opacity(0.08)
            
            HStack(spacing: w * -0.0739 + 2 * thinValue) {
                Rectangle()
                    .fill(.clear)
                    .border(.white, width: thinValue)
                    .frame(width: w * 0.0739, height: w * 0.039)
                    .zIndex(1)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.white)
                        .frame(width: innerBatteryWidth * CGFloat(max(0, batteryLevel)), height: innerBatteryHeight)
                    Spacer().frame(minWidth: 0)
                }
                .frame(width: innerBatteryWidth)
                .zIndex(1)
                
                Rectangle()
                    .fill(.clear)
                    .border(.white, width: thinValue)
                    .frame(width: w * 0.0065 + thinValue, height: w * 0.0195)
                    .offset(x: w * 0.0739 - thinValue)
                    .zIndex(1)
            }
            .shadow(color: Color(red: 0.4, green: 0.4, blue: 0.4), radius: w * 0.001, y: w * 0.0004)
            
            Rectangle()
                .fill(.clear)
                .border(.white, width: thinValue)
                .frame(width: w * 0.0739, height: w * 0.039)
        }
    }
}

struct VideoBatterySymbolView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            
            VStack {
                VideoBatterySymbolView(batteryLevel: 0.8)
                VideoBatterySymbolView(batteryLevel: 0.5)
                VideoBatterySymbolView(batteryLevel: 0.3)
                VideoBatterySymbolView(batteryLevel: 0.1)
                VideoBatterySymbolView(batteryLevel: 0.0)
            }
        }
    }
}
