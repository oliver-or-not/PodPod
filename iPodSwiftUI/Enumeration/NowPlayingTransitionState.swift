//
//  NowPlayingTransitionState.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/14.
//

import Foundation

enum NowPlayingTransitionState {
    case stable
    
    case stableToVolume
    case volume
    case volumeToStable
    
    case stableToSeek
    case seek
    case seekToStable
    case seekToFullArtwork
    
    case fullArtwork
    case fullArtworkToStable
}
