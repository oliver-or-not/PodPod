//
//  PodObservable+(PageTransition).swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/09/03.
//

import Foundation

extension PodObservable {
    
    //MARK: - page transition
    
    func goRight(newPageKey: PageKey) {
        let lagTime = DesignSystem.Time.lagTime
        
        doThingsBeforeMakingGhost_goingRightVer()
        doThingsBeforeGoingRight(newPageKey: newPageKey)
        self.transitionState = .goingRight
        DispatchQueue.main.asyncAfter(deadline: .now() + lagTime) {
            self.shownPageNum += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + lagTime + DesignSystem.Time.slidingAnimationTime) {
            self.transitionState = .normal
        }
    }
    
    func goLeft() {
        let lagTime = DesignSystem.Time.lagTime
        
        doThingsBeforeMakingGhost_goingLeftVer()
        doThingsBeforeGoingLeft()
        self.transitionState = .goingLeft
        DispatchQueue.main.asyncAfter(deadline: .now() + lagTime) {
            self.shownPageNum -= 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + lagTime + DesignSystem.Time.slidingAnimationTime) {
            self.transitionState = .normal
        }
    }
    
    //MARK: - submethods of page transition
    
    // transition animation will be controlled in PageBodyStackView
    func doThingsBeforeMakingGhost_goingRightVer() {
        // have previous frontier page be settled
        let sk = PageSK()
        sk.focusedIndex = focusedIndex
        sk.discreteScrollMark = discreteScrollMark
        
        statusModel.pageSKDictionary[key] = sk
        
        frontierPageNum += 1
        
        key_ghost = key
        pageData_ghost = pageData
        currentRowCount_ghost = currentRowCount
        wheelProperty_ghost = wheelProperty
        focusedIndex_ghost = focusedIndex
        discreteScrollMark_ghost = discreteScrollMark
        continuousScrollMark_ghost = continuousScrollMark
        nowPlayingTransitionState_ghost = nowPlayingTransitionState
        
    }
    
    func doThingsBeforeGoingRight(newPageKey: PageKey) {
        // initialize new page's property-flat view model
        statusModel.pageKeyArray.append(newPageKey)
        key = newPageKey
        
        // update filteredSong, chosenComposer etc.
        if pageData_ghost.pageBodyStyle == .list {
            let prevKey = key_ghost
            let prevFocusedRow = pageData_ghost.rowDataArray![focusedIndex_ghost!]
            if prevFocusedRow.handlingProperty == .canPlay {
                switch prevKey {
                    case .playlists:
                        statusModel.chosenPlaylist = prevFocusedRow.playlist
                    case .albums, .chosenArtist, .chosenComposer:
                        if prevFocusedRow.text == "모두\t" {
                            _ = 0
                        } else {
                            if statusModel.chosenAlbum == nil {
                                statusModel.chosenAlbum = prevFocusedRow.text
                            }
                        }
                    case .artists, .chosenGenre:
                        if prevFocusedRow.text == "모두\t" {
                            _ = 0
                        } else {
                            statusModel.chosenArtist = prevFocusedRow.text
                        }
                    case .genres:
                        if prevFocusedRow.text == "모두\t" {
                            _ = 0
                        } else {
                            statusModel.chosenGenre = prevFocusedRow.text
                        }
                    case .composers:
                        if prevFocusedRow.text == "모두\t" {
                            _ = 0
                        } else {
                            statusModel.chosenComposer = prevFocusedRow.text
                        }
                    default:
                        _ = 0
                }
            }
        }
        
        pageData = getPageData(newPageKey)
        
//        // skip .chosenAlbum page when there is only one album
//        if key == .albums || key == .chosenComposer || key == .chosenArtist {
//            if let rowDataArray = pageData.rowDataArray, let librarySongs = dataModel.librarySongs {
//                if rowDataArray.count == 1 && rowDataArray[0].text != "모두\t" && librarySongs.count > 0 {
//                    _ = statusModel.pageKeyArray.popLast()
//                    statusModel.chosenAlbum = rowDataArray[0].text
//                    // ghostPageSK will not be redefined by this(below) line
//                    doThingsBeforeGoingRight(newPageKey: .chosenAlbum)
//                }
//            }
//        }
        
        // reset nowPlayingTransitionState
        if key == .nowPlaying {
            nowPlayingTransitionState = .stable
        }
        
        // set currenetRowCount and wheelProperty
        if key == .photos {
            self.currentRowCount = self.dataModel.favoritePhotoArray.count
        } else if key == .videos {
            self.currentRowCount = self.dataModel.favoriteVideoThumbnailArray.count
        } else {
            currentRowCount = pageData.rowDataArray?.count
        }
        wheelProperty = getWheelProperty(newPageKey)
        
        // In case user haven't visited the page
        guard let loadedSK = statusModel.pageSKDictionary[newPageKey] else {
            
            switch wheelProperty {
                case .nothing, .volume, .soundLimit, .brightness:
                    _ = 0
                case .focusedIndex:
                    focusedIndex = 0
                    discreteScrollMark = 0
                case .scroll:
                    continuousScrollMark = 0.0
                default:
                    _ = 0
            }
            return
        }
        
        switch wheelProperty {
            case .nothing, .volume, .soundLimit, .brightness:
                _ = 0
            case .focusedIndex:
                // reset focusedIndex and discrereScrollMark if (e.g.) chosen artist is different from the prev chosen artist; album, genre, composer, playlist, ... the same.q
                var needReset = false
                switch key {
                    case .chosenPlaylist:
                        if statusModel.chosenPlaylist != statusModel.prevChosenPlaylist {
                            needReset = true
                        }
                    case .chosenArtist:
                        if statusModel.chosenArtist != statusModel.prevChosenArtist {
                            needReset = true
                        }
                    case .chosenAlbum:
                        if statusModel.chosenAlbum != statusModel.prevChosenAlbum {
                            needReset = true
                        }
                    case .chosenGenre:
                        if statusModel.chosenGenre != statusModel.prevChosenGenre {
                            needReset = true
                        }
                    case .chosenComposer:
                        if statusModel.chosenComposer != statusModel.prevChosenComposer {
                            needReset = true
                        }
                    case .photos, .videos:
                        needReset = true
                    default:
                        _ = 0
                }
                if needReset {
                    focusedIndex = 0
                    discreteScrollMark = 0
                } else {
                    if let safeLoadedFocusedIndex = loadedSK.focusedIndex, let safeLoadedDiscreteScrollMark = loadedSK.discreteScrollMark, let safeCurrentRowCount = currentRowCount {
                        focusedIndex = max(0, min(safeLoadedFocusedIndex, safeCurrentRowCount))
                        discreteScrollMark = max(0, min(safeLoadedDiscreteScrollMark, safeCurrentRowCount - DesignSystem.Soft.Dimension.rangeOfRows))
                    } else {
                        focusedIndex = 0
                        discreteScrollMark = 0
                    }
                }
            case .scroll:
                continuousScrollMark = 0.0
            default:
                _ = 0
        }
        resetStableTimer_fromOutsideToNowPlaying()
    }
    
