//
//  DesignSystem.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/17.
//

import Foundation
import UIKit
import SwiftUI

enum DesignSystem {
	enum Hard {
		enum Dimension {}
		enum Color {}
	}
	enum Soft {
		enum Dimension {}
		enum Color {}
	}
    enum Time {
    }
    enum String {
    }
}

//MARK: - DesignSystem > Hard > Dimension

extension DesignSystem.Hard.Dimension {
    
	//MARK: - iphone screen
    
	static let w = UIScreen.main.bounds.width
	static let h = UIScreen.main.bounds.height
	
	static var centerCoordinate: CGPoint {
		var temp = CGPoint.zero
		temp.x = w * 0.5
		temp.y = h * 0.5
		return temp
	}
	
	//MARK: - iPod screen
    
	static var iPodScreenBoundaryWidth: CGFloat {
		w * 0.851
	}
	static var iPodScreenBoundaryHeight: CGFloat {
		w * 0.646
	}
	static var iPodScreenBoundaryCornerRadius: CGFloat {
		w * 0.015
	}
	static var iPodScreenWidth: CGFloat {
        w * 0.820 // 0.811
	}
	static var iPodScreenHeight: CGFloat {
        w * 0.615 // 0.608
	}
	
	//MARK: - distance
    
	static var screenWheelDistance: CGFloat {
		w * 0.156
	}
	// diff between bezel on screen and bezel below wheel; bottom bezel is bigger
	static var topBottomDifference: CGFloat {
		w * 0.099
	}
	
	//MARK: - iPod wheel
    
	static var wheelRadius: CGFloat {
		w * 0.3115
	}
	static var centerButtonRadius: CGFloat {
		w * 0.1105
	}
	
	static var wheelCenterCoordinateWithoutSafeAreaData: CGPoint {
		
		var temp = CGPoint.zero
		temp.x = w * 0.5
		temp.y = h * 0.5 +
		(DesignSystem.Hard.Dimension.iPodScreenBoundaryHeight + DesignSystem.Hard.Dimension.screenWheelDistance - DesignSystem.Hard.Dimension.topBottomDifference) * 0.5
		return temp
	}
	
	//MARK: - iPod wheel letter
    
	static var wheelFontSize: CGFloat {
		w * 0.0385
	}
	static var wheelTopLetterOffset: CGFloat {
		w * (-0.26)
	}
	static var wheelBottomLetterOffset: CGFloat {
		w * 0.26
	}
	static var wheelLeadingLetterOffset: CGFloat {
		w * (-0.245)
	}
	static var wheelTrailingLetterOffset: CGFloat {
		w * 0.245
	}
    
    //MARK: - iPod wheel gesture
    
    static var centerButtonTapRadius: CGFloat {
        centerButtonRadius * 0.9
    }
    
    static var wheelTopButtonCoordinateWithoutSafeAreaData: CGPoint {
        var temp = wheelCenterCoordinateWithoutSafeAreaData
        temp.y -= (wheelRadius + centerButtonRadius) / 2.0
        return temp
    }
    
    static var wheelBottomButtonCoordinateWithoutSafeAreaData: CGPoint {
        var temp = wheelCenterCoordinateWithoutSafeAreaData
        temp.y += (wheelRadius + centerButtonRadius) / 2.0
        return temp
    }
    
    static var wheelLeadingButtonCoordinateWithoutSafeAreaData: CGPoint {
        var temp = wheelCenterCoordinateWithoutSafeAreaData
        temp.x -= (wheelRadius + centerButtonRadius) / 2.0
        return temp
    }
    
    static var wheelTrailingButtonCoordinateWithoutSafeAreaData: CGPoint {
        var temp = wheelCenterCoordinateWithoutSafeAreaData
        temp.x += (wheelRadius + centerButtonRadius) / 2.0
        return temp
    }
    
    static var wheelButtonsTapRadius: CGFloat {
        (wheelRadius - centerButtonRadius) / 2.0 * 0.9
    }
    
    static var wheelDragInnerRadius: CGFloat {
        centerButtonRadius * 0.8
    }
    
    static var wheelDragOuterRadius: CGFloat {
        wheelRadius * 1.07
    }
    
    static var seekingAreaRadius: CGFloat {
        centerButtonTapRadius * 0.6
    }
}

    /*
     *** calculation of wheelCenterCoordinate.y ***
     blackHeight = a
     screenWheelDistance = b
     wheelRadius = c
     <- here: wheelCenterCoordinate.y
     wheelRadius = d
     topBottomDifference = e
     
     wheelCenterCoordinate.y = U.m.b.height / 2 + (a + b + c + d + e) / 2 - (d + e)
     = U.m.b.height / 2 + (a + b + c - d - e) / 2
     = U.m.b.height / 2 + (a + b - e) / 2
     */

