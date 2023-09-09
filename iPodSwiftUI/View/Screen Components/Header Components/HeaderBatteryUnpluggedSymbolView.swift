//
//  HeaderBatteryUnpluggedSymbolView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/20.
//

import SwiftUI

struct HeaderBatteryUnpluggedSymbolView: View {
    
    var batteryLevel: Float
    
    private var headerHeight: CGFloat {
        DesignSystem.Soft.Dimension.headerHeight
    }
    
    private let batteryGreenColorArray = [
        DesignSystem.Soft.Color.headerBatteryGreenStripe0,
        DesignSystem.Soft.Color.headerBatteryGreenStripe1,
        DesignSystem.Soft.Color.headerBatteryGreenStripe2,
        DesignSystem.Soft.Color.headerBatteryGreenStripe3,
        DesignSystem.Soft.Color.headerBatteryGreenStripe4
    ]
    
    private let batteryRedColorArray = [
        DesignSystem.Soft.Color.headerBatteryRedStripe0,
        DesignSystem.Soft.Color.headerBatteryRedStripe1,
        DesignSystem.Soft.Color.headerBatteryRedStripe2,
        DesignSystem.Soft.Color.headerBatteryRedStripe3,
        DesignSystem.Soft.Color.headerBatteryRedStripe4
    ]
    
    private let batteryBaseColorArray = [
        DesignSystem.Soft.Color.headerBatteryUnpluggedBaseStripe0,
        DesignSystem.Soft.Color.headerBatteryUnpluggedBaseStripe1
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                // base rectangle
                Rectangle()
                    .fill(LinearGradient(colors: batteryBaseColorArray, startPoint: .top, endPoint: .bottom))
                    .frame(width: headerHeight * 0.92, height: headerHeight * 0.45)

                // value rectangle
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(LinearGradient(colors:
                                                (batteryLevel > 0.2 ? batteryGreenColorArray : batteryRedColorArray), startPoint: .top, endPoint: .bottom))
                        .frame(width: headerHeight * 0.92 * CGFloat(max(0, batteryLevel)), height: headerHeight * 0.45)
                    Spacer()
                        .frame(width: headerHeight * 0.92 * CGFloat(1 - max(0, batteryLevel)), height: headerHeight * 0.45)
                        .frame(minWidth: 0)
                }
                
                // stroke rectangle
                Rectangle()
                    .stroke(DesignSystem.Soft.Color.headerBatteryLine, lineWidth: DesignSystem.Soft.Dimension.basicThinValue)
                    .frame(width: headerHeight * 0.92, height: headerHeight * 0.45)
            }
            
            ZStack {
                Rectangle()
                    .fill(DesignSystem.Soft.Color.headerBatteryUnpluggedBaseStripe1)
                    .frame(width: headerHeight * 0.07, height: headerHeight * 0.18)
                Rectangle()
                    .stroke(DesignSystem.Soft.Color.headerBatteryLine, lineWidth: DesignSystem.Soft.Dimension.basicThinValue)
                    .frame(width: headerHeight * 0.07, height: headerHeight * 0.18)
            }
        }
            
        
    }
}

struct HeaderBatteryUnpluggedSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HeaderBatteryUnpluggedSymbolView(batteryLevel: 1.0)
            HeaderBatteryUnpluggedSymbolView(batteryLevel: 0.7)
            HeaderBatteryUnpluggedSymbolView(batteryLevel: 0.4)
            HeaderBatteryUnpluggedSymbolView(batteryLevel: 0.1)
            HeaderBatteryUnpluggedSymbolView(batteryLevel: -0.5)
            HeaderBatteryUnpluggedSymbolView(batteryLevel: -1.0)
        }
    }
}
