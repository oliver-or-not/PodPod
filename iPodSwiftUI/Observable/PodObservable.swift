//
//  PodObservable.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/15.
//

import AVFoundation
import Combine
import MusicKit
import UIKit

final class PodObservable: ObservableObject {
    
    static let shared = PodObservable()
    
    //MARK: - singleton object
    
    // contains songs and photos
    let dataModel = DataModel.shared
    // contains non-published properties
    let statusModel = StatusModel.shared

    // handles music data
    let musicHandler = MusicHandler.shared
    // handles photo data
    let photoHandler = PhotoHandler.shared
    // handles vidoe data
    let videoHandler = VideoHandler.shared
    // handles taptic vibration
    let vibeHandler = VibeHandler.shared
    
    //MARK: - iPod current state (1)
    
    @Published var transitionState: TransitionState = .normal
    // shown page
    @Published var shownPageNum: Int = 0
    // real-time-refresh page
    @Published var frontierPageNum: Int = 0
    @Published var batteryState: BatteryState = .unplugged
    @Published var batteryLevel: Float = 1.0
    @Published var volume: Float = 0.0
    @Published var timeTitle: String = ""
    // user default variable
    @Published var wantsToSeeTimeInHeader = false
    // user default variable
    @Published var vibeIsActivated = true
    // user default variable
    @Published var videoZoomMode: VideoZoomMode = .fit
    // user default variable
    @Published var videoAutoplayMode: VideoAutoplayMode = .one
    @Published var libraryUpdateSymbolState: LibraryUpdateSymbolState = .notShown
    // user default variable
    @Published var mainMenuBoolArray: [Bool] = StatusModel.initialValueOfMainMenuBoolArray
    @Published var headerTimeIsShown = false
    @Published var subscriptionAlertIsPresented = false
    @Published var videoNetworkAlertIsPresented = false
    @Published var userAllowedVideoNetworkLoading = false {
        didSet {
            if userAllowedVideoNetworkLoading {
                if let currentAsset = videoHandler.currentAsset {
                    videoHandler.play(currentAsset, networkAccessIsAllowed: true)
                }
                userAllowedVideoNetworkLoading = false
            }
        }
    }
    @Published var mediaRefreshNetworkAlertIsPresented = false
    @Published var userAllowedMediaRefreshNetworkLoading = false {
        didSet {
            if userAllowedMediaRefreshNetworkLoading {
                libraryUpdateSymbolState = .loading
                videoHandler.fetchFavoriteVideoAssets(networkAccessIsAllowed: true) {
                    self.photoHandler.fetchFavoritePhotos(networkAccessIsAllowed: true) {
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
                userAllowedMediaRefreshNetworkLoading = false
            }
        }
    }
    @Published var photoDetailIsShown = false
    @Published var videoLoadingState: VideoLoadingState = .notLoading
    @Published var videoDetailIsShown = false
    @Published var videoPlayerIsVisible = false
    @Published var videoPlayingStateSymbolIsVisible = false
    @Published var videoBatterySymbolIsVisible = false
    @Published var videoVolumeBarIsVisible = false
    @Published var videoSeekBarIsVisible = false
    @Published var headerIsSwiped = false
    @Published var buttonsAreAvailable = true
    
    //MARK: - iPod current state (2) (stuffs about playing)
    
    @Published var playingState: PlayingState = .stopped
    // user default variable
    @Published var repeatState: RepeatState = .off
    // user default variable
    @Published var alwaysShuffle = false
    @Published var shuffleIsActivated = false 
    @Published var currentSongIndex: Int?
    @Published var timePassed: TimeInterval?
    @Published var lineup: MusicItemCollection<Song>?
    
    @Published var currentSong: Song? {
        didSet {
            if key == .nowPlaying {
                nowPlayingUpperTextFlick()
            }
        }
    }
    @Published var currentSongArtwork: Artwork? {
        didSet {
            if let imageURL = currentSongArtwork?.url(width: 320, height: 320) {
                URLSession.shared.dataTask(with: imageURL) { data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.currentArtworkUIImage_thumb = image
                        }
                    } else if let error = error {
                        print("PodObservable | currentSongArtwork didSet | error downloading image: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.currentArtworkUIImage_thumb = nil
                        }
                    }
                }.resume()
            } else {
                DispatchQueue.main.async {
                    self.currentArtworkUIImage_thumb = nil
                }
            }
            
            if let imageURL = currentSongArtwork?.url(width: 640, height: 640) {
                URLSession.shared.dataTask(with: imageURL) { data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.currentArtworkUIImage_full = image
                        }
                    } else if let error = error {
                        print("PodObservable | currentSongArtwork didSet | error downloading image: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.currentArtworkUIImage_full = nil
                        }
                    }
                }.resume()
            } else {
                DispatchQueue.main.async {
                    self.currentArtworkUIImage_full = nil
                }
            }
        }
    }
    
    @Published var currentArtworkUIImage_thumb: UIImage?
    @Published var currentArtworkUIImage_full: UIImage?
    
    @Published var currentSongTitle: String?
    @Published var currentSongArtistName: String?
    @Published var currentSongAlbumTitle: String?
    @Published var currentSongTotalTime: TimeInterval?
    
    @Published var videoTimePassed: CMTime?
    @Published var currentVideoTotalTime: CMTime?
    
    //MARK: - property for frontier page
    
    @Published var key: PageKey = .empty
    @Published var pageData = PageData()
    @Published var currentRowCount: Int?
    @Published var wheelProperty: WheelPropertyKey = .nothing
    @Published var focusedIndex: Int?
    // start index of discrete scroll 'range' of visible area
    @Published var discreteScrollMark: Int?
    // start location of continuous scroll 'range' of visible area
    @Published var continuousScrollMark: CGFloat?
    @Published var nowPlayingTransitionState: NowPlayingTransitionState = .stable {
        didSet {
            if nowPlayingTransitionState == .stable {
                DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.nowPlayingUpperTextLagTime) {
                    self.nowPlayingUpperTextFlick()
                }
            }
        }
    }
    @Published var videoControlState: VideoControlState = .stable
    
    //MARK: - ghost property for prev page
    
    var key_ghost: PageKey = .empty
    var pageData_ghost = PageData()
    var currentRowCount_ghost: Int?
    var wheelProperty_ghost: WheelPropertyKey = .nothing
    var focusedIndex_ghost: Int?
    var discreteScrollMark_ghost: Int?
    var continuousScrollMark_ghost: CGFloat?
    var nowPlayingTransitionState_ghost: NowPlayingTransitionState = .stable
    
    //MARK: - wheel value
    
    var wheelValue: CGFloat? = nil {
        didSet {
            wheelValuePublisher.send(wheelValue)
        }
    }
    var wheelValuePublisher = PassthroughSubject<CGFloat?, Never>()
    var previousWheelValue: CGFloat? = nil
    var cancellables: Set<AnyCancellable> = []
    
    //MARK: - dummy variable to handle View
    
    // need base values to use wheel value
    var baseVolume: Float = 0.0
    var getVolumeCompletionIsDone = true
    var baseTimePassed: TimeInterval = 0.0
    var baseVideoTimePassed: CMTime = CMTime()
    // check whether seek manipulation happened or not; true -> next page is .stable; false -> next page is .fullArtwork
    var seekIsUsed = false
    var nowPlayingTransitionCounter: Int = 0
    var nowPlayingUpperTextFlickCounter: Int = 0
    
    @Published var nowPlayingBodyOffsetTrigger = false
    @Published var nowPlayingLowerOffsetTrigger = false
    @Published var nowPlayingUpperTextFlicker = true
    @Published var nowPlayingUpperTextOffsetTrigger = false
    @Published var currentKeyIsNowPlayingVideo = false // need to slide header
    
    //MARK: - timer
    
    var headerTimeTimer: Timer?
    var stableTimer: Timer?
    var videoSymbolTimer: Timer?
    var playInfoRefresher: Timer?
    var batteryInfoRefresher: Timer?

    //MARK: - initializer
    
    private init() {
        
        //MARK: - volume and battery
        
        volume = AVAudioSession.sharedInstance().outputVolume
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        switch UIDevice.current.batteryState {
            case .unplugged:
                batteryState = .unplugged
            case .charging:
                batteryState = .charging
            case .full:
                batteryState = .full
            default:
                batteryState = .unknown
        }
        batteryLevel = UIDevice.current.batteryLevel
        
        //MARK: - request music

        if dataModel.librarySongs == nil {
            musicHandler.requestUpdateLibrary {}
        }
        if dataModel.playlists == nil {
            musicHandler.requestUpdatePlaylists {}
        }
        
        //MARK: - fetch photos and videos (network off)

        photoHandler.fetchFavoritePhotos(networkAccessIsAllowed: false) {}
        videoHandler.fetchFavoriteVideoAssets(networkAccessIsAllowed: false) {}
        
        //MARK: - make the main page
        
        key = .main
        pageData = getPageData(.main)
        wheelProperty = .focusedIndex
        focusedIndex = 0
        discreteScrollMark = 0
        continuousScrollMark = nil
        
        statusModel.pageKeyArray = [.main]
        currentRowCount = getPageData(.main).rowDataArray!.count
        
        //MARK: - use wheelValue
        
        // will sink between each frame while dragging
        // Combine을 사용하여 "wheelValue"의 변경을 감시하고, 변경될 때마다 동작 수행
        wheelValuePublisher
            .sink { [weak self] newValue in
                self?.handleWheelValueChange(newValue: newValue, prevValue: self?.previousWheelValue)
                self?.previousWheelValue = newValue // 직전 값 갱신
            }
            .store(in: &cancellables)
        
        //MARK: - user default
        
        if let wantsToSeeTimeInHeaderFromUserDefault = UserDefaults.standard.object(forKey: "wantsToSeeTimeInHeader") as? Bool {
            wantsToSeeTimeInHeader = wantsToSeeTimeInHeaderFromUserDefault
        }
        // no save -> false
        else {
            wantsToSeeTimeInHeader = false
            UserDefaults.standard.set(wantsToSeeTimeInHeader, forKey: "wantsToSeeTimeInHeader")
        }
        
        
        if let repeatStateRawValueFromUserDefault = UserDefaults.standard.object(forKey: "repeatState.rawValue") as? Int {
            switch repeatStateRawValueFromUserDefault {
                case 0:
                    musicHandler.musicPlayer.state.repeatMode = MusicPlayer.RepeatMode.none
                    repeatState = .off
                case 1:
                    musicHandler.musicPlayer.state.repeatMode = .one
                    repeatState = .one
                case 2:
                    musicHandler.musicPlayer.state.repeatMode = .all
                    repeatState = .all
                default:
                    musicHandler.musicPlayer.state.repeatMode = MusicPlayer.RepeatMode.none
                    repeatState = .off
            }
        }
        // no save -> .off
        else {
            repeatState = .off
            UserDefaults.standard.set(repeatState.rawValue, forKey: "repeatState.rawValue")
        }
        
        
        if let alwaysShuffleFromUserDefault = UserDefaults.standard.object(forKey: "alwaysShuffle") as? Bool {
            alwaysShuffle = alwaysShuffleFromUserDefault
        }
        // no save -> false
        else {
            alwaysShuffle = false
            UserDefaults.standard.set(alwaysShuffle, forKey: "alwaysShuffle")
        }
        
        if let vibeIsActivatedFromUserDefault = UserDefaults.standard.object(forKey: "vibeIsActivated") as? Bool {
            vibeIsActivated = vibeIsActivatedFromUserDefault
        }
        // no save -> true
        else {
            vibeIsActivated = true
            UserDefaults.standard.set(vibeIsActivated, forKey: "vibeIsActivated")
        }
        
        if let mainMenuBoolArrayFromUserDefault = UserDefaults.standard.object(forKey: "mainMenuBoolArray") as? [Bool] {
            mainMenuBoolArray = mainMenuBoolArrayFromUserDefault
        }
        // no save -> initialValueOfMainMenuBoolArray
        else {
            mainMenuBoolArray = StatusModel.initialValueOfMainMenuBoolArray
            UserDefaults.standard.set(mainMenuBoolArray, forKey: "mainMenuBoolArray")
        }
        
        if let videoZoomModeRawValueFromUserDefault = UserDefaults.standard.object(forKey: "videoZoomMode.rawValue") as? Int {
            switch videoZoomModeRawValueFromUserDefault {
                case 0:
                    videoZoomMode = .fit
                case 1:
                    videoZoomMode = .zoom
                default:
                    videoZoomMode = .fit
            }
        }
        // no save -> .fit
        else {
            videoZoomMode = .fit
            UserDefaults.standard.set(videoZoomMode.rawValue, forKey: "videoZoomMode.RawValue")
        }
        
        if let videoAutoplayModeRawValueFromUserDefault = UserDefaults.standard.object(forKey: "videoAutoplayMode.rawValue") as? Int {
            switch videoAutoplayModeRawValueFromUserDefault {
                case 0:
                    videoAutoplayMode = .off
                case 1:
                    videoAutoplayMode = .one
                case 2:
                    videoAutoplayMode = .all
                default:
                    videoAutoplayMode = .off
            }
        }
        // no save -> off
        else {
            videoAutoplayMode = .off
            UserDefaults.standard.set(videoAutoplayMode.rawValue, forKey: "videoAutoplayMode.RawValue")
        }
            
        //MARK: -  set refresher
        
        resetHeaderTimeTimer()
        setPlayInfoRefresher()
        setBatteryInfoRefresher()
    }
    
    //MARK: - manual refresh method
    
    func nowPlayingUpperTextFlick() {
        nowPlayingUpperTextFlickCounter += 1
        let capturedCounter = nowPlayingUpperTextFlickCounter
        nowPlayingUpperTextOffsetTrigger = false
        nowPlayingUpperTextFlicker = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.nowPlayingUpperTextFlicker = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.nowPlayingUpperTextLagTime) {
            if capturedCounter == self.nowPlayingUpperTextFlickCounter {
                self.nowPlayingUpperTextOffsetTrigger = true
            }
        }
    }
}
