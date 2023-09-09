//
//  VideoStyleBodyStackView.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/04.
//

import SwiftUI
import Photos
import AVKit

struct VideoStyleBodyStackView: View {
    
    var focusedIndex: Int = 0
    var discreteScrollMark: Int = 0
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
    var videoIsBeingLoaded: Bool = false
    
    private var player = VideoHandler.shared.player
    
    private var ratio: CGFloat {
        CGFloat(DataModel.shared.favoriteVideoRatioArray[VideoHandler.shared.videoIndex!])
    }
    private var scalingFactor: CGFloat {
        min(1.33333, max(0.75 / ratio, 4.0 * ratio / 3.0))
    }
    
    private var thumbnailArray: [UIImage] {
        DataModel.shared.favoriteVideoThumbnailArray
    }
    private var videoArray: [PHAsset] {
        DataModel.shared.favoriteVideoArray
    }
        
    private var vStackIndexArray: [Int] {
        var temp = [Int]()
        for i in 0..<vNum {
            temp.append(discreteScrollMark + i * hNum)
        }
        return temp
    }
    
    private var hStackIndexArray: [Int] {
        var temp = [Int]()
        for i in 0..<hNum {
            temp.append(i)
        }
        return temp
    }
    
    private var videoCount: Int {
        thumbnailArray.count
    }
    
    private var hNum: Int {
        DesignSystem.Soft.Dimension.videoThumbnailHorizontalNum
    }
    
    private var vNum: Int {
        DesignSystem.Soft.Dimension.videoThumbnailVerticalNum
    }
    
    private var thinValue: CGFloat {
        DesignSystem.Soft.Dimension.basicThinValue
    }
    
    private var w: CGFloat {
        DesignSystem.Soft.Dimension.w
    }
    
    private var h: CGFloat {
        DesignSystem.Soft.Dimension.h
    }
    
    private var photoWidth: CGFloat {
        if videoCount > hNum * vNum {
            return (w - DesignSystem.Soft.Dimension.scrollBarWidth - CGFloat(hNum - 1 + 4) * thinValue) / CGFloat(hNum)
        }
        else {
            return (w - CGFloat(hNum - 1 + 4) * thinValue) / CGFloat(hNum)
        }
    }
    
    private var photoHeight: CGFloat {
        return (DesignSystem.Soft.Dimension.bodyHeight - CGFloat(vNum - 1 + 8) * thinValue) / CGFloat(vNum)
    }
    
    private var nowPlayingFontSize: CGFloat {
        DesignSystem.Soft.Dimension.nowPlayingFontSize
    }
    
    private var basicIndentation: CGFloat {
        DesignSystem.Soft.Dimension.basicIndentation
    }
    