//MARK: - DesignSystem > Hard > Color

extension DesignSystem.Hard.Color {
	static let wheelVariable = Color("wheelVariable")
    static let wheelWhite = Color("wheelWhite")
    static let wheelBlack = Color("wheelBlack")
    static let wheelRed = Color("wheelRed")
    
    static let wheelShadowVariable = Color("wheelShadowVariable")
    static let wheelShadowWhite = Color("wheelShadowWhite")
    static let wheelShadowBlack = Color("wheelShadowBlack")
    
    static let frontPlateVariable = Color("frontPlateVariable")
    static let frontPlateWhite = Color("frontPlateWhite")
    static let frontPlateBlack = Color("frontPlateBlack")
    
    static let centerButtonVariable = Color("centerButtonVariable")
    static let centerButtonWhite = Color("centerButtonWhite")
    static let centerButtonBlack = Color("centerButtonBlack")
    
    static let iPodScreenBoundary = Color("iPodScreenBoundary")
    static let screenBlueCover = Color("screenBlueCover")
}

//MARK: - DesignSystem > Soft > Dimension

extension DesignSystem.Soft.Dimension {
    
    //MARK: - iPod screen
    
	static var w: CGFloat {
		DesignSystem.Hard.Dimension.iPodScreenWidth
	}
	static var h: CGFloat {
		DesignSystem.Hard.Dimension.iPodScreenHeight
	}
	
    //MARK: - basic
    
	static var basicFontSize: CGFloat {
        w / 18.667
	}
    // indentation; left of text, right of chevron
    static var basicIndentation: CGFloat {
        w / 53.33
    }
    
    static var basicThinValue: CGFloat {
        w / 320
    }
    
    //MARK: - header
    
    static var headerHeight: CGFloat {
        h / CGFloat(rangeOfRows + 1)
    }
    
    //MARK: - body
    
    static var rangeOfRows: Int = 9
    
    static var bodyHeight: CGFloat {
        h / CGFloat(rangeOfRows + 1) * CGFloat(rangeOfRows)
    }
	static var rowHeight: CGFloat {
		h / CGFloat(rangeOfRows + 1)
	}
    
    static var rowTextSlidingIndentation: CGFloat {
        w / 12.0
    }
    
    //MARK: - photo
    
    static var photoHorizontalNum: Int = 6
    static var photoVerticalNum: Int = 5
    static var photoBorderWidth: CGFloat = 2.6
    
    //MARK: - video
    
    static var videoThumbnailHorizontalNum: Int = 4
    static var videoThumbnailVerticalNum: Int = 3
    static var videoThumbnailBorderWidth: CGFloat = 4.5
    
    static var videoFontSize: CGFloat {
        w / 19.88
    }
    
    //MARK: - scroll bar
    
    static var scrollBarWidth: CGFloat {
        w * 0.0375
    }
    
    static let scrollBarWhiteGlowNum: Int = 20
    
    //MARK: - now playing
    
    static var nowPlayingHorizontalIndentation: CGFloat {
        w / 20.378
    }
    
    static var nowPlayingFontSize: CGFloat {
        w / 20.054
    }
    
    static var nowPlayingAlbumImageLength: CGFloat {
        w / 3.22
    }
    
    static var fullArtworkAlbumImageLength: CGFloat {
        bodyHeight * 0.936
    }
    
    //MARK: - horizontal bar
    
    static var timeBarHeight: CGFloat {
        w / 21.17
    }
    
    static var timeBarWidth: CGFloat {
        w * 0.89 
    }
    
    static var volumeBarHeight: CGFloat {
        w / 21.17
    }
    
    static var volumeBarWidth: CGFloat {
        w * 0.806
    }
    
    static let horizontalBarWhiteGlowNum: Int = 17
    
    //MARK: - wheel
    
    static let transitionNumberPerOneRotation = 24
    static let soundVibeNumberThroughWholeSoundBar = 9
}

//MARK: - DesignSystem > Soft > Color

extension DesignSystem.Soft.Color {
    
    //MARK: - header
    
    static let headerTop = Color("headerTop")
    static let headerBottom = Color("headerBottom")
    static let headerBottomLine = Color("headerBottomLine")
    
    static let playingStateStripe0 = Color("playingStateStripe0")
    static let playingStateStripe1 = Color("playingStateStripe1")
    static let playingStateStripe2 = Color("playingStateStripe2")
    static let playingStateStripe3 = Color("playingStateStripe3")
    
