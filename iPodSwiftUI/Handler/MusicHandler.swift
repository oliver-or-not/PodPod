//
//  MusicHandler.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/05.
//

import MusicKit

final class MusicHandler {

    static let shared = MusicHandler()

    private init() {}

    let musicPlayer = ApplicationMusicPlayer.shared

    var isPlayable = true
    var virtuallyStopped = true

    private var userSubscriptionSequence = MusicSubscription.subscriptionUpdates.map { $0.canPlayCatalogContent }

    private var firstSongIndex = 0
    private var earlierHalfFilteredSongs: [Song] = []
    private var laterHalfFilteredSongs: [Song] = []

    private func reset(_ songs: inout MusicItemCollection<Song>?) {
        songs = []
    }
    private func reset(_ playlists: inout MusicItemCollection<Playlist>?) {
        playlists = []
    }

    //MARK: - check subscription

    func getUserSubscriptionAvailability(completion: @escaping @MainActor (Bool) -> Void) {
        Task {
            do {
                var boolValues: [Bool] = []
                for try await boolValue in userSubscriptionSequence {
                    boolValues.append(boolValue)
                    break
                }
                if boolValues.count > 0 {
                    await completion(boolValues[0])
                } else {
                    await completion(false)
                }
            }
        }
    }

    //MARK: - request update

