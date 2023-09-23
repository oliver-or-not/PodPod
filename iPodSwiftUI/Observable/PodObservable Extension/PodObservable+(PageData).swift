//
//  PodObservable+(PageData).swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/09/03.
//

import Foundation

extension PodObservable {
    
    //MARK: - getPagedata method
    
    // use this method to get PageData; especially when initializing a BodyView
    // need to manually refresh page when its PageData changes; since the return value of getPageData function is not a published variable
    func getPageData(_ key: PageKey) -> PageData {
        switch key {
                
            //MARK: - page data | .main
                
            case .main:
                let pd = PageData()
                if let title = UserDefaults.standard.object(forKey: "mainMenuTitle") as? String {
                    pd.headerTitle = title
                } else {
                    pd.headerTitle = DesignSystem.String.appName
                }
                pd.pageBodyStyle = .list
                pd.rowDataArray = [
                    RowData(text: "음악", actionStyle: .chevronMove, key: .music),
                    RowData(text: "사진", actionStyle: .chevronMove, key: .photos),
                    RowData(text: "비디오", actionStyle: .chevronMove, key: .videos),
                ]
                pd.rowDataArray! += getPageData(.music).rowDataArray!
                pd.rowDataArray! += [
                    RowData(text: "설정", actionStyle: .chevronMove, key: .settings),
                    RowData(text: "미디어 새로고침", actionStyle: .change, handlingProperty: .mediaRefresh),
                    RowData(text: "노래 임의 재생", actionStyle: .emptyMove, key: .nowPlaying, handlingProperty: .shufflePlay)
                ]
                
                var tempArray: [RowData] = []
                for i in 0..<min(pd.rowDataArray!.count, mainMenuBoolArray.count) {
                    if mainMenuBoolArray[i] {
                        tempArray.append(pd.rowDataArray![i])
                    }
                }
                
                pd.rowDataArray = tempArray
                
                // music
                if [.playing, .paused, .seekingBackward, .seekingForward].contains(playingState) {
                    pd.rowDataArray! += [
                        RowData(text: "지금 재생 중", actionStyle: .chevronMove, key: .nowPlaying)
                    ]
                }
                // video
                else if [.pausedVideo, .playingVideo].contains(playingState) {
                    pd.rowDataArray! += [
                        RowData(text: "지금 재생 중", actionStyle: .chevronMove, key: .nowPlayingVideo)
                    ]
                }
                return pd
            case .music:
                let pd = PageData()
                pd.headerTitle = "음악"
                pd.pageBodyStyle = .list
                pd.rowDataArray = [
                    RowData(text: "재생목록", actionStyle: .chevronMove, key: .playlists),
                    RowData(text: "아티스트", actionStyle: .chevronMove, key: .artists),
                    RowData(text: "앨범", actionStyle: .chevronMove, key: .albums),
                    RowData(text: "노래", actionStyle: .chevronMove, key: .songs),
                    RowData(text: "작곡가", actionStyle: .chevronMove, key: .composers)
                ]
                return pd
            case .photos:
                return PageData(headerTitle: "사진", pageBodyStyle: .photo)
            case .videos:
                return PageData(headerTitle: "비디오", pageBodyStyle: .video)
            case .settings:
                let pd = PageData()
                pd.headerTitle = "설정"
                pd.pageBodyStyle = .list
                pd.rowDataArray = [
                    RowData(text: "정보", actionStyle: .chevronMove, key: .about),
                    RowData(text: "주 메뉴", actionStyle: .chevronMove, key: .mainMenu),
                    RowData(text: "제목막대에 시간표시", actionStyle: .change, handlingProperty: .timeInHeader),
                    RowData(text: "임의 재생", actionStyle: .change, handlingProperty: .songShuffle),
                    RowData(text: "반복", actionStyle: .change, handlingProperty: .songRepeat),
                    RowData(text: "탭틱 피드백", actionStyle: .change, handlingProperty: .clickVibe),
                    RowData(text: "비디오 확대", actionStyle: .change, handlingProperty: .videoZoom),
                    RowData(text: "비디오 자동 재생", actionStyle: .change, handlingProperty: .videoAutoplay),
                    RowData(text: "추가 설정", actionStyle: .link, handlingProperty: .settingsLink)
                ]
                return pd
            case .shuffleSongs:
                return PageData(headerTitle: "지금 재생 중", pageBodyStyle: .nowPlaying)
            case .nowPlaying:
                return PageData(headerTitle: "지금 재생 중", pageBodyStyle: .nowPlaying)
            case .nowPlayingVideo:
                return PageData(headerTitle: "지금 재생 중", pageBodyStyle: .nowPlayingVideo)
            
            //MARK: - page data | .music
                
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
                
            case .playlists:
                let pd = PageData()
                pd.headerTitle = "재생목록"
                pd.pageBodyStyle = .list
                pd.rowDataArray = []
                guard let playlists = dataModel.playlists, playlists.count > 0 else {
                    pd.rowDataArray!.append(RowData())
                    return pd
                }
                
                for playlist in playlists {
                    pd.rowDataArray!.append(RowData(text: playlist.name, actionStyle: .chevronMove, key: .chosenPlaylist, handlingProperty: .canPlay, playlist: playlist))
                }
                return pd
            case .artists:
                let pd = PageData()
                pd.headerTitle = "아티스트"
                pd.pageBodyStyle = .list
                pd.rowDataArray = [RowData(text: "모두\t", actionStyle: .chevronMove, key: .chosenArtist, handlingProperty: .canPlay)]
                guard let librarySongs = dataModel.librarySongs else {
                    pd.rowDataArray = [RowData()]
                    return pd
                }
                
                var artistArray = musicHandler.getArtistArray(from: librarySongs)
                artistArray.sort(by: sortRule)
                
                if artistArray.count == 1 {
                    pd.rowDataArray = []
                }
                
                for artist in artistArray {
                    pd.rowDataArray!.append(RowData(text: artist, actionStyle: .chevronMove, key: .chosenArtist, handlingProperty: .canPlay))
                }
                return pd
            case .albums:
                let pd = PageData()
                pd.headerTitle = "앨범"
                pd.pageBodyStyle = .list
                pd.rowDataArray = [RowData(text: "모두\t", actionStyle: .chevronMove, key: .chosenAlbum, handlingProperty: .canPlay)]
                guard let librarySongs = dataModel.librarySongs else {
                    pd.rowDataArray = [RowData()]
                    return pd
                }
                
                var albumArray = musicHandler.getAlbumArray(from: librarySongs)
                albumArray.sort(by: sortRule)
                
                if albumArray.count == 1 {
                    pd.rowDataArray = []
                }
                
                for album in albumArray {
                    pd.rowDataArray!.append(RowData(text: album, actionStyle: .chevronMove, key: .chosenAlbum, handlingProperty: .canPlay))
                }
                return pd
            case .songs:
                let pd = PageData()
                pd.headerTitle = "노래"
                pd.pageBodyStyle = .list
                pd.rowDataArray = []
                
                guard let librarySongs = dataModel.librarySongs else {
                    pd.rowDataArray!.append(RowData())
                    return pd
                }
                
                guard librarySongs.count > 0 else {
                    pd.rowDataArray!.append(RowData())
                    return pd
                }
                
                for song in librarySongs {
                    pd.rowDataArray!.append(RowData(text: song.title, actionStyle: .emptyMove, key: .nowPlaying, handlingProperty: .play, song: song))
                }
                
                return pd
            case .genres: // "모두\t" row always exists
                let pd = PageData()
                pd.headerTitle = "장르"
                pd.pageBodyStyle = .list
                pd.rowDataArray = [RowData(text: "모두\t", actionStyle: .chevronMove, key: .chosenGenre, handlingProperty: .canPlay)]
                guard let librarySongs = dataModel.librarySongs else {
                    pd.rowDataArray! = [RowData()]
                    return pd
                }
                
                var genreArray = musicHandler.getGenreArray(from: librarySongs)
                genreArray.sort(by: sortRule)
                
                for genre in genreArray {
                    pd.rowDataArray!.append(RowData(text: genre, actionStyle: .chevronMove, key: .chosenGenre, handlingProperty: .canPlay))
                }
                return pd
            case .composers: // "모두\t" row always exists here
                let pd = PageData()
                pd.headerTitle = "작곡가"
                pd.pageBodyStyle = .list
                pd.rowDataArray = [RowData(text: "모두\t", actionStyle: .chevronMove, key: .chosenComposer, handlingProperty: .canPlay)]
                guard let librarySongs = dataModel.librarySongs else {
                    pd.rowDataArray = [RowData()]
                    return pd
                }
                
                var composerArray = musicHandler.getComposerArray(from: librarySongs)
                composerArray.sort(by: sortRule)
                
                for composer in composerArray {
                    pd.rowDataArray!.append(RowData(text: composer, actionStyle: .chevronMove, key: .chosenComposer, handlingProperty: .canPlay))
                }
                return pd
            case .chosenPlaylist: // shows songs
                let pd = PageData()
                pd.headerTitle = statusModel.chosenPlaylist?.name ?? "-"
                pd.pageBodyStyle = .list
                pd.rowDataArray = []
                
                guard let filteredSongs = dataModel.filteredSongs else {
                    pd.rowDataArray!.append(RowData())
                    return pd
                }
                
                guard filteredSongs.count > 0 else {
                    pd.rowDataArray!.append(RowData())
                    return pd
                }
                
                // filteredSongs is already sorted by track numbering of chosenPlaylist
                
                for song in filteredSongs {
                    pd.rowDataArray!.append(RowData(text: song.title, actionStyle: .emptyMove, key: .nowPlaying, handlingProperty: .play, song: song))
                }
                
                return pd
            case .chosenComposer: // shows albums
                let pd = PageData()
                pd.headerTitle = statusModel.chosenComposer ?? "모든 앨범"
                pd.pageBodyStyle = .list
                pd.rowDataArray = [RowData(text: "모두\t", actionStyle: .chevronMove, key: .chosenAlbum, handlingProperty: .canPlay)]
                
                guard let filteredSongs = dataModel.filteredSongs else {
                    pd.rowDataArray!.append(RowData())
                    return pd
                }
                
                var albumArray = musicHandler.getAlbumArray(from: filteredSongs)
                albumArray.sort(by: sortRule)
                
                if albumArray.count == 1 {
                    pd.rowDataArray = []
                }
                
                for album in albumArray {
                    pd.rowDataArray!.append(RowData(text: album, actionStyle: .chevronMove, key: .chosenAlbum, handlingProperty: .canPlay))
                }
                return pd
            case .chosenGenre: // shows artists
                let pd = PageData()
                pd.headerTitle = statusModel.chosenGenre ?? "모든 아티스트"
                pd.pageBodyStyle = .list
                pd.rowDataArray = [RowData(text: "모두\t", actionStyle: .chevronMove, key: .chosenArtist, handlingProperty: .canPlay)]
                guard let filteredSongs = dataModel.filteredSongs else {
                    pd.rowDataArray!.append(RowData())
                    return pd
                }
                
                var artistArray = musicHandler.getArtistArray(from: filteredSongs)
                artistArray.sort(by: sortRule)
                
                if artistArray.count == 1 {
                    pd.rowDataArray = []
                }
                
                for artist in artistArray {
                    pd.rowDataArray!.append(RowData(text: artist, actionStyle: .chevronMove, key: .chosenArtist, handlingProperty: .canPlay))
                }
                return pd
            case .chosenArtist: // shows albums
                let pd = PageData()
                pd.headerTitle = statusModel.chosenArtist ?? "모든 앨범"
                pd.pageBodyStyle = .list
                pd.rowDataArray = [RowData(text: "모두\t", actionStyle: .chevronMove, key: .chosenAlbum, handlingProperty: .canPlay)]
                
                guard let filteredSongs = dataModel.filteredSongs else {
                    pd.rowDataArray!.append(RowData())
                    return pd
                }
                
                var albumArray = musicHandler.getAlbumArray(from: filteredSongs)
                albumArray.sort(by: sortRule)
                
                if albumArray.count == 1 {
                    pd.rowDataArray = []
                }
                
                for album in albumArray {
                    pd.rowDataArray!.append(RowData(text: album, actionStyle: .chevronMove, key: .chosenAlbum, handlingProperty: .canPlay))
                }
                return pd
            case .chosenAlbum: // shows songs
                let pd = PageData()
                pd.headerTitle = statusModel.chosenAlbum ?? "모든 노래"
                pd.pageBodyStyle = .list
                pd.rowDataArray = []
                
                guard let filteredSongs = dataModel.filteredSongs else {
                    pd.rowDataArray!.append(RowData())
                    return pd
                }
                
                guard filteredSongs.count > 0 else {
                    pd.rowDataArray!.append(RowData())
                    return pd
                }
                
                let filteredSongsInDiscAndTrackOrder = filteredSongs.sorted(by: discAndTrackSortRule)
                
                for song in filteredSongsInDiscAndTrackOrder {
                    pd.rowDataArray!.append(RowData(text: song.title, actionStyle: .emptyMove, key: .nowPlaying, handlingProperty: .play, song: song))
                }
                
                return pd

            case .mainMenu:
                let pd = PageData()
                pd.headerTitle = "주 메뉴"
                pd.pageBodyStyle = .list
                pd.rowDataArray = [
                    RowData(text: "음악", actionStyle: .change, handlingProperty: .mainMenu),
                    RowData(text: "     재생목록", actionStyle: .change, handlingProperty: .mainMenu),
                    RowData(text: "     아티스트", actionStyle: .change, handlingProperty: .mainMenu),
                    RowData(text: "     앨범", actionStyle: .change, handlingProperty: .mainMenu),
                    RowData(text: "     노래", actionStyle: .change, handlingProperty: .mainMenu),
                    RowData(text: "     작곡가", actionStyle: .change, handlingProperty: .mainMenu),
                    RowData(text: "사진", actionStyle: .change, handlingProperty: .mainMenu),
                    RowData(text: "비디오", actionStyle: .change, handlingProperty: .mainMenu),
                    RowData(text: "노래 임의 재생", actionStyle: .change, handlingProperty: .mainMenu),
                    RowData(text: "주 메뉴 재설정", actionStyle: .chevronMove, key: .resetMainMenu)
                ]
                return pd
            case .resetMainMenu:
                let pd = PageData()
                pd.headerTitle = "메뉴"
                pd.pageBodyStyle = .list
                pd.rowDataArray = [
                    RowData(text: "취소", actionStyle: .changeBack, handlingProperty: .nothing),
                    RowData(text: "재설정", actionStyle: .changeBack, handlingProperty: .resetMainMenu),
                ]
                return pd
            case .about:
                let pd = PageData()
                pd.headerTitle = "정보"
                pd.pageBodyStyle = .text
                return pd
            default:
                return PageData()
        }
    }
}
