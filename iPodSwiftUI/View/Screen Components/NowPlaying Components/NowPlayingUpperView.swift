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
                Group {
                    // album image, song Title, artist name, album name
                    if currentArtworkUIImage_thumb != nil {
                        HStack(spacing: 0) {
                            Image(systemName: "music.note")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(DesignSystem.Soft.Color.albumPlaceholderNote)
                                .padding(DesignSystem.Soft.Dimension.nowPlayingAlbumImageLength / 4)
                                .frame(width: DesignSystem.Soft.Dimension.nowPlayingAlbumImageLength, height: DesignSystem.Soft.Dimension.nowPlayingAlbumImageLength)
                                .clipped()
                                .background(DesignSystem.Soft.Color.albumPlaceholderBackground)
                            
                            Spacer()
                                .frame(width: DesignSystem.Soft.Dimension.w / 23.88)
                            Group {
                                if upperTextFlicker {
                                    VStack(alignment: .leading, spacing: 0) {
                                        // song title
                                        Text(currentSongTitle)
                                            .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                            .readSize { size in
                                                adjustedSize = size
                                            }
                                            .layoutPriority(-1)
                                        
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
                                    Spacer()
                                        .frame(minWidth: 0)
                                        .layoutPriority(-2)
                                }
                            }
                        }
                    }
                    // artwork uiimage is nil
                    else {
                        Group {
                            if upperTextFlicker {
                                VStack(alignment: .center, spacing: 0) {
                                    // song title
                                    Text(currentSongTitle)
                                        .font(.system(size: DesignSystem.Soft.Dimension.nowPlayingFontSize, weight: .semibold))
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                        .readSize { size in
                                            adjustedSize = size
                                        }
                                        .layoutPriority(-1)
                                    
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
                        }
                        .frame(height: DesignSystem.Soft.Dimension.nowPlayingAlbumImageLength)
                    }
                }
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
                        .frame(height: DesignSystem.Soft.Dimension.h / 25.84)
                    
                    // album image, song Title, artist name, album name
                    if let uiimage = currentArtworkUIImage_thumb {
                        HStack(spacing: 0) {
                            Image(uiImage: uiimage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: DesignSystem.Soft.Dimension.nowPlayingAlbumImageLength, height: DesignSystem.Soft.Dimension.nowPlayingAlbumImageLength)
                                .clipped()
                                .border(DesignSystem.Soft.Color.albumBorder, width: DesignSystem.Soft.Dimension.basicThinValue)
                            
                            Spacer()
                                .frame(width: DesignSystem.Soft.Dimension.w / 23.88)
                            Group {
                                if upperTextFlicker {
                                    VStack(alignment: .leading, spacing: 0) {
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
                                    Spacer()
                                        .frame(minWidth: 0)
                                        .layoutPriority(-1)
                                }
                                else {
                                    Spacer()
                                }
                            }
                        }
                    }
                    else {
                        HStack(spacing: 0) {
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
                            }
                        }
                        .frame(height: DesignSystem.Soft.Dimension.nowPlayingAlbumImageLength)
                    }
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