    init(focusedIndex: Int = 0, discreteScrollMark: Int = 0, playingState: PlayingState = .paused, batteryLevel: Float = 0.0, volume: Float = 0.0, videoTimePassed: CMTime? = nil, currentVideoTotalTime: CMTime? = nil, zoomMode: VideoZoomMode = .fit, detailIsShown: Bool = false, playerIsVisible: Bool = false, playingStateSymbolIsVisible: Bool = false, batterySymbolIsVisible: Bool = false, volumeBarIsVisible: Bool = false, seekBarIsVisible: Bool = false, videoIsBeingLoaded: Bool = false) {
        self.focusedIndex = focusedIndex
        self.discreteScrollMark = discreteScrollMark
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
        self.videoIsBeingLoaded = videoIsBeingLoaded
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            // thumbnails
            Group {
                if videoCount == 0 {
                    ZStack {
                        Color(.white)
                        
                        HStack(spacing: 0) {
                            Spacer()
                                .frame(width: basicIndentation)
                            
                            Text("표시할 비디오가 없습니다.\n1. 사진 앱에서 추가할 비디오를 선택하고\n즐겨찾기 버튼(♡)을 누르세요.\n2. 설정에서 미디어를 새로고침하세요.")
                                .multilineTextAlignment(.center)
                                .font(.system(size: nowPlayingFontSize, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                                .frame(width: basicIndentation)
                        }
                    }
                }
                // photoCount > 0
                else {
                    HStack (spacing: 0) {
                        VStack (spacing: DesignSystem.Soft.Dimension.basicThinValue) {
                            Spacer().frame(minWidth: 0.0, maxWidth: DesignSystem.Soft.Dimension.basicThinValue * 4)
                            ForEach(vStackIndexArray, id: \.self) { i in
                                HStack (spacing: thinValue) {
                                    Spacer().frame(minWidth: 0.0)
                                    ForEach(hStackIndexArray, id: \.self) { j in
                                        if i+j < videoCount {
                                            ZStack(alignment: .bottomTrailing) {
                                                Image(uiImage: thumbnailArray[i+j])
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: photoWidth, height: photoHeight)
                                                
                                                let intSeconds = downInt(videoArray[i+j].duration)
                                                
                                                Text(getTimeString(intSeconds, blockCount: intSeconds >= 3600 ? 3 : 2))
                                                    .font(.system(size: DesignSystem.Soft.Dimension.videoFontSize, weight: .semibold))
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                    .padding(.trailing, w * 0.013)
                                                    .padding(.bottom, w * 0.006)
                                                    .shadow(color: .black, radius: w * 0.06, x: w * 0.01, y: w * 0.025)
                                                    .shadow(color: .black, radius: w * 0.06, x: w * 0.01, y: w * 0.025)
                                                    .shadow(color: .black, radius: w * 0.06, x: w * 0.01, y: w * 0.025)
                                            }
                                            .frame(width: photoWidth, height: photoHeight)
                                            .clipped()
                                            .border(DesignSystem.Soft.Color.photoBorder, width: focusedIndex == i + j ? DesignSystem.Soft.Dimension.photoBorderWidth : 0.0)
                                        } else {
                                            Color(.white)
                                                .frame(width: photoWidth, height: photoHeight)
                                        }
                                    }
                                    Spacer().frame(minWidth: 0.0)
                                }
                            }
                            Spacer().frame(minWidth: 0.0)
                        }
                        
                        if videoCount > hNum * vNum {
                            DiscreteScrollBarView(focusedIndex: focusedIndex / hNum, discreteScrollMark: discreteScrollMark / hNum, rowCount: videoCount / hNum + (videoCount.isMultiple(of: hNum) ? 0 : 1), range: vNum)
                        }
                    }
                }
            }
            .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
            
            // video detail
            ZStack {
                Color(.black)
                
                Group {
                    if playerIsVisible {
                        switch zoomMode {
                            case .fit:
                                VideoPlayer(player: player)
                                    .frame(width: w, height: h)
                            case .zoom:
                                VideoPlayer(player: player)
                                    .frame(width: w * scalingFactor, height: h * scalingFactor)
                                    .frame(width: w, height: h)
                                    .clipped()
                        }
                    }
                }
                
                ProgressView()
                    .tint(.white)
                    .frame(width: w * 0.25, height: w * 0.25)
                    .opacity(videoIsBeingLoaded ? 1 : 0)
                
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
        }
        .offset(y: -DesignSystem.Soft.Dimension.rowHeight * 0.5)
        .offset(x: detailIsShown ? -DesignSystem.Soft.Dimension.w * 0.5 : DesignSystem.Soft.Dimension.w * 0.5)
        .animation(.linear(duration: DesignSystem.Time.slidingAnimationTime).delay(DesignSystem.Time.lagTime), value: detailIsShown)
    }
}

struct VideoStyleBodyStackView_Previews: PreviewProvider {
    static var previews: some View {
        VideoStyleBodyStackView(playingState: .playingVideo, videoTimePassed: CMTime(value: 60000, timescale: 600), currentVideoTotalTime: CMTime(value: 180000, timescale: 600), detailIsShown: true, playingStateSymbolIsVisible: true, batterySymbolIsVisible: true, volumeBarIsVisible: false, seekBarIsVisible: true, videoIsBeingLoaded: false)
    }
}
