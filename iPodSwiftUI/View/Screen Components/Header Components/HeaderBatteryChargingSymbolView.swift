//
//  HeaderBatteryChargingSymbolView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/20.
//

import SwiftUI

struct HeaderBatteryChargingSymbolView: View {
    
    @State var flickeringTimer: Timer?
    
    @State var flickeringTrigger: Bool = false
    
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
        DesignSystem.Soft.Color.headerBatteryBaseStripe2,
        DesignSystem.Soft.Color.headerBatteryBaseStripe0
    ]
    
    private var headerHeight: CGFloat {
        DesignSystem.Soft.Dimension.headerHeight
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(LinearGradient(colors: batteryBaseColorArray, startPoint: .top, endPoint: .bottom))
                        .frame(width: headerHeight * 0.92, height: headerHeight * 0.45)
                    
                    if flickeringTrigger {
                        HStack(spacing: 0) {
                            Rectangle()
                                .fill(LinearGradient(colors: batteryGreenColorArray, startPoint: .top, endPoint: .bottom))
                                .frame(width: headerHeight * 0.92, height: headerHeight * 0.45)
                        }
                    }

                    Rectangle()
                        .stroke(DesignSystem.Soft.Color.headerBatteryLine, lineWidth: DesignSystem.Soft.Dimension.basicThinValue)
                        .frame(width: headerHeight * 0.92, height: headerHeight * 0.45)
                }
                
                ZStack {
                    Rectangle()
                        .fill(DesignSystem.Soft.Color.headerBatteryBaseStripe1)
                        .frame(width: headerHeight * 0.07, height: headerHeight * 0.18)
                    Rectangle()
                        .stroke(DesignSystem.Soft.Color.headerBatteryLine, lineWidth: DesignSystem.Soft.Dimension.basicThinValue)
                        .frame(width: headerHeight * 0.07, height: headerHeight * 0.18)
                }
            }
            
            Image(systemName: "bolt.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(DesignSystem.Soft.Color.headerBatteryThunder)
                .frame(height: headerHeight * 0.58)
                .offset(x: headerHeight * -0.05, y: headerHeight * -0.05)
                .frame(width: headerHeight * 0.6, height: headerHeight * 0.44)
                .clipped()
        }
        .onAppear {
            flickeringTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                flickeringTrigger.toggle()
            }
        }
        .onDisappear {
            flickeringTimer?.invalidate()
        }
        
    }
}

struct HeaderBatteryChargingSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderBatteryChargingSymbolView()
    }
}
