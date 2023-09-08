//
//  StatusModel.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/09/02.
//

import MusicKit

class StatusModel {
    static let shared = StatusModel()
    
    private init() {}
    
    //MARK: - singleton object
    
    // contains songs and photos
    let dataModel = DataModel.shared
    // handles music data
    let musicHandler = MusicHandler.shared
    
    //MARK: - constants
    
    static let maxPageCount = 10
    static let initialValueOfMainMenuBoolArray = [true, true, true, false, false, false, false, false, true, true]
    // 0...2: music, photos, videos
    // 3...7: playlists, artists, albums, songs, composers
    // 8: settings
    // 9: shufflesongs
    static let initialIndexOfSettings = 4
    
    //MARK: - iPod currentstate, NO need to be subscribed
    
    var pageSKDictionary: [PageKey: PageSK] = [:]
    // index of pageKeyArray represents the order of view sequence
    var pageKeyArray: [PageKey] = []
    var playingVideoIndex: Int?
    
    var chosenPlaylist: Playlist? {
        didSet(prev) {
            if prev == nil {
                musicHandler.doPlaylistFilter(chosenPlaylist: chosenPlaylist)
            }
            else if prev != nil && self.chosenPlaylist == nil && dataModel.filteredSongs != nil {
                prevChosenPlaylist = prev
                musicHandler.refreshFilteredSongs(chosenPlaylist: chosenPlaylist, chosenComposer: chosenComposer, chosenGenre: chosenGenre, chosenArtist: chosenArtist, chosenAlbum: chosenAlbum)
            }
        }
    }
    var chosenComposer: String? {
        didSet(prev) {
            if prev == nil {
                musicHandler.doComposerFilter(chosenComposer: chosenComposer)
            }
            else if prev != nil && self.chosenComposer == nil && dataModel.filteredSongs != nil {
                prevChosenComposer = prev
                musicHandler.refreshFilteredSongs(chosenPlaylist: chosenPlaylist, chosenComposer: chosenComposer, chosenGenre: chosenGenre, chosenArtist: chosenArtist, chosenAlbum: chosenAlbum)
            }
        }
    }
    var chosenGenre: String? {
        didSet(prev) {
            if prev == nil {
                musicHandler.doGenreFilter(chosenGenre: chosenGenre)
            }
            
            else if prev != nil && self.chosenGenre == nil && dataModel.filteredSongs != nil {
                prevChosenGenre = prev
                musicHandler.refreshFilteredSongs(chosenPlaylist: chosenPlaylist, chosenComposer: chosenComposer, chosenGenre: chosenGenre, chosenArtist: chosenArtist, chosenAlbum: chosenAlbum)
            }
        }
    }
    var chosenArtist: String? {
        didSet(prev) {
            if prev == nil {
                musicHandler.doArtistFilter(chosenArtist: chosenArtist)
            }
            else if prev != nil && self.chosenArtist == nil && dataModel.filteredSongs != nil {
                prevChosenArtist = prev
                musicHandler.refreshFilteredSongs(chosenPlaylist: chosenPlaylist, chosenComposer: chosenComposer, chosenGenre: chosenGenre, chosenArtist: chosenArtist, chosenAlbum: chosenAlbum)
            }
        }
    }
    var chosenAlbum: String? {
        didSet(prev) {
            if prev == nil {
                musicHandler.doAlbumFilter(chosenAlbum: chosenAlbum)
            }
            
            else if prev != nil && self.chosenGenre == nil && dataModel.filteredSongs != nil {
                prevChosenAlbum = prev
                musicHandler.refreshFilteredSongs(chosenPlaylist: chosenPlaylist, chosenComposer: chosenComposer, chosenGenre: chosenGenre, chosenArtist: chosenArtist, chosenAlbum: chosenAlbum)
            }
        }
    }
    
    // need these values to decide whether the focusedIndex of visited page should be restored or not
    var prevChosenPlaylist: Playlist?
    var prevChosenComposer: String?
    var prevChosenGenre: String?
    var prevChosenArtist: String?
    var prevChosenAlbum: String?
}