    func requestUpdateSearchResults(for searchTerm: String) {
        Task {
            do {
                var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
                searchRequest.limit = 10
                let searchResponse = try await searchRequest.response()
                DataModel.shared.searchSongs = searchResponse.songs
            } catch {
                self.reset(&DataModel.shared.searchSongs)
            }
        }
    }
    func requestUpdateLibrary(completion: @escaping () -> Void) {
        Task {
            do {
                var libraryRequest = MusicLibraryRequest<Song>()
                libraryRequest.limit = 100000
                let response = try await libraryRequest.response()
                DataModel.shared.librarySongs = MusicItemCollection<Song>(response.items.sorted {
                    return sortRule($0.title, $1.title)
                })
                completion()
            } catch {
                self.reset(&DataModel.shared.librarySongs)
                completion()
            }
        }
    }
    func requestUpdatePlaylists(completion: @escaping () -> Void) {
        Task {
            do {
                var playlistRequest = MusicLibraryRequest<Playlist>()
                playlistRequest.limit = 10000
                let response = try await playlistRequest.response()
                var tempPlaylists: [Playlist] = []
                for i in 0..<response.items.count {
                    await tempPlaylists.append(try response.items[i].with([.tracks, .entries]))
                }
                tempPlaylists.sort {
                    return sortRule($0.name, $1.name)
                }
                DataModel.shared.playlists = MusicItemCollection<Playlist>(tempPlaylists)
                completion()
            } catch {
                self.reset(&DataModel.shared.playlists)
                completion()
            }
        }
    }
    func playFilteredSongs(startingAt firstSong: Song? = nil, isShuffled: Bool, completion: @escaping () -> Void ) {
        guard let filteredSongs = DataModel.shared.filteredSongs else {
            isPlayable = false
            return
        }

        guard filteredSongs.count > 0 else {
            isPlayable = false
            return
        }

        VideoHandler.shared.clearPlayer()
        virtuallyStopped = false
        
        if let firstSong {
            // not shuffled and the first song is given
            firstSongIndex = 0
            for i in 0..<filteredSongs.count {
                if firstSong.id == filteredSongs[i].id {
                    firstSongIndex = i
                }
            }
            musicPlayer.queue = ApplicationMusicPlayer.Queue.init(for: filteredSongs, startingAt: filteredSongs[firstSongIndex])
        }
        // the first song is not given
        else {
            musicPlayer.queue = ApplicationMusicPlayer.Queue.init(for: filteredSongs)
        }

        if isShuffled {
            musicPlayer.state.shuffleMode = .songs
        } else {
            musicPlayer.state.shuffleMode = .off
        }

        Task {
            isPlayable = true
            do {
                try await self.musicPlayer.prepareToPlay()
            } catch {
                isPlayable = false
                print("MusicHandler | playFilteredSongs() | error preparing to play music: \(error.localizedDescription)")
            }
            do {
                if isPlayable {
                    do {
                        try await self.musicPlayer.play()
                        completion()
                    }
                    catch {
                        print("MusicHandler | playFilteredSongs() | error playing music: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    //MARK: - filter

    func doPlaylistFilter(chosenPlaylist: Playlist?) {
        if let chosenPlaylist {
            if let entries = chosenPlaylist.entries {
                var tempSongArray: [Song] = []
                for entry in entries {
                    if let item = entry.item {
                        if case let .song(song) = item {
                            tempSongArray.append(song)
                        }
                    }
                }
                DataModel.shared.filteredSongs = MusicItemCollection<Song>(tempSongArray)
            }
        }
    }
    func doComposerFilter(chosenComposer: String?) {
        if let chosenComposer, let filteredSongs = DataModel.shared.filteredSongs {
            DataModel.shared.filteredSongs = MusicItemCollection<Song>(filteredSongs.filter({ song in
                guard let songComposerName = song.composerName else {
                    return false
                }
                if songComposerName == chosenComposer {
                    return true
                } else {
                    return false
                }
            }))
        }
    }
    func doGenreFilter(chosenGenre: String?) {
        if let chosenGenre, let filteredSongs = DataModel.shared.filteredSongs {
            DataModel.shared.filteredSongs = MusicItemCollection<Song>(filteredSongs.filter({ song in
                for genreName in song.genreNames {
                    if genreName == chosenGenre {
                        return true
                    }
                }
                return false
            }))
        }
    }
    func doArtistFilter(chosenArtist: String?) {
        if let chosenArtist, let filteredSongs = DataModel.shared.filteredSongs {
            DataModel.shared.filteredSongs = MusicItemCollection<Song>(filteredSongs.filter({ song in
                    if song.artistName == chosenArtist {
                        return true
                    } else {
                        return false
                    }
            }))
        }
    }
    func doAlbumFilter(chosenAlbum: String?) {
        if let chosenAlbum, let filteredSongs = DataModel.shared.filteredSongs {
            DataModel.shared.filteredSongs = MusicItemCollection<Song>(filteredSongs.filter({ song in
                guard let songAlbumTitle = song.albumTitle else {
                    return false
                }
                if songAlbumTitle == chosenAlbum {
                        return true
                } else {
                    return false
                }
            }))
        }
    }
    func refreshFilteredSongs(chosenPlaylist: Playlist?, chosenComposer: String?, chosenGenre: String?, chosenArtist: String?, chosenAlbum: String?) {
        DataModel.shared.filteredSongs = DataModel.shared.librarySongs
        doPlaylistFilter(chosenPlaylist: chosenPlaylist)
        doComposerFilter(chosenComposer: chosenComposer)
        doGenreFilter(chosenGenre: chosenGenre)
        doArtistFilter(chosenArtist: chosenArtist)
        doAlbumFilter(chosenAlbum: chosenAlbum)
    }

    //MARK: - get (...) array from songs

    func getComposerArray(from songs: MusicItemCollection<Song>) -> [String] {
        var composerArray: [String] = []
        for song in songs {
            if let songComposerName = song.composerName {
                    if !composerArray.contains(songComposerName) && songComposerName != "" {
                        composerArray.append(songComposerName)
                    }
            }
        }
        return composerArray
    }
    func getGenreArray(from songs: MusicItemCollection<Song>) -> [String] {
        var genreArray: [String] = []
        for song in songs {
            for genre in song.genreNames {
                if !genreArray.contains(genre) && genre != "" {
                    genreArray.append(genre)
                }
            }
        }
        return genreArray
    }
    func getArtistArray(from songs: MusicItemCollection<Song>) -> [String] {
        var artistArray: [String] = []
        for song in songs {
            let songArtistName = song.artistName
            if !artistArray.contains(songArtistName) && songArtistName != "" {
                artistArray.append(songArtistName)
            }
        }
        return artistArray
    }
    func getAlbumArray(from songs: MusicItemCollection<Song>) -> [String] {
        var albumArray: [String] = []
        for song in songs {
            if let songAlbumTitle = song.albumTitle {
                if !albumArray.contains(songAlbumTitle) && songAlbumTitle != "" {
                    albumArray.append(songAlbumTitle)
                }
            }
        }
        return albumArray
    }
}
