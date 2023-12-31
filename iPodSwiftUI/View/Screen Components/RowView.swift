//
//  RowView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/23.
//

import SwiftUI
import MusicKit

struct RowView: View {
    var rowData: RowData
    
    var indexInList: Int
    
    var isFocused: Bool
    
    var wantsToSeeTimeInHeader: Bool
    
    var repeatState: RepeatState
    var alwaysShuffle: Bool
    
    var vibeIsActivated: Bool
    var videoZoomMode: VideoZoomMode
    var videoAutoplayMode: VideoAutoplayMode
    var libraryUpdateSymbolState: LibraryUpdateSymbolState
    var mainMenuBoolArray: [Bool]
    
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
    
    @State private var slideTrigger = false
    
    var body: some View {
        ZStack {
            // get adjustedSize; hidden
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.basicIndentation)
                
                Text(rowData.text)
                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .readSize { size in
                        adjustedSize = size
                    }
                

                Spacer()
                
                switch rowData.actionStyle {
                    case .chevronMove:
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.heavy)
                            .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.4)
                            .foregroundColor(isFocused ? .white : .black)
                    case .emptyMove:
                        EmptyView()
                    case .change:
                        switch rowData.handlingProperty {
                            case .songRepeat:
                                switch repeatState {
                                    case .all:
                                        Text("모두")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                    case .off:
                                        Text("끔")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                    case .one:
                                        Text("한곡")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                }
                            case .songShuffle:
                                if alwaysShuffle {
                                    Text("켬")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                } else {
                                    Text("끔")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                }
                            case .clickVibe:
                                if vibeIsActivated {
                                    Text("켬")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                } else {
                                    Text("끔")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                }
                            case .videoZoom:
                                switch videoZoomMode {
                                    case .fit:
                                        Text("전부 보이기")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                    case .zoom:
                                        Text("확대")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                }
                            case .videoAutoplay:
                                switch videoAutoplayMode {
                                    case .off:
                                        Text("끔")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                    case .one:
                                        Text("같은 비디오")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                    case .all:
                                        Text("다음 비디오")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                }
                            case .mainMenu:
                                if mainMenuBoolArray[mainMenuIndexShaker(indexInList)] {
                                    Text("켬")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                } else {
                                    Text("끔")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                }
                            case .mediaRefresh:
                                switch libraryUpdateSymbolState {
                                    case .notShown:
                                        EmptyView()
                                    case .loading:
                                        DotsProgressView(brightBack: !isFocused)
                                            .frame(width: DesignSystem.Soft.Dimension.rowHeight * 0.5, height: DesignSystem.Soft.Dimension.rowHeight * 0.5)
                                    case .done:
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .scaledToFit()
                                            .fontWeight(.heavy)
                                            .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.4)
                                            .foregroundColor(isFocused ? .white : .black)
                                    case .error:
                                        Image(systemName: "questionmark")
                                            .resizable()
                                            .scaledToFit()
                                            .fontWeight(.heavy)
                                            .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.47)
                                            .foregroundColor(isFocused ? .white : .black)
                                }
                            case .timeInHeader:
                                if wantsToSeeTimeInHeader {
                                    Text("켬")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                } else {
                                    Text("끔")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                }
                            default:
                                EmptyView()
                        }
                    case .link:
                        Image(systemName: "chevron.right.2")
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.heavy)
                            .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.4)
                            .foregroundColor(isFocused ? .white : .black)
                    default:
                        EmptyView()
                }
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.basicIndentation)
            }
            .frame(minWidth: DesignSystem.Soft.Dimension.w - DesignSystem.Soft.Dimension.scrollBarWidth, maxWidth: DesignSystem.Soft.Dimension.w)
            .hidden()
            
            // get naturalSize; hidden
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.basicIndentation)

                Text(rowData.text)
                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .readSize { size in
                        naturalSize = size
                    }

                Spacer()
                
                switch rowData.actionStyle {
                    case .chevronMove:
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.heavy)
                            .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.4)
                            .foregroundColor(isFocused ? .white : .black)
                    case .emptyMove:
                        EmptyView()
                    case .change:
                        switch rowData.handlingProperty {
                            case .songRepeat:
                                switch repeatState {
                                    case .all:
                                        Text("모두")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                    case .off:
                                        Text("끔")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                    case .one:
                                        Text("한곡")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                }
                            case .songShuffle:
                                if alwaysShuffle {
                                    Text("켬")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                } else {
                                    Text("끔")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                }
                            case .clickVibe:
                                if vibeIsActivated {
                                    Text("켬")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                } else {
                                    Text("끔")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                }
                            case .videoZoom:
                                switch videoZoomMode {
                                    case .fit:
                                        Text("전부 보이기")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                    case .zoom:
                                        Text("확대")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                }
                            case .videoAutoplay:
                                switch videoAutoplayMode {
                                    case .off:
                                        Text("끔")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                    case .one:
                                        Text("같은 비디오")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                    case .all:
                                        Text("다음 비디오")
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(isFocused ? .white : .black)
                                            .lineLimit(1)
                                }
                            case .mainMenu:
                                if mainMenuBoolArray[mainMenuIndexShaker(indexInList)] {
                                    Text("켬")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                } else {
                                    Text("끔")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                }
                            case .mediaRefresh:
                                switch libraryUpdateSymbolState {
                                    case .notShown:
                                        EmptyView()
                                    case .loading:
                                        DotsProgressView(brightBack: !isFocused)
                                            .frame(width: DesignSystem.Soft.Dimension.rowHeight * 0.5, height: DesignSystem.Soft.Dimension.rowHeight * 0.5)
                                    case .done:
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .scaledToFit()
                                            .fontWeight(.heavy)
                                            .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.4)
                                            .foregroundColor(isFocused ? .white : .black)
                                    case .error:
                                        Image(systemName: "questionmark")
                                            .resizable()
                                            .scaledToFit()
                                            .fontWeight(.heavy)
                                            .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.47)
                                            .foregroundColor(isFocused ? .white : .black)
                                }
                            case .timeInHeader:
                                if wantsToSeeTimeInHeader {
                                    Text("켬")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                } else {
                                    Text("끔")
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(isFocused ? .white : .black)
                                        .lineLimit(1)
                                }
                            default:
                                EmptyView()
                        }
                    case .link:
                        Image(systemName: "chevron.right.2")
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.heavy)
                            .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.4)
                            .foregroundColor(isFocused ? .white : .black)
                    default:
                        EmptyView()
                }
                Spacer()
                    .frame(width: DesignSystem.Soft.Dimension.basicIndentation)
            }
            .frame(minWidth: DesignSystem.Soft.Dimension.w - DesignSystem.Soft.Dimension.scrollBarWidth, maxWidth: DesignSystem.Soft.Dimension.w)
            .hidden()
            
                ZStack {
                    // blue background for focused row
                    VStack(spacing: 0) {
                        DesignSystem.Soft.Color.focusedRowTopLine
                            .frame(height: DesignSystem.Soft.Dimension.basicThinValue)
                        LinearGradient(gradient: Gradient(colors: [DesignSystem.Soft.Color.focusedRowTop, DesignSystem.Soft.Color.focusedRowBottom]), startPoint: .top, endPoint: .bottom)
                    }
                    .opacity(isFocused ? 1.0 : 0.000001)
                    
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: DesignSystem.Soft.Dimension.basicIndentation)
                        
                        if !isFocused {
                            Text(rowData.text)
                                .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                .foregroundColor(.black)
                                .lineLimit(1)
                        }
                        // isFocused
                        else {
                            if isTruncated {
                                if needsAnimatedView {
                                    HStack(spacing: 0) {
                                        Text(rowData.text)
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(.white)
                                            .fixedSize(horizontal: true, vertical: false)
                                            .lineLimit(1)
                                        
                                        Spacer()
                                            .frame(width: DesignSystem.Soft.Dimension.rowTextSlidingIndentation)
                                        
                                        Text(rowData.text)
                                            .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                            .foregroundColor(.white)
                                            .fixedSize(horizontal: true, vertical: false)
                                            .lineLimit(1)
                                    }
                                    .offset(x: naturalSize.width - adjustedSize.width * 0.5 + DesignSystem.Soft.Dimension.rowTextSlidingIndentation * 0.5)
                                    .offset(x: slideTrigger ? -naturalSize.width - DesignSystem.Soft.Dimension.rowTextSlidingIndentation : 0)
                                    .frame(width: adjustedSize.width)
                                    .clipped()
                                    .animation(.linear(duration: DesignSystem.Time.rowTextSlidingAnimationTimePerWidth * (naturalSize.width + DesignSystem.Soft.Dimension.rowTextSlidingIndentation) / DesignSystem.Soft.Dimension.w).delay(DesignSystem.Time.rowTextRestTime).repeatForever(autoreverses: false), value: slideTrigger)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Time.rowTextLagTime) {
                                            slideTrigger = true
                                        }
                                    }
                                    .onDisappear {
                                        slideTrigger = false
                                    }
                                }
                                // if doesn't need animated view
                                else {
                                    Text(rowData.text)
                                        .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                }
                            }
                            // if not truncated
                            else {
                                Text(rowData.text)
                                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
                        }
                        
                        
                        Spacer()
                        
                        switch rowData.actionStyle {
                            case .chevronMove:
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .fontWeight(.heavy)
                                    .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.4)
                                    .foregroundColor(isFocused ? .white : .black)
                            case .emptyMove:
                                EmptyView()
                            case .change:
                                switch rowData.handlingProperty {
                                    case .songRepeat:
                                        switch repeatState {
                                            case .all:
                                                Text("모두")
                                                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                    .foregroundColor(isFocused ? .white : .black)
                                                    .lineLimit(1)
                                            case .off:
                                                Text("끔")
                                                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                    .foregroundColor(isFocused ? .white : .black)
                                                    .lineLimit(1)
                                            case .one:
                                                Text("한곡")
                                                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                    .foregroundColor(isFocused ? .white : .black)
                                                    .lineLimit(1)
                                        }
                                    case .songShuffle:
                                        if alwaysShuffle {
                                            Text("켬")
                                                .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                .foregroundColor(isFocused ? .white : .black)
                                                .lineLimit(1)
                                        } else {
                                            Text("끔")
                                                .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                .foregroundColor(isFocused ? .white : .black)
                                                .lineLimit(1)
                                        }
                                    case .clickVibe:
                                        if vibeIsActivated {
                                            Text("켬")
                                                .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                .foregroundColor(isFocused ? .white : .black)
                                                .lineLimit(1)
                                        } else {
                                            Text("끔")
                                                .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                .foregroundColor(isFocused ? .white : .black)
                                                .lineLimit(1)
                                        }
                                    case .videoZoom:
                                        switch videoZoomMode {
                                            case .fit:
                                                Text("전부 보이기")
                                                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                    .foregroundColor(isFocused ? .white : .black)
                                                    .lineLimit(1)
                                            case .zoom:
                                                Text("확대")
                                                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                    .foregroundColor(isFocused ? .white : .black)
                                                    .lineLimit(1)
                                        }
                                    case .videoAutoplay:
                                        switch videoAutoplayMode {
                                            case .off:
                                                Text("끔")
                                                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                    .foregroundColor(isFocused ? .white : .black)
                                                    .lineLimit(1)
                                            case .one:
                                                Text("같은 비디오")
                                                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                    .foregroundColor(isFocused ? .white : .black)
                                                    .lineLimit(1)
                                            case .all:
                                                Text("다음 비디오")
                                                    .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                    .foregroundColor(isFocused ? .white : .black)
                                                    .lineLimit(1)
                                        }
                                    case .mainMenu:
                                        if mainMenuBoolArray[mainMenuIndexShaker(indexInList)] {
                                            Text("켬")
                                                .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                .foregroundColor(isFocused ? .white : .black)
                                                .lineLimit(1)
                                        } else {
                                            Text("끔")
                                                .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                .foregroundColor(isFocused ? .white : .black)
                                                .lineLimit(1)
                                        }
                                    case .mediaRefresh:
                                        switch libraryUpdateSymbolState {
                                            case .notShown:
                                                EmptyView()
                                            case .loading:
                                                DotsProgressView(brightBack: !isFocused)
                                                    .frame(width: DesignSystem.Soft.Dimension.rowHeight * 0.5, height: DesignSystem.Soft.Dimension.rowHeight * 0.5)
                                            case .done:
                                                Image(systemName: "checkmark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .fontWeight(.heavy)
                                                    .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.4)
                                                    .foregroundColor(isFocused ? .white : .black)
                                            case .error:
                                                Image(systemName: "questionmark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .fontWeight(.heavy)
                                                    .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.47)
                                                    .foregroundColor(isFocused ? .white : .black)
                                        }
                                    case .timeInHeader:
                                        if wantsToSeeTimeInHeader {
                                            Text("켬")
                                                .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                .foregroundColor(isFocused ? .white : .black)
                                                .lineLimit(1)
                                        } else {
                                            Text("끔")
                                                .font(.system(size: DesignSystem.Soft.Dimension.basicFontSize, weight: .semibold))
                                                .foregroundColor(isFocused ? .white : .black)
                                                .lineLimit(1)
                                        }
                                    default:
                                        EmptyView()
                                }
                            case .link:
                                Image(systemName: "chevron.right.2")
                                    .resizable()
                                    .scaledToFit()
                                    .fontWeight(.heavy)
                                    .frame(height: DesignSystem.Soft.Dimension.rowHeight * 0.4)
                                    .foregroundColor(isFocused ? .white : .black)
                            default:
                                EmptyView()
                        }
                        Spacer()
                            .frame(width: DesignSystem.Soft.Dimension.basicIndentation)
                    }
                }
                .frame(minWidth: DesignSystem.Soft.Dimension.w - DesignSystem.Soft.Dimension.scrollBarWidth, maxWidth: DesignSystem.Soft.Dimension.w)
                .frame(height: DesignSystem.Soft.Dimension.rowHeight)
            }
        }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RowView(rowData: RowData(text: "음악", actionStyle: .change, key: .music, handlingProperty: .mediaRefresh), indexInList: 0, isFocused: true, wantsToSeeTimeInHeader: false, repeatState: .all, alwaysShuffle: true, vibeIsActivated: true, videoZoomMode: .fit, videoAutoplayMode: .off, libraryUpdateSymbolState: .loading, mainMenuBoolArray: StatusModel.initialValueOfMainMenuBoolArray, needsAnimatedView: true)
            RowView(rowData: RowData(text: "음악", actionStyle: .change, key: .music, handlingProperty: .mediaRefresh), indexInList: 0, isFocused: true, wantsToSeeTimeInHeader: false, repeatState: .all, alwaysShuffle: true, vibeIsActivated: true, videoZoomMode: .fit, videoAutoplayMode: .off, libraryUpdateSymbolState: .done, mainMenuBoolArray: StatusModel.initialValueOfMainMenuBoolArray, needsAnimatedView: true)
            RowView(rowData: RowData(text: "음악", actionStyle: .change, key: .music, handlingProperty: .mediaRefresh), indexInList: 0, isFocused: true, wantsToSeeTimeInHeader: false, repeatState: .all, alwaysShuffle: true, vibeIsActivated: true, videoZoomMode: .fit, videoAutoplayMode: .off, libraryUpdateSymbolState: .error, mainMenuBoolArray: StatusModel.initialValueOfMainMenuBoolArray, needsAnimatedView: true)
        }
    }
}
