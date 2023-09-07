//
//  PageKey.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/28.
//

import MusicKit

enum PageKey {
    case empty
    case main
    
    //MARK: - pages in main (under basic menu settings)
    
    case music
    case photos // final
    case videos // final
    case settings
    case shuffleSongs // final
    case nowPlaying // final
    case nowPlayingVideo // final
    
    //MARK: - pages in music
    
    case playlists
    case artists
    case albums
    case songs
    case genres
    case composers
    case chosenPlaylist
    case chosenArtist
    case chosenAlbum
    case chosenGenre
    case chosenComposer
    
    //MARK: - pages in settings
    
    case about // final
    case mainMenu
    case resetMainMenu // final
}
