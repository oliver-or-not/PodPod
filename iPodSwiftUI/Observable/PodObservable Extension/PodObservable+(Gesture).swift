//
//  PodObservable+(Gesture).swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/09/03.
//

import Combine
import MediaPlayer
import MusicKit
import SwiftUI

extension PodObservable {
    
    //MARK: - handle interface
    
    func handleWheelValueChange(newValue: CGFloat?, prevValue: CGFloat?) {
        
        var transPerRot: Int {
            DesignSystem.Soft.Dimension.transitionNumberPerOneRotation
        }
        
        // wheel manipulation starts
        if newValue != nil && prevValue == nil {
            stableTimer?.invalidate()
            videoSymbolTimer?.invalidate()
            headerTimeIsShown = false
            headerTimeTimer?.invalidate()

            // .nowPlaying page transition from .stable to .volume
            if key == .nowPlaying {
                if nowPlayingTransitionState == .stable {
                    self.nowPlayingLowerOffsetTrigger = false
                    nowPlayingTransitionState = .stableToVolume
                    DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
                        self.nowPlayingLowerOffsetTrigger = true
                    }
                    nowPlayingTransitionCounter += 1
                    let capturedNowPlayingTransitionCounter = nowPlayingTransitionCounter
                    DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime + DesignSystem.Time.slidingAnimationTime) {
                        if capturedNowPlayingTransitionCounter == self.nowPlayingTransitionCounter {
                            self.nowPlayingTransitionState = .volume
                        }
                    }
                }
            }
            
            if (key == .videos && videoDetailIsShown) || key == .nowPlayingVideo {
                switch videoControlState {
                    case .stable:
                        videoSeekBarIsVisible = false
                        videoBatterySymbolIsVisible = true
                        videoVolumeBarIsVisible = true
                        videoControlState = .volume
                        wheelProperty = .volume
                    case .volume:
                        _ = 0
                    case .seek:
                        _ = 0
                }
            }
            
