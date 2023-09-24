//
//  NowPlayingUpperView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/15.
//

import SwiftUI
import MusicKit

struct NowPlayingUpperView: View {
    
    var currentSongIndex: Int
    var lineupCount: Int
    var repeatState: RepeatState
    var shuffleIsActivated: Bool
    
    var currentSongArtwork: Artwork? // optional
    var currentArtworkUIImage_thumb: UIImage?
    
    var currentSongTitle: String
    var currentSongArtistName: String
    var currentSongAlbumTitle: String
    
    var upperTextFlicker: Bool
    var upperTextOffsetTrigger: Bool
    
    var needsAnimatedView: Bool
    
    @State private var naturalSize: CGSize = .zero {
        didSet {
            isTruncated = naturalSize != adjustedSize
        }
    }
    @State private var adjustedSize: CGSize = .zero {
        didSet {
            isTruncated = naturalSize != adjustedSize
        }
    }
    @State private var isTruncated = false
    
    init(currentSongIndex: Int, lineupCount: Int, repeatState: RepeatState, shuffleIsActivated: Bool, currentSongArtwork: Artwork? = nil, currentArtworkUIImage_thumb: UIImage? = nil, currentSongTitle: String, currentSongArtistName: String, currentSongAlbumTitle: String, upperTextFlicker: Bool, upperTextOffsetTrigger: Bool, needsAnimatedView: Bool) {
        self.currentSongIndex = currentSongIndex
        self.lineupCount = lineupCount
        self.repeatState = repeatState
        self.shuffleIsActivated = shuffleIsActivated
        self.currentSongArtwork = currentSongArtwork
        self.currentArtworkUIImage_thumb = currentArtworkUIImage_thumb
        self.currentSongTitle = currentSongTitle
        self.currentSongArtistName = currentSongArtistName
        self.currentSongAlbumTitle = currentSongAlbumTitle
        self.upperTextFlicker = upperTextFlicker
        self.upperTextOffsetTrigger = upperTextOffsetTrigger
        self.needsAnimatedView = needsAnimatedView
    }
    
