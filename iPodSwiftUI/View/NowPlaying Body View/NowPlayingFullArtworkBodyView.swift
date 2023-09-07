//
//  NowPlayingFullArtworkBodyView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/15.
//

import SwiftUI
import MusicKit

struct NowPlayingFullArtworkBodyView: View {
    
    var currentSongArtwork: Artwork?
    var currentArtworkUIImage_full: UIImage?
    
    var body: some View {
        ZStack {
            Color(.white)
            
            Group {
                if let uiImage = currentArtworkUIImage_full {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .border(DesignSystem.Soft.Color.albumBorder, width: DesignSystem.Soft.Dimension.basicThinValue)
                        .frame(maxWidth: DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength, maxHeight: DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength)
                } else {
                    Image(systemName: "music.note")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(DesignSystem.Soft.Color.albumPlaceholderNote)
                        .padding(DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength / 4)
                        .frame(width: DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength, height: DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength)
                        .background(DesignSystem.Soft.Color.albumPlaceholderBackground)
                }
//                if let safeURL = currentSongArtwork?.url(width: 640, height: 640) {
//                    AsyncImage(url: safeURL) { image in
//                        image
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength, height: DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength)
//                            .border(DesignSystem.Soft.Color.albumBorder, width: DesignSystem.Soft.Dimension.basicThinValue)
//                    } placeholder: {
//                        Image(systemName: "music.note")
//                            .resizable()
//                            .scaledToFit()
//                            .foregroundColor(DesignSystem.Soft.Color.albumPlaceholderNote)
//                            .padding(DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength / 4)
//                            .frame(width: DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength, height: DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength)
//                            .background(DesignSystem.Soft.Color.albumPlaceholderBackground)
//                    }
//                }
//                else {
//                    Image(systemName: "music.note")
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundColor(DesignSystem.Soft.Color.albumPlaceholderNote)
//                        .padding(DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength / 4)
//                        .frame(width: DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength, height: DesignSystem.Soft.Dimension.fullArtworkAlbumImageLength)
//                        .background(DesignSystem.Soft.Color.albumPlaceholderBackground)
//                }
            }
        }
        .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
    }
}
struct NowPlayingFullArtworkBodyView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingFullArtworkBodyView(currentSongArtwork: nil)
    }
}
