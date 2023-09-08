//
//  PodObservable+(Timer).swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/09/03.
//

import Foundation
import SwiftUI

extension PodObservable {
    
    //MARK: - handle timer
    
    func resetStableTimer_fromOutsideToNowPlaying() {
        stableTimer?.invalidate()
        stableTimer = Timer.scheduledTimer(withTimeInterval: 9.0, repeats: false) { timer in
            if self.playingState == .playing && ![.nowPlaying, .photos, .videos].contains(self.key) {
                self.goRight(newPageKey: .nowPlaying)
            }
        }
    }
    func resetStableTimer_fromSeekToStable() {
        stableTimer?.invalidate()
        stableTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            self.fromSeekToStable()
        }
    }
    func resetStableTimer_fromVolumeToStable() {
        stableTimer?.invalidate()
        stableTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.fromVolumeToStable()
        }
    }
    
    func resetVideoSymbolTimer_short() {
        videoSymbolTimer?.invalidate()
        videoSymbolTimer = Timer.scheduledTimer(withTimeInterval: 1.8, repeats: false) { timer in
            if (self.key == .videos && self.videoDetailIsShown) || self.key == .nowPlayingVideo {
                if self.videoPlayingStateSymbolIsVisible {
                    withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                        self.videoPlayingStateSymbolIsVisible = false
                    }
                }
                if self.videoBatterySymbolIsVisible {
                    withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                        self.videoBatterySymbolIsVisible = false
                    }
                }
                if self.videoSeekBarIsVisible {
                    withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                        self.videoSeekBarIsVisible = false
                    }
                }
                if self.videoVolumeBarIsVisible {
                    withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                        self.videoVolumeBarIsVisible = false
                    }
                }
                self.videoControlState = .stable
            }
        }
    }
    
    func resetVideoSymbolTimer_long() {
        videoSymbolTimer?.invalidate()
        videoSymbolTimer = Timer.scheduledTimer(withTimeInterval: 4.8, repeats: false) { timer in
            if (self.key == .videos && self.videoDetailIsShown) || self.key == .nowPlayingVideo {
                if self.videoPlayingStateSymbolIsVisible {
                    withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                        self.videoPlayingStateSymbolIsVisible = false
                    }
                }
                if self.videoBatterySymbolIsVisible {
                    withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                        self.videoBatterySymbolIsVisible = false
                    }
                }
                if self.videoSeekBarIsVisible {
                    withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                        self.videoSeekBarIsVisible = false
                    }
                }
                if self.videoVolumeBarIsVisible {
                    withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                        self.videoVolumeBarIsVisible = false
                    }
                }
                self.videoControlState = .stable
            }
        }
    }
    
    func setPlayInfoRefresher() {
        playInfoRefresher = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            if !self.musicHandler.virtuallyStopped {
                switch self.musicHandler.musicPlayer.state.playbackStatus {
                    case .playing:
                        if self.playingState != .playing {
                            self.playingState = .playing
                        }
                    case .paused:
                        if self.playingState != .paused {
                            self.playingState = .paused
                        }
                    case .seekingForward:
                        if self.playingState != .seekingForward {
                            self.playingState = .seekingForward
                        }
                    case .seekingBackward:
                        if self.playingState != .seekingBackward {
                            self.playingState = .seekingBackward
                        }
                    case .stopped:
                        switch self.videoHandler.getPlayerState() {
                            case .playing:
                                if self.playingState != .playingVideo {
                                    self.playingState = .playingVideo
                                }
                            case .paused:
                                if self.playingState != .pausedVideo {
                                    self.playingState = .pausedVideo
                                }
                            case .stopped:
                                if self.playingState != .stopped {
                                    self.playingState = .stopped
                                }
                        }
                    default:
                        if self.playingState != .stopped {
                            self.playingState = .stopped
                        }
                }
            } else {
                switch self.videoHandler.getPlayerState() {
                    case .playing:
                        if self.playingState != .playingVideo {
                            self.playingState = .playingVideo
                        }
                    case .paused:
                        if self.playingState != .pausedVideo {
                            self.playingState = .pausedVideo
                        }
                    case .stopped:
                        if self.playingState != .stopped {
                            self.playingState = .stopped
                        }
                }
            }
            
            switch self.musicHandler.musicPlayer.state.repeatMode {
                case .all:
                    if self.repeatState != .all {
                        self.repeatState = .all
                    }
                case .one:
                    if self.repeatState != .one {
                        self.repeatState = .one
                    }
                default:
                    if self.repeatState != .off {
                        self.repeatState = .off
                    }
            }
            
            switch self.musicHandler.musicPlayer.state.shuffleMode {
                case .songs:
                    if !self.shuffleIsActivated {
                        self.shuffleIsActivated = true
                    }
                case .off:
                    if self.shuffleIsActivated {
                        self.shuffleIsActivated = false
                    }
                default:
                    if self.shuffleIsActivated {
                        self.shuffleIsActivated = false
                    }
            }
            
            if let safeCurrentEntry = self.musicHandler.musicPlayer.queue.currentEntry {
                if case let .song(currentSongFromMusicPlayer) = safeCurrentEntry.item {
                    if self.currentSong == nil || self.currentSong!.id != currentSongFromMusicPlayer.id {
                        self.currentSong = currentSongFromMusicPlayer
                        self.currentSongTitle = currentSongFromMusicPlayer.title
                        self.currentSongAlbumTitle = currentSongFromMusicPlayer.albumTitle
                        self.currentSongArtistName = currentSongFromMusicPlayer.artistName
                        self.currentSongArtwork = currentSongFromMusicPlayer.artwork
                        self.currentSongTotalTime = currentSongFromMusicPlayer.duration
                        
                        var tempIndex = 0
                        if let lineup = self.lineup {
                            // refresh currentSongIndex only if lineup is updated
                            if lineup.count > 0 {
                                for i in 0..<lineup.count {
                                    if lineup[i].id == currentSongFromMusicPlayer.id {
                                        tempIndex = i
                                        break
                                    }
                                }
                                if self.currentSongIndex != tempIndex {
                                    self.currentSongIndex = tempIndex
                                }
                            }
                        }
                        
                    }
                }
            }
            // music time
            self.timePassed = self.musicHandler.musicPlayer.playbackTime
            
            // video time & ratio
            if let video = self.videoHandler.player.currentItem {
                if self.currentVideoTotalTime != video.duration {
                    self.currentVideoTotalTime = video.duration
                }
                self.videoTimePassed = self.videoHandler.player.currentTime()
                
                if self.videoTimePassed == self.currentVideoTotalTime {
                    switch self.videoAutoplayMode {
                        case .off:
                            _ = 0
                        case .one:
                            self.videoHandler.seek(to: 0.0)
                            if ((self.key == .videos && self.videoDetailIsShown) || self.key == .nowPlayingVideo) && [.playingVideo, .pausedVideo].contains(self.playingState) {
                                self.videoHandler.restart()
                                self.videoPlayingStateSymbolIsVisible = true
                                self.videoBatterySymbolIsVisible = true
                                self.resetVideoSymbolTimer_short()
                            }
                        case .all:
                            if ((self.key == .videos && self.videoDetailIsShown) || self.key == .nowPlayingVideo) && [.playingVideo, .pausedVideo].contains(self.playingState) {
                                self.videoPlayerIsVisible = false
                                self.videoHandler.playNext()
                                self.videoPlayerIsVisible = true
                                self.videoPlayingStateSymbolIsVisible = true
                                self.videoBatterySymbolIsVisible = true
                                self.resetVideoSymbolTimer_short()
                            }
                    }
                }
                
            } else {
                self.videoTimePassed = nil
                if self.currentVideoTotalTime != nil {
                    self.currentVideoTotalTime = nil
                }
            }
        }
    }
    
    func setBatteryInfoRefresher() {
        batteryInfoRefresher = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                        
            switch UIDevice.current.batteryState {
                case .unplugged:
                    if self.batteryState != .unplugged {
                        self.batteryState = .unplugged
                    }
                case .charging:
                    if self.batteryState != .charging {
                        self.batteryState = .charging
                    }
                case .full:
                    if self.batteryState != .full {
                        self.batteryState = .full
                    }
                default:
                    if self.batteryState != .unknown {
                        self.batteryState = .unknown
                    }
            }
            
            if abs(self.batteryLevel - UIDevice.current.batteryLevel) > 0.01 {
                self.batteryLevel = UIDevice.current.batteryLevel
            }
        }
    }
}
