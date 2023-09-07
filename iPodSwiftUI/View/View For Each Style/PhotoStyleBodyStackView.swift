//
//  PhotoStyleBodyStackView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/25.
//

import SwiftUI

struct PhotoStyleBodyStackView: View {
    
    var focusedIndex: Int = 0
    var discreteScrollMark: Int = 0
    
    var detailIsShown: Bool = false
    
    private var vStackIndexArray: [Int] {
        var temp = [Int]()
        for i in 0..<vNum {
            temp.append(discreteScrollMark + i * hNum)
        }
        return temp
    }
    
    private var hStackIndexArray: [Int] {
        var temp = [Int]()
        for i in 0..<hNum {
            temp.append(i)
        }
        return temp
    }
    
    private var favoritePhotoArray: [UIImage] = DataModel.shared.favoritePhotoArray
    
    private var photoCount: Int {
        favoritePhotoArray.count
    }
    
    private var hNum: Int {
        DesignSystem.Soft.Dimension.photoHorizontalNum
    }
    
    private var vNum: Int {
        DesignSystem.Soft.Dimension.photoVerticalNum
    }
    
    private var thinValue: CGFloat {
        DesignSystem.Soft.Dimension.basicThinValue
    }
    
    private var photoWidth: CGFloat {
        if photoCount > hNum * vNum {
            return (DesignSystem.Soft.Dimension.w - DesignSystem.Soft.Dimension.scrollBarWidth - CGFloat(hNum - 1 + 4) * thinValue) / CGFloat(hNum)
        }
        else {
            return (DesignSystem.Soft.Dimension.w - CGFloat(hNum - 1 + 4) * thinValue) / CGFloat(hNum)
        }
    }
    
    private var photoHeight: CGFloat {
        return (DesignSystem.Soft.Dimension.bodyHeight - CGFloat(vNum - 1 + 8) * thinValue) / CGFloat(vNum)
    }
    
    var nowPlayingFontSize: CGFloat {
        DesignSystem.Soft.Dimension.nowPlayingFontSize
    }
    
    var basicIndentation: CGFloat {
        DesignSystem.Soft.Dimension.basicIndentation
    }
    
    init(focusedIndex: Int = 0, discreteScrollMark: Int = 0, detailIsShown: Bool = false) {
        self.focusedIndex = focusedIndex
        self.discreteScrollMark = discreteScrollMark
        self.detailIsShown = detailIsShown
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            // photos
            Group {
                if photoCount == 0 {
                    ZStack {
                        Color(.white)
                        
                        HStack(spacing: 0) {
                            Spacer()
                                .frame(width: basicIndentation)
                            
                            Text("표시할 사진이 없습니다.\n사진 앱에서 추가할 사진을 선택하고\n즐겨찾기 버튼(♡)을 누르세요.")
                                .multilineTextAlignment(.center)
                                .font(.system(size: nowPlayingFontSize, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                                .frame(width: basicIndentation)
                        }
                    }
                }
                // photoCount > 0
                else {
                    HStack (spacing: 0) {
                        VStack (spacing: DesignSystem.Soft.Dimension.basicThinValue) {
                            Spacer().frame(minWidth: 0.0, maxWidth: DesignSystem.Soft.Dimension.basicThinValue * 4)
                            ForEach(vStackIndexArray, id: \.self) { i in
                                HStack (spacing: thinValue) {
                                    Spacer().frame(minWidth: 0.0)
                                    ForEach(hStackIndexArray, id: \.self) { j in
                                        if i+j < photoCount {
                                            Image(uiImage: favoritePhotoArray[i+j])
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: photoWidth, height: photoHeight)
                                                .clipped()
                                                .border(DesignSystem.Soft.Color.photoBorder, width: focusedIndex == i + j ? DesignSystem.Soft.Dimension.photoBorderWidth : 0.0)
                                        } else {
                                            Color(.white)
                                                .frame(width: photoWidth, height: photoHeight)
                                        }
                                    }
                                    Spacer().frame(minWidth: 0.0)
                                }
                            }
                            Spacer().frame(minWidth: 0.0)
                        }
                        
                        if photoCount > hNum * vNum {
                            DiscreteScrollBarView(focusedIndex: focusedIndex / hNum, discreteScrollMark: discreteScrollMark / hNum, rowCount: photoCount / hNum + (photoCount.isMultiple(of: hNum) ? 0 : 1), range: vNum)
                        }
                    }
                }
            }
            .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
            
            // photo detail
            ZStack {
                Color(.black)
                if focusedIndex < favoritePhotoArray.count {
                    Image(uiImage: favoritePhotoArray[focusedIndex])
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.h)
        }
        .offset(y: -DesignSystem.Soft.Dimension.rowHeight * 0.5)
        .offset(x: detailIsShown ? -DesignSystem.Soft.Dimension.w * 0.5 : DesignSystem.Soft.Dimension.w * 0.5)
        .animation(.linear(duration: DesignSystem.Time.slidingAnimationTime).delay(DesignSystem.Time.lagTime), value: detailIsShown)
    }
}

struct PhotoStyleBodyStackView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoStyleBodyStackView()
    }
}