    var body: some View {
        ZStack {
            // get adjustedSize; hidden
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.nowPlayingHorizontalIndentation)
                
                Text(currentSongTitle)
                    .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .readSize { size in
                        adjustedSize = size
                    }
                    .layoutPriority(-1)
                
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.nowPlayingHorizontalIndentation)
            }
            .frame(width: DesignSystem.Soft.Dimension.w)
            .hidden()
            
            // get naturalSize; hidden
            Group {
                if upperTextFlicker {
                    Text(currentSongTitle)
                        .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .readSize { size in
                            naturalSize = size
                        }
                }
            }
            .frame(width: DesignSystem.Soft.Dimension.w)
            .hidden()
            
            // visible
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.nowPlayingHorizontalIndentation)
                VStack(spacing: 0) {
                    // playlist indices, repeat, shuffle
                    HStack(spacing: 0) {
                        Text("\(currentSongIndex + 1) / \(lineupCount)")
                            .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                            .foregroundColor(.black)
                        Spacer()
                        Group {
                            if repeatState != .off {
                                Image(systemName: (repeatState == .one ? "repeat.1" : "repeat"))
                                    .resizable()
                                    .scaledToFit()
                                    .fontWeight(.heavy)
                                    .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.6076)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                                .frame(width: DesignSystem.Soft.Dimension.w / 90.91)
                            if shuffleIsActivated {
                                Image(systemName: "shuffle")
                                    .resizable()
                                    .scaledToFit()
                                    .fontWeight(.heavy)
                                    .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.6076)
                                    .foregroundColor(.black)
                            }
                        }
                        .offset(y: DesignSystem.Soft.Dimension.w * -0.0025)
                        .shadow(color: Color(red: 0.8, green: 0.8, blue: 0.8), radius: DesignSystem.Soft.Dimension.w * 0.0022, y: DesignSystem.Soft.Dimension.w * 0.0044)
                    }
                    
                    Spacer()
                        .frame(height: DesignSystem.Soft.Dimension.w * 0.75 / 25.84 * 0.7)
                    
                    // album image, song Title, artist name, album name
                    VStack(spacing: 0) {
                        if let uiimage = currentArtworkUIImage_thumb {
                            Image(uiImage: uiimage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: DesignSystem.Soft.Dimension.nowPlayingAlbumImageLength, height: DesignSystem.Soft.Dimension.nowPlayingAlbumImageLength)
                                .border(DesignSystem.Soft.Color.albumBorder, width: DesignSystem.Soft.Dimension.basicThinValue)
                            Spacer()
                                .frame(height: DesignSystem.Soft.Dimension.w * 0.75 / 25.84)
                        }
                        
                        Group {
                            if upperTextFlicker {
                                VStack(alignment: .center, spacing: 0) {
                                    // song title
                                    if isTruncated {
                                        if needsAnimatedView {
                                            HStack(spacing: 0) {
                                                Text(currentSongTitle)
                                                    .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                                                    .foregroundColor(.black)
                                                    .lineLimit(1)
                                                    .fixedSize(horizontal: true, vertical: false)
                                                
                                                Spacer()
                                                    .frame(width: DesignSystem.Soft.Dimension.rowTextSlidingIndentation)
                                                
                                                Text(currentSongTitle)
                                                    .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                                                    .foregroundColor(.black)
                                                    .lineLimit(1)
                                                    .fixedSize(horizontal: true, vertical: false)
                                            }
                                            .offset(x: naturalSize.width - adjustedSize.width * 0.5 + DesignSystem.Soft.Dimension.rowTextSlidingIndentation * 0.5)
                                            .offset(x: upperTextOffsetTrigger ? -naturalSize.width - DesignSystem.Soft.Dimension.rowTextSlidingIndentation : 0)
                                            .frame(width: adjustedSize.width)
                                            .clipped()
                                            .animation(.linear(duration: DesignSystem.Time.nowPlayingUpperTextSlidingAnimationTimePerWidth * (naturalSize.width + DesignSystem.Soft.Dimension.rowTextSlidingIndentation) / DesignSystem.Soft.Dimension.w ).delay(DesignSystem.Time.nowPlayingUpperTextRestTime).repeatForever(autoreverses: false), value: upperTextOffsetTrigger)
                                        }
                                        // if doesn't need animated view
                                        else {
                                            Text(currentSongTitle)
                                                .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                                                .foregroundColor(.black)
                                                .lineLimit(1)
                                        }
                                    }
                                    // if not truncated
                                    else {
                                        Text(currentSongTitle)
                                            .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                        .frame(height: DesignSystem.Soft.Dimension.w / 30.81)
                                    
                                    // artist name
                                    Text(currentSongArtistName)
                                        .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                        .frame(height: DesignSystem.Soft.Dimension.w / 30.81)
                                    
                                    // album title
                                    Text(currentSongAlbumTitle)
                                        .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                }
                            }
                            else {
                                Color(.red)
                                    .opacity(0.000001)
                            }
                        }
                        .frame(height: DesignSystem.Soft.Dimension.nowPlayingAlbumImageLength * 0.65)
                    }
                    .frame(height: DesignSystem.Soft.Dimension.w * 0.75 / 25.84 + DesignSystem.Soft.Dimension.nowPlayingAlbumImageLength * 1.65)
                }
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.nowPlayingHorizontalIndentation)
            }
        }
    }
}

struct NowPlayingUpperView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingUpperView(currentSongIndex: 0, lineupCount: 3, repeatState: .all, shuffleIsActivated: true, currentSongTitle: "야생화", currentSongArtistName: "박효신", currentSongAlbumTitle: "야생화", upperTextFlicker: true, upperTextOffsetTrigger: false, needsAnimatedView: true)
    }
}
