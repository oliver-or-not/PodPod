//
//  mainMenuIndexShaker.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/21.
//


// from setting list order to mainMenuBoolArray order
// not good for code maintenance
func mainMenuIndexShaker(_ n: Int) -> Int {
    switch n {
        case 0: // music
            return 0
        case 1: // playlists
            return 3
        case 2: // artists
            return 4
        case 3: // albums
            return 5
        case 4: // songs
            return 6
        case 5: // composers
            return 7
        case 6: // libraryRefresh
            return 8
        case 7: // photos
            return 1
        case 8: // videos
            return 2
        case 9: // shufflesongs
            return 10
        default:
            return 0
    }
}
