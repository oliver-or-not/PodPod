//
//  NowPlayingComplexBodyView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/19.
//

import SwiftUI
import MusicKit

struct NowPlayingComplexBodyView: View {
    var playingState: PlayingState
    
    var currentSongIndex: Int
    var lineupCount: Int
    var repeatState: RepeatState
    var shuffleIsActivated: Bool
    
    var currentSongArtwork: Artwork? // optional
    var currentArtworkUIImage_thumb: UIImage?
    var currentSongTitle: String
    var currentSongArtistName: String
    var currentSongAlbumTitle: String
    
    var volume: Float
    
    var timePassed: Float?
    var totalTime: Float?
    
    var transitionState: NowPlayingTransitionState
    var lowerOffsetTrigger: Bool
    
    var upperTextFlicker: Bool
    var upperTextOffsetTrigger: Bool
    
    var needsAnimatedView: Bool
    
    var body: some View {
        ZStack {
            Color(.white)
            
            if lineupCount > 0 && playingState != .stopped {
                NowPlayingUpperView(
                    currentSongIndex: currentSongIndex,
                    lineupCount: lineupCount,
                    repeatState: repeatState,
                    shuffleIsActivated: shuffleIsActivated,
                    currentSongArtwork: currentSongArtwork,
                    currentArtworkUIImage_thumb: currentArtworkUIImage_thumb,
                    currentSongTitle: currentSongTitle,
                    currentSongArtistName: currentSongArtistName,
                    currentSongAlbumTitle: currentSongAlbumTitle,
                    upperTextFlicker: upperTextFlicker,
                    upperTextOffsetTrigger: upperTextOffsetTrigger,
                    needsAnimatedView: needsAnimatedView
                )
                .offset(y: DesignSystem.Soft.Dimension.bodyHeight * -0.12)
                
                Group {
                    switch transitionState {
                        case .stable, .fullArtworkToStable:
                            NowPlayingLowerTimeBarView(timePassed: timePassed, totalTime: totalTime)
                        case .volume:
                            NowPlayingLowerVolumeBarView(volume: volume)
                        case .seek, .seekToFullArtwork:
                            NowPlayingLowerSeekBarView(timePassed: timePassed, totalTime: totalTime)
                        case .stableToVolume:
                            HStack(spacing: 0) {
                                NowPlayingLowerTimeBarView(timePassed: timePassed, totalTime: totalTime)
                                NowPlayingLowerVolumeBarView(volume: volume)
                            }
                            .offset(x: lowerOffsetTrigger ? DesignSystem.Soft.Dimension.w * -0.5 : DesignSystem.Soft.Dimension.w * 0.5)
                            .frame(width: DesignSystem.Soft.Dimension.w)
                            .clipped()
                            .animation(.linear(duration: DesignSystem.Time.slidingAnimationTime), value: lowerOffsetTrigger)
                        case .volumeToStable:
                            HStack(spacing: 0) {
                                NowPlayingLowerVolumeBarView(volume: volume)
                                NowPlayingLowerTimeBarView(timePassed: timePassed, totalTime: totalTime)
                            }
                            .offset(x: lowerOffsetTrigger ? DesignSystem.Soft.Dimension.w * -0.5 : DesignSystem.Soft.Dimension.w * 0.5)
                            .frame(width: DesignSystem.Soft.Dimension.w)
                            .clipped()
                            .animation(.linear(duration: DesignSystem.Time.slidingAnimationTime), value: lowerOffsetTrigger)
                        case .stableToSeek:
                            HStack(spacing: 0) {
                                NowPlayingLowerTimeBarView(timePassed: timePassed, totalTime: totalTime)
                                NowPlayingLowerSeekBarView(timePassed: timePassed, totalTime: totalTime)
                            }
                            .offset(x: lowerOffsetTrigger ? DesignSystem.Soft.Dimension.w * -0.5 : DesignSystem.Soft.Dimension.w * 0.5)
                            .frame(width: DesignSystem.Soft.Dimension.w)
                            .clipped()
                            .animation(.linear(duration: DesignSystem.Time.slidingAnimationTime), value: lowerOffsetTrigger)
                        case .seekToStable:
                            HStack(spacing: 0) {
                                NowPlayingLowerSeekBarView(timePassed: timePassed, totalTime: totalTime)
                                NowPlayingLowerTimeBarView(timePassed: timePassed, totalTime: totalTime)
                            }
                            .offset(x: lowerOffsetTrigger ? DesignSystem.Soft.Dimension.w * -0.5 : DesignSystem.Soft.Dimension.w * 0.5)
                            .frame(width: DesignSystem.Soft.Dimension.w)
                            .clipped()
                            .animation(.linear(duration: DesignSystem.Time.slidingAnimationTime), value: lowerOffsetTrigger)
                        default:
                            DummyPageBodyView()
                    }
                }
                .offset(y: DesignSystem.Soft.Dimension.bodyHeight * 0.39)
            }
            // when lineupCount == 0
            else {
                DotsProgressView(brightBack: true)
                    .frame(width: DesignSystem.Soft.Dimension.w * 0.1, height: DesignSystem.Soft.Dimension.w * 0.1) 
            }
        }
        .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
    }
}


struct NowPlayingComplexBodyView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingComplexBodyView(playingState: .playing, currentSongIndex: 1, lineupCount: 3, repeatState: .all, shuffleIsActivated: true, currentSongArtwork: nil, currentSongTitle: "야생화", currentSongArtistName: "박효신", currentSongAlbumTitle: "야생화", volume: 0.3, timePassed: 80, totalTime: 220, transitionState: .stableToVolume, lowerOffsetTrigger: false, upperTextFlicker: true, upperTextOffsetTrigger: false, needsAnimatedView: true)
    }
}
