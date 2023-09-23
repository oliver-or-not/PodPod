//
//  ListStyleBodyView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/02.
//

import MusicKit
import SwiftUI

struct ListStyleBodyView: View {
    var key: PageKey
    var pageData: PageData
    var focusedIndex: Int?
    var discreteScrollMark: Int?
    var rowCount: Int?
    
    var wantsToSeeTimeInHeader: Bool
    var repeatState: RepeatState
    var alwaysShuffle: Bool
    
    var vibeIsActivated: Bool
    var videoZoomMode: VideoZoomMode
    var videoAutoplayMode: VideoAutoplayMode
    var libraryUpdateSymbolState: LibraryUpdateSymbolState
    var mainMenuBoolArray: [Bool]
    
    private var libraryCount = DataModel.shared.librarySongs?.count ?? 0
    private var playlistCount = DataModel.shared.playlists?.count ?? 0
    
    private var nowPlayingFontSize: CGFloat {
        DesignSystem.Soft.Dimension.nowPlayingFontSize
    }
    
    private var basicIndentation: CGFloat {
        DesignSystem.Soft.Dimension.basicIndentation
    }
    
    init(key: PageKey, pageData: PageData, focusedIndex: Int? = nil, discreteScrollMark: Int? = nil, rowCount: Int? = nil, wantsToSeeTimeInHeader: Bool, repeatState: RepeatState, alwaysShuffle: Bool, vibeIsActivated: Bool, videoZoomMode: VideoZoomMode, videoAutoplayMode: VideoAutoplayMode, libraryUpdateSymbolState: LibraryUpdateSymbolState, mainMenuBoolArray: [Bool])  {
        self.key = key
        self.pageData = pageData
        self.focusedIndex = focusedIndex
        self.discreteScrollMark = discreteScrollMark
        self.rowCount = rowCount
        self.wantsToSeeTimeInHeader = wantsToSeeTimeInHeader
        self.repeatState = repeatState
        self.alwaysShuffle = alwaysShuffle
        self.vibeIsActivated = vibeIsActivated
        self.videoZoomMode = videoZoomMode
        self.videoAutoplayMode = videoAutoplayMode
        self.libraryUpdateSymbolState = libraryUpdateSymbolState
        self.mainMenuBoolArray = mainMenuBoolArray
    }
    
    var body: some View {
        Group {
            if libraryCount == 0 && [.composers, .albums, .artists, .genres, .songs, .chosenGenre, .chosenComposer, .chosenArtist, .chosenAlbum].contains(key) {
                ZStack {
                    Color(.white)
                    
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: basicIndentation)
                        
                        Text("표시할 노래가 없습니다.\n\n1. Apple Music을 구독하고\n보관함에 노래를 추가하세요.\n2. 첫 화면에서 미디어를 새로고침하세요.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: nowPlayingFontSize, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Spacer()
                            .frame(width: basicIndentation)
                    }
                }
                .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
            }
            else if playlistCount == 0 && [.playlists, .chosenPlaylist].contains(key) {
                ZStack {
                    Color(.white)
                    
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: basicIndentation)
                        
                        Text("표시할 재생목록이 없습니다.\n\n1. Apple Music을 구독하고\n보관함에 플레이리스트를 추가하세요.\n2. 첫 화면에서 미디어를 새로고침하세요.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: nowPlayingFontSize, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Spacer()
                            .frame(width: basicIndentation)
                    }
                }
                .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
            }
            else {
                ZStack {
                    Color(.white)
                    
                    Group {
                        if let rowDataArray = pageData.rowDataArray, let focusedIndex, let discreteScrollMark, let rowCount {
                            HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                    ForEach(min(discreteScrollMark, rowDataArray.count)..<min(discreteScrollMark + DesignSystem.Soft.Dimension.rangeOfRows, rowDataArray.count), id: \.self) { i in
                                        RowView(rowData: rowDataArray[i], indexInList: i, isFocused: i == focusedIndex, wantsToSeeTimeInHeader: wantsToSeeTimeInHeader, repeatState: repeatState, alwaysShuffle: alwaysShuffle, vibeIsActivated: vibeIsActivated, videoZoomMode: videoZoomMode, videoAutoplayMode: videoAutoplayMode, libraryUpdateSymbolState: libraryUpdateSymbolState, mainMenuBoolArray: mainMenuBoolArray)
                                    }
                                    Spacer()
                                        .frame(minHeight: 0)
                                }
                                if rowCount > DesignSystem.Soft.Dimension.rangeOfRows {
                                    DiscreteScrollBarView(focusedIndex: focusedIndex, discreteScrollMark: discreteScrollMark, rowCount: rowCount, range: DesignSystem.Soft.Dimension.rangeOfRows)
                                }
                            }
                        } else {
                            Text("Empty")
                        }
                    }
                }
                .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
            }
        }
    }
}

struct ListStyleBodyView_Previews: PreviewProvider {
    
    static let pd = PageData(headerTitle: "PodPod", pageBodyStyle: .list, rowDataArray: [
        RowData(text: "음악", actionStyle: .chevronMove, key: .music),
        RowData(text: "사진", actionStyle: .chevronMove, key: .photos),
        RowData(text: "비디오", actionStyle: .chevronMove, key: .videos),
        RowData(text: "설정", actionStyle: .chevronMove, key: .settings),
        RowData(text: "노래 임의 재생", actionStyle: .emptyMove, key: .shuffleSongs)
    ])
    
    static var previews: some View {
        ListStyleBodyView(key: .songs, pageData: pd, focusedIndex: 0, discreteScrollMark: 0, rowCount: pd.rowDataArray?.count, wantsToSeeTimeInHeader: false, repeatState: .all, alwaysShuffle: true, vibeIsActivated: true, videoZoomMode: .fit, videoAutoplayMode: .off, libraryUpdateSymbolState: .done, mainMenuBoolArray: StatusModel.initialValueOfMainMenuBoolArray)
    }
}