    func doThingsBeforeMakingGhost_goingLeftVer() {
        // have previous frontier page be settled
        let skToBeSaved = PageSK()
        skToBeSaved.focusedIndex = focusedIndex
        skToBeSaved.discreteScrollMark = discreteScrollMark
        
        statusModel.pageSKDictionary[key] = skToBeSaved
        
        frontierPageNum -= 1
        
        key_ghost = key
        pageData_ghost = pageData
        currentRowCount_ghost = currentRowCount
        wheelProperty_ghost = wheelProperty
        focusedIndex_ghost = focusedIndex
        discreteScrollMark_ghost = discreteScrollMark
        continuousScrollMark_ghost = continuousScrollMark
        nowPlayingTransitionState_ghost = nowPlayingTransitionState
    }
    
    func doThingsBeforeGoingLeft() {
        _ = statusModel.pageKeyArray.popLast()
        let newPageKey = statusModel.pageKeyArray.last!
         
        // update filteredSong, chosenComposer etc.
        /*
         ~.music page key flow~
         .artists > .chosenArtist > .chosenAlbum
         .artists > .chosenAlbum
         .albums > .chosenAlbum
         .genres > .chosenGenre > .chosenArtist > .chosenAlbum
         .genres > .chosenGenre > .chosenAlbum
         .composers > .chosenComposer > .chosenAlbum
         .composers > .chosenAlbum
         */
        switch newPageKey {
            case .chosenArtist:
                statusModel.chosenAlbum = nil
            case .chosenGenre:
                statusModel.chosenArtist = nil
                statusModel.chosenAlbum = nil
            case .chosenComposer:
                statusModel.chosenAlbum = nil
            case .playlists, .artists, .albums, .genres, .composers:
                statusModel.chosenPlaylist = nil
                statusModel.chosenArtist = nil
                statusModel.chosenAlbum = nil
                statusModel.chosenGenre = nil
                statusModel.chosenComposer = nil
            default:
                _ = 0
        }
        
        pageData = getPageData(newPageKey)
        currentRowCount = pageData.rowDataArray?.count
        
        key = newPageKey
        
        wheelProperty = getWheelProperty(newPageKey)
        
        // first visit to page
        guard let loadedSK = statusModel.pageSKDictionary[newPageKey] else {
            
            switch wheelProperty {
                case .nothing, .volume, .soundLimit, .brightness:
                    _ = 0
                case .focusedIndex:
                    focusedIndex = 0
                    discreteScrollMark = 0
                case .scroll:
                    continuousScrollMark = 0.0
                default:
                    _ = 0
            }
            return
        }
        
        // not first visit to page
        switch wheelProperty {
            case .nothing, .volume, .soundLimit, .brightness:
                _ = 0
            case .focusedIndex:
                if let safeLoadedFocusedIndex = loadedSK.focusedIndex, let safeLoadedDiscreteScrollMark = loadedSK.discreteScrollMark, let safeCurrentRowCount = currentRowCount {
                    focusedIndex = max(0, min(safeLoadedFocusedIndex, safeCurrentRowCount - 1))
                    discreteScrollMark = max(0, min(safeLoadedDiscreteScrollMark, safeCurrentRowCount - DesignSystem.Soft.Dimension.rangeOfRows))
                } else {
                    focusedIndex = 0
                    discreteScrollMark = 0
                }
            case .scroll:
                continuousScrollMark = 0.0
            default:
                _ = 0
        }
    }
    
