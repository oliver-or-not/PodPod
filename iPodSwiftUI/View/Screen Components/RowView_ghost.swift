//
//  RowView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/23.
//

import SwiftUI
import MusicKit

struct RowView_ghost: View {
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
                                        ProgressView()
                                            .controlSize(.mini)
                                            .tint(isFocused ? .white : .black)
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
                                        ProgressView()
                                            .controlSize(.mini)
                                            .tint(isFocused ? .white : .black)
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
                                            ProgressView()
                                                .controlSize(.mini)
                                                .tint(isFocused ? .white : .black)
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

struct RowView_ghost_Previews: PreviewProvider {
    static var previews: some View {
        RowView_ghost(rowData: RowData(text: "음악", actionStyle: .chevronMove, key: .music), indexInList: 0, isFocused: true, wantsToSeeTimeInHeader: false, repeatState: .all, alwaysShuffle: true, vibeIsActivated: true, videoZoomMode: .fit, videoAutoplayMode: .off, libraryUpdateSymbolState: .done, mainMenuBoolArray: StatusModel.initialValueOfMainMenuBoolArray)
    }
}
