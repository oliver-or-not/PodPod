//
//  HeaderView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/18.
//

import SwiftUI

struct HeaderView: View {
    var title: String
    var timeTitle: String
    var playingState: PlayingState
    var batteryState: BatteryState
    var batteryLevel: Float
    var headerTimeIsShown: Bool
    var wantsToSeeTimeInHeader: Bool
    
    private var timeTitleRefresher = Timer()
    
    let fastArray = [
        DesignSystem.Soft.Color.playingStateStripe1,
        DesignSystem.Soft.Color.playingStateStripe1,
        DesignSystem.Soft.Color.playingStateStripe3,
        DesignSystem.Soft.Color.playingStateStripe1,
        DesignSystem.Soft.Color.playingStateStripe1
    ]
    
    init(title: String, timeTitle: String, playingState: PlayingState, batteryState: BatteryState, batteryLevel: Float, headerTimeIsShown: Bool, wantsToSeeTimeInHeader: Bool) {
        self.title = title
        self.timeTitle = timeTitle
        self.playingState = playingState
        self.batteryState = batteryState
        self.batteryLevel = batteryLevel
        self.headerTimeIsShown = headerTimeIsShown
        self.wantsToSeeTimeInHeader = wantsToSeeTimeInHeader
    }
    
    
    var body: some View {
        
        var headerHeight: CGFloat {
            DesignSystem.Soft.Dimension.headerHeight
        }
        var basicIndentation: CGFloat {
            DesignSystem.Soft.Dimension.basicIndentation
        }
        var basicFontSize: CGFloat {
            DesignSystem.Soft.Dimension.basicFontSize
        }
        
        ZStack {
            VStack(spacing: 0) {
                LinearGradient(colors: [DesignSystem.Soft.Color.headerTop, DesignSystem.Soft.Color.headerBottom], startPoint: .top, endPoint: .bottom)
                DesignSystem.Soft.Color.headerBottomLine
                    .frame(height: DesignSystem.Soft.Dimension.basicThinValue)
            }
            
            HStack {
                Spacer()
                    .frame(width: basicIndentation)
                
                // playing state symbol
                Group {
                    switch playingState {
                        case .stopped:
                            EmptyView()
                        case .playing, .playingVideo:
                            HeaderPlayingSymbolView()
                        case .paused, .pausedVideo:
                            HeaderPausedSymbolView()
                        case .seekingForward:
                            HeaderSeekingForwardSymbolView()
                        case .seekingBackward:
                            HeaderSeekingBackwardSymbolView()
                    }
                }
                .offset(y: -headerHeight * 0.015)
                
                Spacer()
                
                // battery symbol
                Group {
                    switch batteryState {
                        case .unplugged:
                            HeaderBatteryUnpluggedSymbolView(batteryLevel: batteryLevel)
                        case .charging:
                            HeaderBatteryChargingSymbolView()
                        case .full:
                            HeaderBatteryFullSymbolView()
                        default:
                            EmptyView()
                    }
                }
                .offset(x: headerHeight * -0.04, y: headerHeight * -0.035)
                
                Spacer()
                    .frame(width: basicIndentation)
            }
            
            if headerTimeIsShown && wantsToSeeTimeInHeader {
                Text(timeTitle)
                    .font(.system(size: basicFontSize, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: DesignSystem.Soft.Dimension.w * 0.73)
                    .lineLimit(1)
            } else {
                Text(title)
                    .font(.system(size: basicFontSize, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: DesignSystem.Soft.Dimension.w * 0.73)
                    .lineLimit(1)
            }
        }
        .frame(width: DesignSystem.Soft.Dimension.w, height: headerHeight)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HeaderView(title: DesignSystem.String.appName, timeTitle: "5:40 PM", playingState: .playing, batteryState: .unplugged, batteryLevel: 0.1, headerTimeIsShown: false, wantsToSeeTimeInHeader: true)
            HeaderView(title: DesignSystem.String.appName, timeTitle: "5:40 PM", playingState: .playing, batteryState: .unplugged, batteryLevel: 0.4, headerTimeIsShown: false, wantsToSeeTimeInHeader: true)
            HeaderView(title: DesignSystem.String.appName, timeTitle: "5:40 PM", playingState: .paused, batteryState: .unplugged, batteryLevel: 0.8, headerTimeIsShown: false, wantsToSeeTimeInHeader: true)
            HeaderView(title: DesignSystem.String.appName, timeTitle: "5:40 PM", playingState: .seekingBackward, batteryState: .charging, batteryLevel: 0.8, headerTimeIsShown: false, wantsToSeeTimeInHeader: true)
            HeaderView(title: DesignSystem.String.appName, timeTitle: "5:40 PM",  playingState: .seekingForward, batteryState: .full, batteryLevel: 1.0, headerTimeIsShown: true, wantsToSeeTimeInHeader: true)
        }
    }
}
