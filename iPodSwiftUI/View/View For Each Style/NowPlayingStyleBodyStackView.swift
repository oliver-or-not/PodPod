//
//  NowPlayingStyleBodyStackView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/12.
//

import SwiftUI
import MusicKit

struct NowPlayingStyleBodyStackView: View {
    //    var pageData: PageData
    
    var playingState: PlayingState
    
    var currentSongIndex: Int
    var lineupCount: Int
    var repeatState: RepeatState
    var shuffleIsActivated: Bool
    
    var currentSongArtwork: Artwork?
    var currentArtworkUIImage_thumb: UIImage?
    var currentArtworkUIImage_full: UIImage?
    
    var currentSongTitle: String
    var currentSongArtistName: String
    var currentSongAlbumTitle: String
    
    var timePassed: Float?
    var totalTime: Float?
    
    var volume: Float
    
    var transitionState: NowPlayingTransitionState
    var bodyOffsetTrigger: Bool
    var lowerOffsetTrigger: Bool
    
    var upperTextFlicker: Bool
    var upperTextOffsetTrigger: Bool
    
    private var initialOffsetX: CGFloat {
        switch transitionState {
            case .fullArtworkToStable, .fullArtwork:
                return DesignSystem.Soft.Dimension.w
            default:
                return 0.0
        }
    }
    
    private var needsAnimation: Bool {
        switch transitionState {
            case .seekToFullArtwork, .fullArtworkToStable:
                return true
            default:
                return false
        }
    }
    
    var body: some View {
        ZStack {
            Color(.red)
                .opacity(0.000001)
            HStack(spacing: 0) {
                NowPlayingFullArtworkBodyView(
                    currentSongArtwork: currentSongArtwork,
                    currentArtworkUIImage_full: currentArtworkUIImage_full
                )
                NowPlayingComplexBodyView(
                    playingState: playingState,
                    currentSongIndex: currentSongIndex,
                    lineupCount: lineupCount,
                    repeatState: repeatState,
                    shuffleIsActivated: shuffleIsActivated,
                    currentSongArtwork: currentSongArtwork,
                    currentArtworkUIImage_thumb: currentArtworkUIImage_thumb,
                    currentSongTitle: currentSongTitle,
                    currentSongArtistName: currentSongArtistName,
                    currentSongAlbumTitle: currentSongAlbumTitle,
                    volume: volume,
                    timePassed: timePassed,
                    totalTime: totalTime,
                    transitionState: transitionState,
                    lowerOffsetTrigger: lowerOffsetTrigger,
                    upperTextFlicker: upperTextFlicker,
                    upperTextOffsetTrigger: upperTextOffsetTrigger)
                NowPlayingFullArtworkBodyView(
                    currentSongArtwork: currentSongArtwork,
                    currentArtworkUIImage_full: currentArtworkUIImage_full
                )
            }
            // initial offset
            .offset(x: initialOffsetX)
            // animating offset
            .offset(x: needsAnimation ? (bodyOffsetTrigger ? -DesignSystem.Soft.Dimension.w : 0) : 0)
            .frame(width: DesignSystem.Soft.Dimension.w)
            .animation(.linear(duration: DesignSystem.Time.slidingAnimationTime), value: bodyOffsetTrigger)
            .clipped()
        }
        
        .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
    }
}

struct NowPlayingStyleBodyStackView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingStyleBodyStackView(playingState: .playing, currentSongIndex: 0, lineupCount: 2, repeatState: .all, shuffleIsActivated: true, currentSongArtwork: nil, currentSongTitle: "야생화", currentSongArtistName: "박효신", currentSongAlbumTitle: "야생화", timePassed: 80.0, totalTime: 220.0, volume: 0.3, transitionState: .stable, bodyOffsetTrigger: false, lowerOffsetTrigger: false, upperTextFlicker: true, upperTextOffsetTrigger: false)
    }
}
