//
//  TextStyleBodyView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/31.
//

import SwiftUI

struct TextStyleBodyView: View {
    
    var title: String
    
    var basicFontSize: CGFloat {
        DesignSystem.Soft.Dimension.basicFontSize
    }
    
    var nowPlayingFontSize: CGFloat {
        DesignSystem.Soft.Dimension.nowPlayingFontSize
    }
    
    var basicIndentation: CGFloat {
        DesignSystem.Soft.Dimension.basicIndentation
    }
    
    private var playlistCount = DataModel.shared.playlists?.count ?? 0
    private var songCount = DataModel.shared.librarySongs?.count ?? 0
    private var photoCount = DataModel.shared.favoritePhotoArray.count
    private var videoCount = DataModel.shared.favoriteVideoArray.count
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        ZStack {
            Color(.white)
            VStack(spacing: DesignSystem.Soft.Dimension.rowHeight * 0.1) {
                Spacer()
                    .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.01)
                
                Text(title)
                    .font(.system(size: basicFontSize, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: DesignSystem.Soft.Dimension.w * 0.73)
                    .lineLimit(1)
                
                Group {
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: basicIndentation)
                        Text("재생목록")
                            .font(.system(size: basicFontSize, weight: .semibold))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(playlistCount)")
                            .font(.system(size: basicFontSize, weight: .semibold))
                            .foregroundColor(.black)
                            .lineLimit(1)
                        Spacer()
                            .frame(width: basicIndentation)
                    }
                    
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: basicIndentation)
                        Text("노래")
                            .font(.system(size: basicFontSize, weight: .semibold))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(songCount)")
                            .font(.system(size: basicFontSize, weight: .semibold))
                            .foregroundColor(.black)
                            .lineLimit(1)
                        Spacer()
                            .frame(width: basicIndentation)
                    }
                    
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: basicIndentation)
                        Text("사진")
                            .font(.system(size: basicFontSize, weight: .semibold))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(photoCount)")
                            .font(.system(size: basicFontSize, weight: .semibold))
                            .foregroundColor(.black)
                            .lineLimit(1)
                        Spacer()
                            .frame(width: basicIndentation)
                    }
                    
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: basicIndentation)
                        Text("비디오")
                            .font(.system(size: basicFontSize, weight: .semibold))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(videoCount)")
                            .font(.system(size: basicFontSize, weight: .semibold))
                            .foregroundColor(.black)
                            .lineLimit(1)
                        Spacer()
                            .frame(width: basicIndentation)
                    }
                }
                
                Spacer().frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.2)
                
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: basicIndentation)
                    
                    Text("Apple Music 보관함의\n재생목록과 노래를 받아옵니다.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: nowPlayingFontSize, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                        .frame(width: basicIndentation)
                }
                
                Spacer().frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.01)
                
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: basicIndentation)
                    
                    Text("사진 앱의 즐겨찾는 항목을 받아옵니다.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: nowPlayingFontSize, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                        .frame(width: basicIndentation)
                }
                
                Spacer()
            }
        }
        .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
    }
}

//struct TextStyleBodyView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextStyleBodyView()
//    }
//}