    static let headerBatteryGreenStripe0 = Color("headerBatteryGreenStripe0")
    static let headerBatteryGreenStripe1 = Color("headerBatteryGreenStripe1")
    static let headerBatteryGreenStripe2 = Color("headerBatteryGreenStripe2")
    static let headerBatteryGreenStripe3 = Color("headerBatteryGreenStripe3")
    static let headerBatteryGreenStripe4 = Color("headerBatteryGreenStripe4")
    
    static let headerBatteryRedStripe0 = Color("headerBatteryRedStripe0")
    static let headerBatteryRedStripe1 = Color("headerBatteryRedStripe1")
    static let headerBatteryRedStripe2 = Color("headerBatteryRedStripe2")
    static let headerBatteryRedStripe3 = Color("headerBatteryRedStripe3")
    static let headerBatteryRedStripe4 = Color("headerBatteryRedStripe4")
    
    static let headerBatteryBaseStripe0 = Color("headerBatteryBaseStripe0")
    static let headerBatteryBaseStripe1 = Color("headerBatteryBaseStripe1")
    static let headerBatteryBaseStripe2 = Color("headerBatteryBaseStripe2")
    static let headerBatteryLine = Color("headerBatteryLine")
    static let headerBatteryThunder = Color("headerBatteryThunder")
    
    //MARK: - focused row
    
    static let focusedRowTopLine = Color("focusedRowTopLine")
    static let focusedRowTop = Color("focusedRowTop")
    static let focusedRowBottom = Color("focusedRowBottom")
    
    //MARK: - scroll bar
    
    static let scrollBarBaseLeadingLine = Color("scrollBarBaseLeadingLine")
    static let scrollBarBaseLeading = Color("scrollBarBaseLeading")
    static let scrollBarBaseTrailing = Color("scrollBarBaseTrailing")
    
    static let scrollBarWhiteGlow = Color("scrollBarWhiteGlow")
    
    static let scrollBarStripe0 = Color("scrollBarStripe0")
    static let scrollBarStripe1 = Color("scrollBarStripe1")
    static let scrollBarStripe2 = Color("scrollBarStripe2")
    static let scrollBarStripe3 = Color("scrollBarStripe3")
    static let scrollBarStripe4 = Color("scrollBarStripe4")
    static let scrollBarStripeLine = Color("scrollBarStripeLine")
    
    //MARK: - horizontal bar
    
    static let horizontalBarStripe0 = Color("horizontalBarStripe0")
    static let horizontalBarStripe1 = Color("horizontalBarStripe1")
    static let horizontalBarStripe2 = Color("horizontalBarStripe2")
    static let horizontalBarStripe3 = Color("horizontalBarStripe3")
    static let horizontalBarStripe4 = Color("horizontalBarStripe4")
    
    static let horizontalBarBaseStripe0 = Color("horizontalBarBaseStripe0")
    static let horizontalBarBaseStripe1 = Color("horizontalBarBaseStripe1")
    static let horizontalBarBaseStripe2 = Color("horizontalBarBaseStripe2")
    static let horizontalBarBaseStripe3 = Color("horizontalBarBaseStripe3")
    static let horizontalBarBaseStripe4 = Color("horizontalBarBaseStripe4")
    
    static let horizontalBarWhiteGlow = Color("horizontalBarWhiteGlow")
    
    //MARK: - album artwork
    
    static let albumBorder = Color("albumBorder")
    static let albumPlaceholderBackground = Color("albumPlaceholderBackground")
    static let albumPlaceholderNote = Color("albumPlaceholderNote")
    
    //MARK: - photo
    
    static let photoBorder = Color("photoBorder")
    
    //MARK: - video
    
    static let videoWhite = Color("videoWhite")
    static let videoBlack = Color("videoBlack")
}

//MARK: - DesignSystem > Time

extension DesignSystem.Time {
    static let slidingAnimationTime = 0.27
    static let lagTime = 0.1
    static let longLagTime = 0.8
    static let rowTextSlidingAnimationTimePerWidth = 5.5
    static let nowPlayingUpperTextSlidingAnimationTimePerWidth = 11.0
    static let rowTextRestTime = 1.3
    static let nowPlayingUpperTextRestTime = 1.3
    static let rowTextLagTime = 1.5
    static let nowPlayingUpperTextLagTime = 1.5
    static let videoSymbolFadeOutTime = 0.8
}

//MARK: - DesignSystem > String

extension DesignSystem.String {
    static let appName = "PodPod"
}
