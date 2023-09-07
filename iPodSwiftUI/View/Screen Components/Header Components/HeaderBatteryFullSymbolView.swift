//
//  HeaderBatteryFullSymbolView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/20.
//

import SwiftUI

struct HeaderBatteryFullSymbolView: View {
    
    private var headerHeight: CGFloat {
        DesignSystem.Soft.Dimension.headerHeight
    }
    
    var body: some View {
        ZStack {
            HeaderBatteryUnpluggedSymbolView(batteryLevel: 1.0)
            Image(systemName: "powerplug.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(DesignSystem.Soft.Color.headerBatteryThunder)
                .frame(width: headerHeight * 0.5, height: headerHeight * 0.4)
                .offset(x: headerHeight * -0.04)
        }
    }
}

struct HeaderBatteryFullSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderBatteryFullSymbolView()
    }
}