    //MARK: - .nowPlaying transition
    
    func fromStableToSeek() {
        nowPlayingLowerOffsetTrigger = false
        wheelProperty = .nothing
        nowPlayingTransitionState = .stableToSeek
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
            self.nowPlayingLowerOffsetTrigger = true
        }
        nowPlayingTransitionCounter += 1
        let capturedNowPlayingTransitionCounter = nowPlayingTransitionCounter
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime + DesignSystem.Time.slidingAnimationTime) {
            if capturedNowPlayingTransitionCounter == self.nowPlayingTransitionCounter {
                self.nowPlayingTransitionState = .seek
                self.wheelProperty = .seek
                self.seekIsUsed = false
                self.resetStableTimer_fromSeekToStable()
            }
        }
    }
    func fromVolumeToStable() {
        nowPlayingLowerOffsetTrigger = false
        wheelProperty = .nothing
        nowPlayingTransitionState = .volumeToStable
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
            self.nowPlayingLowerOffsetTrigger = true
        }
        nowPlayingTransitionCounter += 1
        let capturedNowPlayingTransitionCounter = nowPlayingTransitionCounter
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime + DesignSystem.Time.slidingAnimationTime) {
            if capturedNowPlayingTransitionCounter == self.nowPlayingTransitionCounter {
                self.nowPlayingTransitionState = .stable
                self.wheelProperty = .volume
            }
        }
    }
    func fromSeekToFullArtwork() {
        if !seekIsUsed {
            self.nowPlayingBodyOffsetTrigger = false
            wheelProperty = .nothing
            nowPlayingTransitionState = .seekToFullArtwork
            DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
                self.nowPlayingBodyOffsetTrigger = true
            }
            nowPlayingTransitionCounter += 1
            let capturedNowPlayingTransitionCounter = nowPlayingTransitionCounter
            DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime + DesignSystem.Time.slidingAnimationTime) {
                if capturedNowPlayingTransitionCounter == self.nowPlayingTransitionCounter {
                    self.nowPlayingTransitionState = .fullArtwork
                    self.wheelProperty = .volume
                }
            }
        } else {
            self.nowPlayingLowerOffsetTrigger = false
            wheelProperty = .nothing
            nowPlayingTransitionState = .seekToStable
            DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
                self.nowPlayingLowerOffsetTrigger = true
            }
            nowPlayingTransitionCounter += 1
            let capturedNowPlayingTransitionCounter = nowPlayingTransitionCounter
            DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime + DesignSystem.Time.slidingAnimationTime) {
                if capturedNowPlayingTransitionCounter == self.nowPlayingTransitionCounter {
                    self.nowPlayingTransitionState = .stable
                    self.wheelProperty = .volume
                }
            }
        }
    }
    func fromSeekToStable() {
        nowPlayingLowerOffsetTrigger = false
        wheelProperty = .nothing
        nowPlayingTransitionState = .seekToStable
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
            self.nowPlayingLowerOffsetTrigger = true
        }
        nowPlayingTransitionCounter += 1
        let capturedNowPlayingTransitionCounter = nowPlayingTransitionCounter
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime + DesignSystem.Time.slidingAnimationTime) {
            if capturedNowPlayingTransitionCounter == self.nowPlayingTransitionCounter {
                self.nowPlayingTransitionState = .stable
                self.wheelProperty = .volume
            }
        }
        
    }
    func fromFullArtworkToStable() {
        self.nowPlayingBodyOffsetTrigger = false
        wheelProperty = .nothing
        nowPlayingTransitionState = .fullArtworkToStable
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime) {
            self.nowPlayingBodyOffsetTrigger = true
        }
        nowPlayingTransitionCounter += 1
        let capturedNowPlayingTransitionCounter = nowPlayingTransitionCounter
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.lagTime + DesignSystem.Time.slidingAnimationTime) {
            if capturedNowPlayingTransitionCounter == self.nowPlayingTransitionCounter {
                self.nowPlayingTransitionState = .stable
                self.wheelProperty = .volume
            }
        }
    }
}