            // set bases for wheel control
            if wheelProperty == .volume {
                getVolumeCompletionIsDone = false
                MPVolumeView.getVolume { volume in
                    self.baseVolume = volume
                    self.getVolumeCompletionIsDone = true
                }
            } else if wheelProperty == .seek {
                baseTimePassed = musicHandler.musicPlayer.playbackTime
            } else if wheelProperty == .seekVideo {
                baseVideoTimePassed = videoHandler.player.currentTime()
            }
        }
        
        // newValue, prevValue both are non-nil
        if let nv = newValue, let pv = prevValue  {
            switch wheelProperty {
                case .nothing:
                    return
                case .focusedIndex:
                    if focusedIndex != nil {
                        if let rowCount = currentRowCount, let discreteScrollMark {
                            let newDownInt = downInt(nv / 360.0 * CGFloat(transPerRot))
                            let prevDownInt = downInt(pv / 360.0 * CGFloat(transPerRot))
                            // increasing
                            if newDownInt > prevDownInt {
                                if focusedIndex! < rowCount - 1 {
                                    vibeHandler.mediumVibe(if: vibeIsActivated)
                                    focusedIndex! += 1
                                    
                                    let pageBodyStyle = getPageData(key).pageBodyStyle
                                    if  pageBodyStyle == .list {
                                        if focusedIndex! >= discreteScrollMark + DesignSystem.Soft.Dimension.rangeOfRows {
                                            self.discreteScrollMark = discreteScrollMark + 1
                                        }
                                    } else if pageBodyStyle == .photo {
                                        if focusedIndex! >= discreteScrollMark + DesignSystem.Soft.Dimension.photoHorizontalNum * DesignSystem.Soft.Dimension.photoVerticalNum {
                                            self.discreteScrollMark = discreteScrollMark + DesignSystem.Soft.Dimension.photoHorizontalNum
                                            if !photoDetailIsShown {
                                                focusedIndex! = min(focusedIndex! + DesignSystem.Soft.Dimension.photoHorizontalNum - 1, rowCount - 1)
                                            }
                                        }
                                    } else if pageBodyStyle == .video {
                                        if !videoDetailIsShown {
                                            if focusedIndex! >= discreteScrollMark + DesignSystem.Soft.Dimension.videoThumbnailHorizontalNum * DesignSystem.Soft.Dimension.videoThumbnailVerticalNum {
                                                self.discreteScrollMark = discreteScrollMark + DesignSystem.Soft.Dimension.videoThumbnailHorizontalNum
                                                focusedIndex! = min(focusedIndex! + DesignSystem.Soft.Dimension.videoThumbnailHorizontalNum - 1, rowCount - 1)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            // decreasing
                            else if newDownInt < prevDownInt {
                                if focusedIndex! > 0 {
                                    vibeHandler.mediumVibe(if: vibeIsActivated)
                                    focusedIndex! -= 1
                                    
                                    let pageBodyStyle = getPageData(key).pageBodyStyle
                                    if pageBodyStyle == .list {
                                        if focusedIndex! < discreteScrollMark {
                                            self.discreteScrollMark = discreteScrollMark - 1
                                        }
                                    } else if pageBodyStyle == .photo {
                                        if focusedIndex! < discreteScrollMark {
                                            self.discreteScrollMark = discreteScrollMark - DesignSystem.Soft.Dimension.photoHorizontalNum
                                            if !photoDetailIsShown {
                                                focusedIndex! = max(focusedIndex! - DesignSystem.Soft.Dimension.photoHorizontalNum + 1, 0)
                                            }
                                        }
                                    } else if pageBodyStyle == .video {
                                        if !videoDetailIsShown {
                                            if focusedIndex! < discreteScrollMark {
                                                self.discreteScrollMark = discreteScrollMark - DesignSystem.Soft.Dimension.videoThumbnailHorizontalNum
                                                focusedIndex! = max(focusedIndex! - DesignSystem.Soft.Dimension.videoThumbnailHorizontalNum + 1, 0)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                case .volume:
                    if getVolumeCompletionIsDone {
                        let newVolume = min(max(0.0, baseVolume + Float(nv) / 360 * 0.6), 1.0)
                        setVolume(newVolume)
                        if downInt(CGFloat(newVolume) * CGFloat(DesignSystem.Soft.Dimension.soundVibeNumberThroughWholeSoundBar)) != downInt(CGFloat(volume) * CGFloat(DesignSystem.Soft.Dimension.soundVibeNumberThroughWholeSoundBar)) {
                            vibeHandler.mediumVibe(if: vibeIsActivated)
                        }
                        volume = newVolume
                    }
                case .seek:
                    seekIsUsed = true
                    if let safeCurrentEntry = musicHandler.musicPlayer.queue.currentEntry {
                        if case let .song(currentSongFromMusicPlayer) = safeCurrentEntry.item {
                            if let duration = currentSongFromMusicPlayer.duration {
                                let newTimePassed = min(max(0.0, baseTimePassed + TimeInterval(nv) / 360 * 0.17 * duration), duration - 0.5)
                                if abs(newTimePassed - musicHandler.musicPlayer.playbackTime) > duration * 0.01 {
                                    musicHandler.musicPlayer.playbackTime = newTimePassed
                                }
                            }
                        }
                    }
                case .seekVideo:
                    if let cmTimeDuration = videoHandler.player.currentItem?.duration {
                        let duration = CGFloat(CMTimeGetSeconds(cmTimeDuration))
                        let newTimePassed = min(max(0.0, CGFloat(CMTimeGetSeconds(baseVideoTimePassed)) + nv / 360 * 0.17 * duration), duration - 0.5)
                        if abs(newTimePassed - CGFloat(CMTimeGetSeconds(videoHandler.player.currentTime()))) > duration * 0.01 {
                            videoHandler.seek(to: newTimePassed)
                        }
                    }
                default:
                    return
            }
        }
        
        // wheel manipulation ends
        if newValue == nil && prevValue != nil {
            if key == .nowPlaying && (nowPlayingTransitionState == .volume || nowPlayingTransitionState == .stableToVolume) {
                resetStableTimer_fromVolumeToStable()
            }
            else if key == .nowPlaying && nowPlayingTransitionState == .seek {
                resetStableTimer_fromSeekToStable()
            } else if (key == .videos && videoDetailIsShown) || key == .nowPlayingVideo {
                switch videoControlState {
                    case .stable, .volume:
                        resetVideoSymbolTimer_short()
                    case .seek:
                        resetVideoSymbolTimer_long()
                }
            }
            else {
                resetStableTimer_fromOutsideToNowPlaying()
            }
            
            resetHeaderTimeTimer()
        }
    }
    
    func centerButtonTapped() {
        vibeHandler.heavyVibe(if: vibeIsActivated)
        if key == .nowPlaying && nowPlayingTransitionState == .stable {
            resetStableTimer_fromSeekToStable()
        }
        else {
            resetStableTimer_fromOutsideToNowPlaying()
        }
        headerTimeIsShown = false
        resetHeaderTimeTimer()
        
        guard transitionState == .normal && buttonsAreAvailable else {
            return
        }
        
        switch pageData.pageBodyStyle {
            case .list:
                guard let safeRowDataArray = pageData.rowDataArray, let focusedIndex = focusedIndex else {
                    break
                }
                
                let rowHandlingProperty = safeRowDataArray[focusedIndex].handlingProperty
                // if page transition occurs
                if let safeKey = safeRowDataArray[focusedIndex].key {
                    switch rowHandlingProperty {
                        case .nothing:
                            if safeKey == .nowPlayingVideo {
                                currentKeyIsNowPlayingVideo = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
                                    self.videoPlayerIsVisible = true
                                    self.videoPlayingStateSymbolIsVisible = true
                                    self.videoBatterySymbolIsVisible = true
                                    self.resetVideoSymbolTimer_short()
                                    self.goRight(newPageKey: safeKey)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime + DesignSystem.Time.slidingAnimationTime) {
                                    self.videoHandler.restart()
                                }
                            } else {
                                goRight(newPageKey: safeKey)
                            }
                        case .canPlay:
                            goRight(newPageKey: safeKey)
                        case .play:
                            musicHandler.getUserSubscriptionAvailability { userSubscripts in
                                if userSubscripts {
                                    self.doCenterButtonAction_play()
                                    self.goRight(newPageKey: safeKey)
                                } else {
                                    self.subscriptionAlertIsPresented = true
                                }
                            }
                        case .shufflePlay:
                            musicHandler.getUserSubscriptionAvailability { userSubscripts in
                                if userSubscripts {
                                    self.doCenterButtonAction_shufflePlay()
                                    self.goRight(newPageKey: safeKey)
                                } else {
                                    self.subscriptionAlertIsPresented = true
                                }
                            }
                        default:
                            _ = 0
                    }
                }
                // if page transition does not occur
                else {
                    switch rowHandlingProperty {
                        case .timeInHeader:
                            doCenterButtonAction_timeInHeader()
                        case .songRepeat:
                            doCenterButtonAction_songRepeat()
                        case .songShuffle:
                            doCenterButtonAction_songShuffle()
                        case .clickVibe:
                            doCenterButtonAction_clickVibe()
                        case .mainMenu:
                            doCenterButtonAction_mainMenu()
                        case .resetMainMenu:
                            doCenterButtonAction_resetMainMenu()
                        case .videoZoom:
                            doCenterButtonAction_videoZoom()
                        case .videoAutoplay:
                            doCenterButtonAction_videoAutoplay()
                        case .settingsLink:
                            doCenterButtonAction_settingsLink()
                        case .mediaRefresh:
                            doCenterButtonAciton_mediaRefresh()
                        case .nothing:
                            switch safeRowDataArray[focusedIndex].actionStyle {
                                case .changeBack:
                                    topButtonTapped()
                                default:
                                    _ = 0
                            }
                        default:
                            _ = 0
                    }
                }
            case .nowPlaying:
                switch nowPlayingTransitionState {
                    case .stable: // -> .seek
                        fromStableToSeek()
                    case .volume: // -> .stable
                        fromVolumeToStable()
                    case .seek: // -> .stable or .fullArtwork
                        fromSeekToFullArtwork()
                    case .fullArtwork: // -> .stable
                        fromFullArtworkToStable()
                    default:
                        _ = 0
                }
            case .photo:
                if !photoDetailIsShown {
                    photoDetailIsShown = true
                }
            case .video:
                if !videoDetailIsShown {
                    if let focusedIndex {
                        buttonsAreAvailable = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
                            self.buttonsAreAvailable = true
                        }
                        self.wheelProperty = .volume
                        videoHandler.clearPlayer()
                        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
                            self.videoHandler.videoIndex = focusedIndex
                            self.videoPlayerIsVisible = true
                            self.videoDetailIsShown = true
                            self.videoPlayingStateSymbolIsVisible = true
                            self.videoBatterySymbolIsVisible = true
                            self.videoHandler.play(self.dataModel.favoriteVideoArray[focusedIndex])
                            self.resetVideoSymbolTimer_short()
                            
                        }
                    }
                }
                // if video detail is shown
                else {
                    switch videoControlState {
                        case .stable:
                            videoControlState = .seek
                            wheelProperty = .seekVideo
                            videoBatterySymbolIsVisible = true
                            videoSeekBarIsVisible = true
                            resetVideoSymbolTimer_long()
                        case .volume:
                            videoControlState = .stable
                            wheelProperty = .volume
                            withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                                videoPlayingStateSymbolIsVisible = false
                                videoBatterySymbolIsVisible = false
                                videoVolumeBarIsVisible = false
                            }
                        case .seek:
                            videoControlState = .stable
                            wheelProperty = .volume
                            withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                                videoPlayingStateSymbolIsVisible = false
                                videoBatterySymbolIsVisible = false
                                videoSeekBarIsVisible = false
                            }
                    }
                }
            case .nowPlayingVideo:
                switch videoControlState {
                    case .stable:
                        videoControlState = .seek
                        wheelProperty = .seekVideo
                        videoBatterySymbolIsVisible = true
                        videoSeekBarIsVisible = true
                        resetVideoSymbolTimer_long()
                    case .volume:
                        videoControlState = .stable
                        wheelProperty = .volume
                        withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                            videoPlayingStateSymbolIsVisible = false
                            videoBatterySymbolIsVisible = false
                            videoVolumeBarIsVisible = false
                        }
                    case .seek:
                        videoControlState = .stable
                        wheelProperty = .volume
                        withAnimation(.linear(duration: DesignSystem.Time.videoSymbolFadeOutTime)) {
                            videoPlayingStateSymbolIsVisible = false
                            videoBatterySymbolIsVisible = false
                            videoSeekBarIsVisible = false
                        }
                }
            default:
                _ = 0
        }
    }
    
    func doCenterButtonAction_play() {
        self.lineup = []
        musicHandler.playFilteredSongs(startingAt: pageData.rowDataArray![focusedIndex!].song, isShuffled: alwaysShuffle) {
            var tempArray: [Song] = []
            for entry in self.musicHandler.musicPlayer.queue.entries {
                if case let .song(songFromMusicPlayer) = entry.item {
                    tempArray.append(songFromMusicPlayer)
                }
            }
            DispatchQueue.main.async {
                self.lineup = MusicItemCollection<Song>(tempArray)
                var tempIndex = 0
                if let safeCurrentEntry = self.musicHandler.musicPlayer.queue.currentEntry {
                    if case let .song(currentSongFromMusicPlayer) = safeCurrentEntry.item {
                        
                        for i in 0..<self.lineup!.count {
                            if self.lineup![i].id == currentSongFromMusicPlayer.id {
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
    func doCenterButtonAction_shufflePlay() {
        self.lineup = []
        musicHandler.playFilteredSongs(isShuffled: true) {
            var tempArray: [Song] = []
            for entry in self.musicHandler.musicPlayer.queue.entries {
                if case let .song(songFromMusicPlayer) = entry.item {
                    tempArray.append(songFromMusicPlayer)
                }
            }
            DispatchQueue.main.async {
                self.lineup = MusicItemCollection<Song>(tempArray)
                var tempIndex = 0
                if let safeCurrentEntry = self.musicHandler.musicPlayer.queue.currentEntry {
                    if case let .song(currentSongFromMusicPlayer) = safeCurrentEntry.item {
                        
                        for i in 0..<self.lineup!.count {
                            if self.lineup![i].id == currentSongFromMusicPlayer.id {
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
    func doCenterButtonAction_mainMenu() {
        if let focusedIndex {
            mainMenuBoolArray[mainMenuIndexShaker(focusedIndex)].toggle()
            UserDefaults.standard.set(mainMenuBoolArray, forKey: "mainMenuBoolArray")
            
            // adjust focusedIndex of .main
            // if added
            if statusModel.pageSKDictionary[.main] != nil && statusModel.pageSKDictionary[.main]!.focusedIndex != nil && statusModel.pageSKDictionary[.main]!.discreteScrollMark != nil {
                if mainMenuBoolArray[mainMenuIndexShaker(focusedIndex)] {
                    statusModel.pageSKDictionary[.main]!.focusedIndex! += 1
                    if statusModel.pageSKDictionary[.main]!.focusedIndex! >= statusModel.pageSKDictionary[.main]!.discreteScrollMark! + DesignSystem.Soft.Dimension.rangeOfRows {
                        statusModel.pageSKDictionary[.main]!.discreteScrollMark! += 1
                    }
                }
                // if subtracted
                else {
                    statusModel.pageSKDictionary[.main]!.focusedIndex! = max(0, statusModel.pageSKDictionary[.main]!.focusedIndex! - 1)
                    if statusModel.pageSKDictionary[.main]!.focusedIndex! < statusModel.pageSKDictionary[.main]!.discreteScrollMark! {
                        statusModel.pageSKDictionary[.main]!.discreteScrollMark! -= 1
                    }
                }
            }
        }
    }
    func doCenterButtonAction_resetMainMenu() {
        if let focusedIndex {
            switch focusedIndex {
                case 0:
                    topButtonTapped()
                case 1:
                    mainMenuBoolArray = StatusModel.initialValueOfMainMenuBoolArray
                    UserDefaults.standard.set(mainMenuBoolArray, forKey: "mainMenuBoolArray")
                    if statusModel.pageSKDictionary[.main] != nil && statusModel.pageSKDictionary[.main]!.focusedIndex != nil && statusModel.pageSKDictionary[.main]!.focusedIndex != nil {
                        statusModel.pageSKDictionary[.main]!.focusedIndex! = StatusModel.initialIndexOfSettings
                        statusModel.pageSKDictionary[.main]!.discreteScrollMark! = 0
                    }
                    topButtonTapped()
                default:
                    topButtonTapped()
            }
        }
    }
    func doCenterButtonAction_timeInHeader() {
        wantsToSeeTimeInHeader.toggle()
        UserDefaults.standard.set(wantsToSeeTimeInHeader, forKey: "wantsToSeeTimeInHeader")
    }
    func doCenterButtonAction_songRepeat() {
        switch repeatState {
            case .all:
                repeatState = .off
                musicHandler.musicPlayer.state.repeatMode = MusicPlayer.RepeatMode.none
            case .off:
                repeatState = .one
                musicHandler.musicPlayer.state.repeatMode = .one
            case .one:
                repeatState = .all
                musicHandler.musicPlayer.state.repeatMode = .all
        }
        UserDefaults.standard.set(repeatState.rawValue, forKey: "repeatState.rawValue")
    }
    func doCenterButtonAction_songShuffle() {
        if alwaysShuffle {
            alwaysShuffle = false
            if musicHandler.musicPlayer.state.shuffleMode != .off {
                musicHandler.musicPlayer.state.shuffleMode = .off
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    var tempArray: [Song] = []
                    for entry in self.musicHandler.musicPlayer.queue.entries {
                        if case let .song(songFromMusicPlayer) = entry.item {
                            tempArray.append(songFromMusicPlayer)
                        }
                    }
                    self.lineup = MusicItemCollection<Song>(tempArray)
                    var tempIndex = 0
                    if let safeCurrentEntry = self.musicHandler.musicPlayer.queue.currentEntry {
                        if case let .song(currentSongFromMusicPlayer) = safeCurrentEntry.item {
                            
                            for i in 0..<self.lineup!.count {
                                if self.lineup![i].id == currentSongFromMusicPlayer.id {
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
        } else {
            alwaysShuffle = true
            if musicHandler.musicPlayer.state.shuffleMode != .songs {
                musicHandler.musicPlayer.state.shuffleMode = .songs
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    var tempArray: [Song] = []
                    for entry in self.musicHandler.musicPlayer.queue.entries {
                        if case let .song(songFromMusicPlayer) = entry.item {
                            tempArray.append(songFromMusicPlayer)
                        }
                    }
                    self.lineup = MusicItemCollection<Song>(tempArray)
                    var tempIndex = 0
                    if let safeCurrentEntry = self.musicHandler.musicPlayer.queue.currentEntry {
                        if case let .song(currentSongFromMusicPlayer) = safeCurrentEntry.item {
                            
                            for i in 0..<self.lineup!.count {
                                if self.lineup![i].id == currentSongFromMusicPlayer.id {
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
        UserDefaults.standard.set(alwaysShuffle, forKey: "alwaysShuffle")
    }
    func doCenterButtonAction_clickVibe() {
        vibeIsActivated.toggle()
        UserDefaults.standard.set(vibeIsActivated, forKey: "vibeIsActivated")
    }
    func doCenterButtonAction_videoZoom() {
        switch videoZoomMode {
            case .fit:
                videoZoomMode = .zoom
            case .zoom:
                videoZoomMode = .fit
        }
        UserDefaults.standard.set(videoZoomMode.rawValue, forKey: "videoZoomMode.rawValue")
    }
    func doCenterButtonAction_videoAutoplay() {
        switch videoAutoplayMode {
            case .off:
                videoAutoplayMode = .one
            case .one:
                videoAutoplayMode = .all
            case .all:
                videoAutoplayMode = .off
        }
        UserDefaults.standard.set(videoAutoplayMode.rawValue, forKey: "videoAutoplayMode.rawValue")
    }
    func doCenterButtonAction_settingsLink() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    func doCenterButtonAciton_mediaRefresh() {
        if let omitsDataAlert = UserDefaults.standard.object(forKey: "omitsDataAlert") as? Bool {
            if omitsDataAlert {
                libraryUpdateSymbolState = .loading
                videoHandler.fetchFavoriteVideoAssets {
                    self.photoHandler.fetchFavoritePhotos {
                        self.musicHandler.requestUpdateLibrary() {
                            self.musicHandler.requestUpdatePlaylists() {
                                DispatchQueue.main.async {
                                    self.libraryUpdateSymbolState = .done
                                    if let sk = self.statusModel.pageSKDictionary[.songs] {
                                        sk.focusedIndex = 0
                                        sk.discreteScrollMark = 0
                                        self.statusModel.pageSKDictionary[.songs] = sk
                                    }
                                    if let sk = self.statusModel.pageSKDictionary[.playlists] {
                                        sk.focusedIndex = 0
                                        sk.discreteScrollMark = 0
                                        self.statusModel.pageSKDictionary[.playlists] = sk
                                    }
                                    if let sk = self.statusModel.pageSKDictionary[.composers] {
                                        sk.focusedIndex = 0
                                        sk.discreteScrollMark = 0
                                        self.statusModel.pageSKDictionary[.composers] = sk
                                    }
                                    if let sk = self.statusModel.pageSKDictionary[.genres] {
                                        sk.focusedIndex = 0
                                        sk.discreteScrollMark = 0
                                        self.statusModel.pageSKDictionary[.genres] = sk
                                    }
                                    if let sk = self.statusModel.pageSKDictionary[.artists] {
                                        sk.focusedIndex = 0
                                        sk.discreteScrollMark = 0
                                        self.statusModel.pageSKDictionary[.artists] = sk
                                    }
                                    if let sk = self.statusModel.pageSKDictionary[.albums] {
                                        sk.focusedIndex = 0
                                        sk.discreteScrollMark = 0
                                        self.statusModel.pageSKDictionary[.albums] = sk
                                    }
                                    if let sk = self.statusModel.pageSKDictionary[.chosenPlaylist] {
                                        sk.focusedIndex = 0
                                        sk.discreteScrollMark = 0
                                        self.statusModel.pageSKDictionary[.chosenPlaylist] = sk
                                    }
                                    if let sk = self.statusModel.pageSKDictionary[.chosenComposer] {
                                        sk.focusedIndex = 0
                                        sk.discreteScrollMark = 0
                                        self.statusModel.pageSKDictionary[.chosenComposer] = sk
                                    }
                                    if let sk = self.statusModel.pageSKDictionary[.chosenGenre] {
                                        sk.focusedIndex = 0
                                        sk.discreteScrollMark = 0
                                        self.statusModel.pageSKDictionary[.chosenGenre] = sk
                                    }
                                    if let sk = self.statusModel.pageSKDictionary[.chosenArtist] {
                                        sk.focusedIndex = 0
                                        sk.discreteScrollMark = 0
                                        self.statusModel.pageSKDictionary[.chosenArtist] = sk
                                    }
                                    if let sk = self.statusModel.pageSKDictionary[.chosenAlbum] {
                                        sk.focusedIndex = 0
                                        sk.discreteScrollMark = 0
                                        self.statusModel.pageSKDictionary[.chosenAlbum] = sk
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    self.libraryUpdateSymbolState = .notShown
                                }
                            }
                        }
                    }
                }
            } else {
                mediaRefreshNetworkAlertIsPresented = true
            }
        }
    }
    
    func topButtonTapped() {
        vibeHandler.heavyVibe(if: vibeIsActivated)
        
        guard transitionState == .normal && buttonsAreAvailable else {
            return
        }
        
        resetStableTimer_fromOutsideToNowPlaying()
        headerTimeIsShown = false
        resetHeaderTimeTimer()
        
        if key == .photos && photoDetailIsShown {
            photoDetailIsShown = false
            return
        }
        
        if key == .videos && videoDetailIsShown {
            self.wheelProperty = .focusedIndex
            self.focusedIndex = videoHandler.videoIndex
            videoPlayerIsVisible = false
            videoControlState = .stable
            videoHandler.pause()
            videoPlayingStateSymbolIsVisible = false
            videoBatterySymbolIsVisible = false
            videoVolumeBarIsVisible = false
            videoSeekBarIsVisible = false
            videoSymbolTimer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
                self.videoDetailIsShown = false
            }
            return
        } else if key == .nowPlayingVideo {
            currentKeyIsNowPlayingVideo = false
            DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
                self.videoPlayerIsVisible = false
                self.videoControlState = .stable
                self.videoHandler.pause()
                self.videoPlayingStateSymbolIsVisible = false
                self.videoBatterySymbolIsVisible = false
                self.videoVolumeBarIsVisible = false
                self.videoSeekBarIsVisible = false
                self.videoSymbolTimer?.invalidate()
                self.goLeft()
            }
            return
        }
        
        guard statusModel.pageKeyArray.count > 1 else { return }
        guard key != .main else { return }
        
        goLeft()
    }
    
    func bottomButtonTapped() {
        vibeHandler.heavyVibe(if: vibeIsActivated)
        
        guard transitionState == .normal && buttonsAreAvailable else {
            return
        }
        
        if key == .nowPlaying && nowPlayingTransitionState == .volume {
            _ = 0
        }
        else if key == .nowPlaying && nowPlayingTransitionState == .seek {
            resetStableTimer_fromSeekToStable()
        }
        else {
            resetStableTimer_fromOutsideToNowPlaying()
        }
        headerTimeIsShown = false
        resetHeaderTimeTimer()
        
        // when playing
        if playingState == .playing {
            musicHandler.musicPlayer.pause()
        } else if playingState == .playingVideo {
            videoHandler.pause()
            videoPlayingStateSymbolIsVisible = true
            videoBatterySymbolIsVisible = true
            resetVideoSymbolTimer_short()
        }
        
        // when not playing
        else if [.paused, .stopped, .pausedVideo].contains(playingState) {
            var didSomething = false
            
            // direct play
            if pageData.pageBodyStyle == .list {
                if let safeRowDataArray = pageData.rowDataArray, let focusedIndex = focusedIndex {
                    let rowHandlingProperty =  safeRowDataArray[focusedIndex].handlingProperty
                    switch rowHandlingProperty {
                        case .canPlay:
                            musicHandler.getUserSubscriptionAvailability { userSubscripts in
                                if userSubscripts {
                                    if safeRowDataArray[focusedIndex].text != "모두\t" {
                                        switch self.key {
                                            case .playlists:
                                                self.statusModel.chosenPlaylist = safeRowDataArray[focusedIndex].playlist
                                            case .artists, .chosenGenre:
                                                self.statusModel.chosenArtist = safeRowDataArray[focusedIndex].text
                                            case .albums, .chosenArtist, .chosenComposer:
                                                self.statusModel.chosenAlbum = safeRowDataArray[focusedIndex].text
                                            case .genres:
                                                self.statusModel.chosenGenre = safeRowDataArray[focusedIndex].text
                                            case .composers:
                                                self.statusModel.chosenComposer = safeRowDataArray[focusedIndex].text
                                            default:
                                                _ = 0
                                        }
                                    }
                                    
                                    self.doBottomButtonAction_canPlay()
                                    self.goRight(newPageKey: .nowPlaying)
                                } else {
                                    self.subscriptionAlertIsPresented = true
                                }
                            }
                            didSomething = true
                        case .play:
                            musicHandler.getUserSubscriptionAvailability { userSubscripts in
                                if userSubscripts {
                                    self.centerButtonTapped()
                                } else {
                                    self.subscriptionAlertIsPresented = true
                                }
                            }
                            didSomething = true
                        case .shufflePlay:
                            musicHandler.getUserSubscriptionAvailability { userSubscripts in
                                if userSubscripts {
                                    self.centerButtonTapped()
                                } else {
                                    self.subscriptionAlertIsPresented = true
                                }
                            }
                            didSomething = true
                        default:
                            _ = 0
                    }
                }
            } else if pageData.pageBodyStyle == .video {
                if !videoDetailIsShown {
                    centerButtonTapped()
                    didSomething = true
                }
            }
            
            // when direct play didn't happen
            if !didSomething {
                if playingState == .paused {
                    Task {
                        do {
                            try await musicHandler.musicPlayer.play()
                        } catch {
                            print("PodObservable | bottomButtonTapped() | error playing music: \(error.localizedDescription)")
                        }
                    }
                } else if playingState == .pausedVideo {
                    if (key == .videos && videoDetailIsShown) || key == .nowPlayingVideo {
                        videoHandler.restart()
                        videoPlayingStateSymbolIsVisible = true
                        videoBatterySymbolIsVisible = true
                        resetVideoSymbolTimer_short()
                    } else {
                        videoPlayerIsVisible = true
                        currentKeyIsNowPlayingVideo = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
                            self.goRight(newPageKey: .nowPlayingVideo)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime + DesignSystem.Time.slidingAnimationTime) {
                            self.videoHandler.restart()
                            self.videoPlayingStateSymbolIsVisible = true
                            self.videoBatterySymbolIsVisible = true
                            self.resetVideoSymbolTimer_short()
                        }
                    }
                }
            }
        }
    }
    
    func doBottomButtonAction_canPlay() {
        self.lineup = []
        musicHandler.playFilteredSongs(isShuffled: alwaysShuffle) {
            var tempArray: [Song] = []
            for entry in self.musicHandler.musicPlayer.queue.entries {
                if case let .song(songFromMusicPlayer) = entry.item {
                    tempArray.append(songFromMusicPlayer)
                }
            }
            DispatchQueue.main.async {
                self.lineup = MusicItemCollection<Song>(tempArray)
                var tempIndex = 0
                if let safeCurrentEntry = self.musicHandler.musicPlayer.queue.currentEntry {
                    if case let .song(currentSongFromMusicPlayer) = safeCurrentEntry.item {
                        
                        for i in 0..<self.lineup!.count {
                            if self.lineup![i].id == currentSongFromMusicPlayer.id {
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
    
    func leadingButtonTapped() {
        vibeHandler.heavyVibe(if: vibeIsActivated)
        
        guard transitionState == .normal else {
            return
        }
        
        if key == .nowPlaying && nowPlayingTransitionState == .volume {
            _ = 0
        }
        else if key == .nowPlaying && nowPlayingTransitionState == .seek {
            resetStableTimer_fromSeekToStable()
            return
        }
        else {
            resetStableTimer_fromOutsideToNowPlaying()
        }
        headerTimeIsShown = false
        resetHeaderTimeTimer()
        
        if [.playing, .paused].contains(playingState) {
            if let timePassed {
                if timePassed > 3.0 {
                    musicHandler.musicPlayer.restartCurrentEntry()
                } else {
                    Task {
                        do {
                            try await musicHandler.musicPlayer.skipToPreviousEntry()
                        } catch {
                            print("PodObservable | leadingButtonTapped() | error backward-skipping music: \(error.localizedDescription)")
                        }
                    }
                }
            }
        } else if ((key == .videos && videoDetailIsShown) || key == .nowPlayingVideo) && [.playingVideo, .pausedVideo].contains(playingState) {
            if let videoTimePassed {
                if videoTimePassed > CMTime(value: 1800, timescale: 600) {
                    videoHandler.seekToBeginning()
                } else {
                    self.videoPlayerIsVisible = false
                    videoHandler.playPrev()
                    self.videoPlayerIsVisible = true
                    self.videoPlayingStateSymbolIsVisible = true
                    self.videoBatterySymbolIsVisible = true
                    self.resetVideoSymbolTimer_short()
                }
            }
        }
    }
    
    func trailingButtonTapped() {
        vibeHandler.heavyVibe(if: vibeIsActivated)
        
        guard transitionState == .normal && buttonsAreAvailable else {
            return
        }
        
        if key == .nowPlaying && nowPlayingTransitionState == .volume {
            _ = 0
        }
        else if key == .nowPlaying && nowPlayingTransitionState == .seek {
            resetStableTimer_fromSeekToStable()
            return
        }
        else {
            resetStableTimer_fromOutsideToNowPlaying()
        }
        headerTimeIsShown = false
        resetHeaderTimeTimer()
        
        if [.playing, .paused].contains(playingState) {
            Task {
                do {
                    try await musicHandler.musicPlayer.skipToNextEntry()
                } catch {
                    print("PodObservable | trailingButtonTapped() | error forward-skipping music: \(error.localizedDescription)")
                }
            }
        } else if ((key == .videos && videoDetailIsShown) || key == .nowPlayingVideo) && [.playingVideo, .pausedVideo].contains(playingState) {
            self.videoPlayerIsVisible = false
            self.videoHandler.playNext()
            self.videoPlayerIsVisible = true
            self.videoPlayingStateSymbolIsVisible = true
            self.videoBatterySymbolIsVisible = true
            self.resetVideoSymbolTimer_short()
        }
    }
    
    func leadingButtonLongPressed() {
        guard transitionState == .normal && buttonsAreAvailable else {
            return
        }
        
        if key == .nowPlaying && nowPlayingTransitionState == .volume {
            _ = 0
        }
        else if key == .nowPlaying && nowPlayingTransitionState == .seek {
            // leading button doesn't work here
            return
        }
        else {
            resetStableTimer_fromOutsideToNowPlaying()
        }
        headerTimeIsShown = false
        resetHeaderTimeTimer()
        
        musicHandler.musicPlayer.beginSeekingBackward()
    }
    
    func trailingButtonLongPressed() {
        guard transitionState == .normal && buttonsAreAvailable else {
            return
        }
        
        if key == .nowPlaying && nowPlayingTransitionState == .volume {
            _ = 0
        }
        else if key == .nowPlaying && nowPlayingTransitionState == .seek {
            // trailing button doesn't work here
            return
        }
        else {
            resetStableTimer_fromOutsideToNowPlaying()
        }
        headerTimeIsShown = false
        resetHeaderTimeTimer()
        
        musicHandler.musicPlayer.beginSeekingForward()
    }
    
    //MARK: - wheel property
    
    func getWheelProperty(_ key: PageKey) -> WheelPropertyKey {
        let pageData = getPageData(key)
        switch pageData.pageBodyStyle {
            case .empty:
                return .nothing
            case .list:
                return .focusedIndex
            case .nowPlaying:
                return .volume
            case .nowPlayingVideo:
                return .volume
            case .photo:
                return .focusedIndex
            case .video:
                return .focusedIndex
            case .text:
                return .nothing
        }
    }
}
