//
//  DataModel.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/09/02.
//

import SwiftUI
import MusicKit
import Photos

class DataModel {
    
    static let shared = DataModel()
    
    private init() {
    }
    
    //MARK: - music data
    
    var librarySongs: MusicItemCollection<Song>? {
        // do refresh librarySongs only in page where filtering is not activated
        didSet {
            filteredSongs = librarySongs
        }
    }
    var filteredSongs: MusicItemCollection<Song>?
    var searchSongs: MusicItemCollection<Song>?
    var playlists: MusicItemCollection<Playlist>?
    
    //MARK: - photo data
    
    var favoritePhotoArray: [UIImage] = []
    
    //MARK: - video data
    
    var favoriteVideoThumbnailArray: [UIImage] = []
    var favoriteVideoArray: [PHAsset] = []
    var favoriteVideoRatioArray: [Float] = []
}
