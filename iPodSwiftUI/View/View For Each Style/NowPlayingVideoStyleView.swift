//
//  NowPlayingVideoStyleView.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/05.
//

import SwiftUI
import Photos
import AVKit

struct NowPlayingVideoStyleView: View {
    
    var playingState: PlayingState = .paused
    var batteryLevel: Float = 0.0
    var volume: Float = 0.0
    var videoTimePassed: CMTime? // optional
    var currentVideoTotalTime: CMTime? // optional
    
    var zoomMode: VideoZoomMode = .fit
    var detailIsShown: Bool = false
    var playerIsVisible: Bool = false
    var playingStateSymbolIsVisible: Bool = false
    var batterySymbolIsVisible: Bool = false
    var volumeBarIsVisible: Bool = false
    var seekBarIsVisible: Bool = false
    
    private var player = VideoHandler.shared.player
    
    private var ratio: CGFloat {
        CGFloat(DataModel.shared.favoriteVideoRatioArray[VideoHandler.shared.videoIndex!])
    }
    private var scalingFactor: CGFloat {
        min(1.33333, max(0.75 / ratio, 4.0 * ratio / 3.0))
    }
    
    private var w: CGFloat {
        DesignSystem.Soft.Dimension.w
    }
    
    private var h: CGFloat {
        DesignSystem.Soft.Dimension.h
    }
    
    init(playingState: PlayingState = .paused, batteryLevel: Float = 0.0, volume: Float = 0.0, videoTimePassed: CMTime? = nil, currentVideoTotalTime: CMTime? = nil, zoomMode: VideoZoomMode = .fit, detailIsShown: Bool = false, playerIsVisible: Bool = false, playingStateSymbolIsVisible: Bool = false, batterySymbolIsVisible: Bool = false, volumeBarIsVisible: Bool = false, seekBarIsVisible: Bool = false) {
        self.playingState = playingState
        self.batteryLevel = batteryLevel
        self.volume = volume
        self.videoTimePassed = videoTimePassed
        self.currentVideoTotalTime = currentVideoTotalTime
        self.zoomMode = zoomMode
        self.detailIsShown = detailIsShown
        self.playerIsVisible = playerIsVisible
        self.playingStateSymbolIsVisible = playingStateSymbolIsVisible
        self.batterySymbolIsVisible = batterySymbolIsVisible
        self.volumeBarIsVisible = volumeBarIsVisible
        self.seekBarIsVisible = seekBarIsVisible
    }
    
    var body: some View {
        // video detail
        ZStack {
            Color(.black)
            Group {
                if playerIsVisible {
                    switch zoomMode {
                        case .fit:
                            VideoPlayer(player: player)
                                .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.h)
                        case .zoom:
                            VideoPlayer(player: player)
                                .frame(width: DesignSystem.Soft.Dimension.w * scalingFactor, height: DesignSystem.Soft.Dimension.h * scalingFactor)
                                .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.h)
                                .clipped()
                    }
                }
            }
            
            // playing state symbol
            Group {
                switch playingState {
                    case .playingVideo:
                        VideoPlayingSymbolView()
                    case .pausedVideo:
                        VideoPausedSymbolView()
                    default:
                        VideoPausedSymbolView()
                }
            }
            .offset(x: w * -0.5 + w * 0.094, y: h * -0.5 + w * 0.0886)
            .opacity(playingStateSymbolIsVisible ? 1 : 0)
            
            // battery symbol
            VideoBatterySymbolView(batteryLevel: batteryLevel)
            .offset(x: w * 0.5 + w * -0.1069, y: h * -0.5 + w * 0.0924)
            .opacity(batterySymbolIsVisible ? 1 : 0)
            
            // volume bar
            VideoVolumeBarView(value: volume, base: 1.0)
            .offset(y: h * 0.343)
            .opacity(volumeBarIsVisible ? 1 : 0)
            
            // seek bar
            Group {
                if let videoTimePassed, let currentVideoTotalTime {
                    VideoSeekBarView(value: CGFloat(videoTimePassed.seconds), base: CGFloat(currentVideoTotalTime.seconds))
                } else {
                    VideoSeekBarView(value: nil, base: nil)
                }
            }
            .offset(y: h * 0.373)
            .opacity(seekBarIsVisible ? 1 : 0)
            
            
        }
        .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.h)
        .offset(y: -DesignSystem.Soft.Dimension.rowHeight * 0.5)
    }
}

struct NowPlayingVideoStyleView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingVideoStyleView(playingState: .playingVideo, videoTimePassed: CMTime(value: 60000, timescale: 600), currentVideoTotalTime: CMTime(value: 180000, timescale: 600), detailIsShown: true, playingStateSymbolIsVisible: true, batterySymbolIsVisible: true, volumeBarIsVisible: true, seekBarIsVisible: true)
    }
}
