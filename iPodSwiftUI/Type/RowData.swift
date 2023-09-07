//
//  RowData.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/29.
//

import Foundation
import MusicKit

final class RowData {
    var text: String
    var actionStyle: RowActionStyle
    var key: PageKey?
    var handlingProperty: RowHandlingPropertyKey
    var playlist: Playlist?
    var song: Song?
    
    init(text: String = "-", actionStyle: RowActionStyle = .nothing, key: PageKey? = nil, handlingProperty: RowHandlingPropertyKey = .nothing, playlist: Playlist? = nil, song: Song? = nil) {
        self.text = text
        self.actionStyle = actionStyle
        self.key = key
        self.handlingProperty = handlingProperty
        self.playlist = playlist
        self.song = song
    }
}
