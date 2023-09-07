//
//  WheelView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/17.
//

import SwiftUI

struct WheelView: View {
	
    var deviceColor: String
    
    var wheelColor: Color {
            switch deviceColor {
                case "wb":
                    return DesignSystem.Hard.Color.wheelVariable
                case "white":
                    return DesignSystem.Hard.Color.wheelWhite
                case "black":
                    return DesignSystem.Hard.Color.wheelBlack
                case "red":
                    return DesignSystem.Hard.Color.wheelRed
                default:
                    return DesignSystem.Hard.Color.wheelVariable
            }
    }

    var shadowColor: Color {
            switch deviceColor {
                case "wb":
                    return DesignSystem.Hard.Color.wheelShadowVariable
                case "white":
                    return DesignSystem.Hard.Color.wheelShadowWhite
                case "black", "red":
                    return DesignSystem.Hard.Color.wheelShadowBlack
                default:
                    return DesignSystem.Hard.Color.wheelShadowVariable
            }
    }
    
    var centerButtonColor: Color {
        switch deviceColor {
            case "wb":
                return DesignSystem.Hard.Color.centerButtonVariable
            case "white":
                return DesignSystem.Hard.Color.centerButtonWhite
            case "black", "red":
                return DesignSystem.Hard.Color.centerButtonBlack
            default:
                return DesignSystem.Hard.Color.centerButtonVariable
        }
    }
    
    var body: some View {
		ZStack {
			Circle()
				.foregroundColor(wheelColor)
                .frame(width: DesignSystem.Hard.Dimension.wheelRadius * 2.0, height: DesignSystem.Hard.Dimension.wheelRadius * 2.0)
                .shadow(color: shadowColor, radius: DesignSystem.Hard.Dimension.w / 250)
			Circle()
                .foregroundColor(centerButtonColor)
                .frame(width: DesignSystem.Hard.Dimension.centerButtonRadius * 2.0, height: DesignSystem.Hard.Dimension.centerButtonRadius * 2.0)
			
			// wheel letter and symbol
			Group {
				Text("MENU")
					.font(.system(size: DesignSystem.Hard.Dimension.wheelFontSize, weight: .bold))
					.foregroundColor(.white)
					.offset(y: DesignSystem.Hard.Dimension.wheelTopLetterOffset)
				
				HStack(spacing: 3) {
					Image(systemName: "play.fill")
						.scaleEffect(0.9)
					Image(systemName: "pause.fill")
				}
				.font(.system(size: DesignSystem.Hard.Dimension.wheelFontSize, weight: .thin))
				.foregroundColor(.white)
				.offset(y: DesignSystem.Hard.Dimension.wheelBottomLetterOffset)
				
				Image(systemName: "backward.end.alt.fill")
					.font(.system(size: DesignSystem.Hard.Dimension.wheelFontSize, weight: .thin))
					.foregroundColor(.white)
					.offset(x: DesignSystem.Hard.Dimension.wheelLeadingLetterOffset)
				
				Image(systemName: "forward.end.alt.fill")
					.font(.system(size: DesignSystem.Hard.Dimension.wheelFontSize, weight: .thin))
					.foregroundColor(.white)
					.offset(x: DesignSystem.Hard.Dimension.wheelTrailingLetterOffset)
			}
		}
    }
}

struct WheelView_Previews: PreviewProvider {
    static var previews: some View {
		WheelView(deviceColor: "wb")
    }
}
