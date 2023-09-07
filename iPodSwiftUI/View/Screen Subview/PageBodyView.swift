//
//  PageBodyView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/02.
//

import SwiftUI

struct PageBodyView: View {
    
    @EnvironmentObject var podObservable: PodObservable
    
    var isGhost: Bool
    
    var body: some View {
        Group {
            if !isGhost {
                switch podObservable.pageData.pageBodyStyle {
                    case .list:
                        ListStyleBodyView(
                            key: podObservable.key,
                            pageData: podObservable.pageData,
                            focusedIndex: podObservable.focusedIndex,
                            discreteScrollMark: podObservable.discreteScrollMark,
                            rowCount: podObservable.currentRowCount,
                            repeatState: podObservable.repeatState,
                            alwaysShuffle: podObservable.alwaysShuffle,
                            vibeIsActivated: podObservable.vibeIsActivated,
                            videoZoomMode: podObservable.videoZoomMode,
                            videoAutoplayMode: podObservable.videoAutoplayMode,
                            libraryUpdateSymbolState: podObservable.libraryUpdateSymbolState,
                            mainMenuBoolArray: podObservable.mainMenuBoolArray
                        )
                    case .nowPlaying:
                        NowPlayingStyleBodyStackView(
                            playingState: podObservable.playingState,
                            currentSongIndex: podObservable.currentSongIndex ?? 1,
                            lineupCount: podObservable.lineup?.count ?? 1,
                            repeatState: podObservable.repeatState,
                            shuffleIsActivated: podObservable.shuffleIsActivated,
                            currentSongArtwork: podObservable.currentSongArtwork,
                            currentArtworkUIImage_thumb: podObservable.currentArtworkUIImage_thumb,
                            currentArtworkUIImage_full: podObservable.currentArtworkUIImage_full,
                            currentSongTitle: podObservable.currentSongTitle ?? " ",
                            currentSongArtistName: podObservable.currentSongArtistName ?? " ",
                            currentSongAlbumTitle: podObservable.currentSongAlbumTitle ?? " ",
                            timePassed: (podObservable.musicHandler.musicPlayer.state.playbackStatus == .seekingForward || podObservable.musicHandler.musicPlayer.state.playbackStatus == .seekingBackward) ? nil : Float(podObservable.timePassed ?? 1.0),
                            totalTime: (podObservable.musicHandler.musicPlayer.state.playbackStatus == .seekingForward || podObservable.musicHandler.musicPlayer.state.playbackStatus == .seekingBackward) ? nil : Float(podObservable.currentSongTotalTime ?? 1.0),
                            volume: podObservable.volume,
                            transitionState: podObservable.nowPlayingTransitionState,
                            bodyOffsetTrigger: podObservable.nowPlayingBodyOffsetTrigger,
                            lowerOffsetTrigger: podObservable.nowPlayingLowerOffsetTrigger,
                            upperTextFlicker: podObservable.nowPlayingUpperTextFlicker,
                            upperTextOffsetTrigger: podObservable.nowPlayingUpperTextOffsetTrigger
                        )
                    case .photo:
                        PhotoStyleBodyStackView(focusedIndex: podObservable.focusedIndex ?? 0, discreteScrollMark: podObservable.discreteScrollMark ?? 0, detailIsShown: podObservable.photoDetailIsShown)
                    case .video:
                        VideoStyleBodyStackView(
                            focusedIndex: podObservable.focusedIndex ?? 0,
                            discreteScrollMark: podObservable.discreteScrollMark ?? 0,
                            playingState: podObservable.playingState,
                            batteryLevel: podObservable.batteryLevel,
                            volume: podObservable.volume,
                            videoTimePassed: podObservable.videoTimePassed,
                            currentVideoTotalTime: podObservable.currentVideoTotalTime,
                            zoomMode: podObservable.videoZoomMode,
                            detailIsShown: podObservable.videoDetailIsShown,
                            playerIsVisible: podObservable.videoPlayerIsVisible,
                            playingStateSymbolIsVisible: podObservable.videoPlayingStateSymbolIsVisible,
                            batterySymbolIsVisible: podObservable.videoBatterySymbolIsVisible,
                            volumeBarIsVisible: podObservable.videoVolumeBarIsVisible,
                            seekBarIsVisible: podObservable.videoSeekBarIsVisible
                        )
                    case .nowPlayingVideo:
                        NowPlayingVideoStyleView(
                            playingState: podObservable.playingState,
                            batteryLevel: podObservable.batteryLevel,
                            volume: podObservable.volume,
                            videoTimePassed: podObservable.videoTimePassed,
                            currentVideoTotalTime: podObservable.currentVideoTotalTime,
                            zoomMode: podObservable.videoZoomMode,
                            detailIsShown: podObservable.videoDetailIsShown,
                            playerIsVisible: podObservable.videoPlayerIsVisible,
                            playingStateSymbolIsVisible: podObservable.videoPlayingStateSymbolIsVisible,
                            batterySymbolIsVisible:
                                podObservable.videoBatterySymbolIsVisible,
                            volumeBarIsVisible: podObservable.videoVolumeBarIsVisible,
                            seekBarIsVisible: podObservable.videoSeekBarIsVisible
                        )
                    case .text:
                        TextStyleBodyView(title: podObservable.getPageData(.main).headerTitle)
                    default:
                        Color(.white)
                }
            }
            // ghost
            else {
                switch podObservable.pageData_ghost.pageBodyStyle {
                    case .list:
                        ListStyleBodyView_ghost(
                            key: podObservable.key_ghost,
                            pageData: podObservable.pageData_ghost,
                            focusedIndex: podObservable.focusedIndex_ghost,
                            discreteScrollMark: podObservable.discreteScrollMark_ghost,
                            rowCount: podObservable.currentRowCount_ghost,
                            repeatState: podObservable.repeatState,
                            alwaysShuffle: podObservable.alwaysShuffle,
                            vibeIsActivated: podObservable.vibeIsActivated,
                            videoZoomMode: podObservable.videoZoomMode,
                            videoAutoplayMode: podObservable.videoAutoplayMode,
                            libraryUpdateSymbolState: podObservable.libraryUpdateSymbolState,
                            mainMenuBoolArray: podObservable.mainMenuBoolArray
                        )
                    case .nowPlaying:
                        NowPlayingStyleBodyStackView(
                            playingState: podObservable.playingState,
                            currentSongIndex: podObservable.currentSongIndex ?? 1,
                            lineupCount: podObservable.lineup?.count ?? 1,
                            repeatState: podObservable.repeatState,
                            shuffleIsActivated: podObservable.shuffleIsActivated,
                            currentSongArtwork: podObservable.currentSongArtwork,
                            currentArtworkUIImage_thumb: podObservable.currentArtworkUIImage_thumb,
                            currentArtworkUIImage_full: podObservable.currentArtworkUIImage_full,
                            currentSongTitle: podObservable.currentSongTitle ?? " ",
                            currentSongArtistName: podObservable.currentSongArtistName ?? " ",
                            currentSongAlbumTitle: podObservable.currentSongAlbumTitle ?? " ",
                            timePassed: Float(podObservable.timePassed ?? 1.0),
                            totalTime: Float(podObservable.currentSongTotalTime ?? 1.0),
                            volume: podObservable.volume,
                            transitionState: podObservable.nowPlayingTransitionState_ghost,
                            bodyOffsetTrigger: podObservable.nowPlayingBodyOffsetTrigger,
                            lowerOffsetTrigger: podObservable.nowPlayingLowerOffsetTrigger,
                            upperTextFlicker: podObservable.nowPlayingUpperTextFlicker,
                            upperTextOffsetTrigger: podObservable.nowPlayingUpperTextOffsetTrigger
                        )
                    case .photo:
                        PhotoStyleBodyStackView(focusedIndex: podObservable.focusedIndex_ghost ?? 0, discreteScrollMark: podObservable.discreteScrollMark_ghost ?? 0, detailIsShown: podObservable.photoDetailIsShown)
                    case .video:
                        VideoStyleBodyStackView(
                            focusedIndex: podObservable.focusedIndex_ghost ?? 0,
                            discreteScrollMark: podObservable.discreteScrollMark_ghost ?? 0,
                            playingState: podObservable.playingState,
                            batteryLevel: podObservable.batteryLevel,
                            volume: podObservable.volume,
                            videoTimePassed: podObservable.videoTimePassed,
                            currentVideoTotalTime: podObservable.currentVideoTotalTime,
                            zoomMode: podObservable.videoZoomMode,
                            detailIsShown: podObservable.videoDetailIsShown,
                            playerIsVisible: podObservable.videoPlayerIsVisible,
                            playingStateSymbolIsVisible: podObservable.videoPlayingStateSymbolIsVisible,
                            batterySymbolIsVisible:
                                podObservable.videoBatterySymbolIsVisible,
                            volumeBarIsVisible: podObservable.videoVolumeBarIsVisible,
                            seekBarIsVisible: podObservable.videoSeekBarIsVisible
                        )
                    case .nowPlayingVideo:
                        NowPlayingVideoStyleView(
                            playingState: podObservable.playingState,
                            batteryLevel: podObservable.batteryLevel,
                            volume: podObservable.volume,
                            videoTimePassed: podObservable.videoTimePassed,
                            currentVideoTotalTime: podObservable.currentVideoTotalTime,
                            zoomMode: podObservable.videoZoomMode,
                            detailIsShown: podObservable.videoDetailIsShown,
                            playerIsVisible: podObservable.videoPlayerIsVisible,
                            playingStateSymbolIsVisible: podObservable.videoPlayingStateSymbolIsVisible,
                            batterySymbolIsVisible:
                                podObservable.videoBatterySymbolIsVisible,
                            volumeBarIsVisible: podObservable.videoVolumeBarIsVisible,
                            seekBarIsVisible: podObservable.videoSeekBarIsVisible
                        )
                    case .text:
                        TextStyleBodyView(title: podObservable.getPageData(.main).headerTitle)
                    default:
                        Color(.white)
                }
            }
        }
        .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
    }
}

struct PageBodyView_Previews: PreviewProvider {
    static var previews: some View {
        PageBodyView(isGhost: false)
            .environmentObject(PodObservable())
    }
}

