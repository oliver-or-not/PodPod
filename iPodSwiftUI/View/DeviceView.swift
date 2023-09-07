//
//  DeviceView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/17.
//

import AVFoundation
import Combine
import MediaPlayer
import MusicKit
import SwiftUI


struct DeviceView: View {
	@StateObject var podObservable = PodObservable()
        
    var deviceColor: String {
        if let deviceColor = UserDefaults.standard.object(forKey: "deviceColor") as? String {
            return deviceColor
        } else {
            return "wb"
        }
    }
    
	var body: some View {
		GeometryReader { geometry in
            
			ZStack {
                // 기기 바탕색
                Group {
                    switch deviceColor {
                        case "wb":
                            DesignSystem.Hard.Color.frontPlateVariable
                        case "white":
                            DesignSystem.Hard.Color.frontPlateWhite
                        case "black", "red":
                            DesignSystem.Hard.Color.frontPlateBlack
                        default:
                            DesignSystem.Hard.Color.frontPlateVariable
                    }
                }
                .ignoresSafeArea()
                
				VStack(spacing: 0) {
//					 아이폰의 위아래 safe area 높이 비교하고, 아래쪽이 더 길면 위에 그만큼 공백을 더해준다.
                    if geometry.safeAreaInsets.top < geometry.safeAreaInsets.bottom {
                        Spacer()
                            .frame(height: geometry.safeAreaInsets.bottom - geometry.safeAreaInsets.top)
                    }
					
					// 화면 주변 검은 영역과 ScreenView의 ZStack
					ZStack {
						RoundedRectangle(cornerRadius: DesignSystem.Hard.Dimension.iPodScreenBoundaryCornerRadius)
                            .foregroundColor(DesignSystem.Hard.Color.iPodScreenBoundary)
							.frame(width: DesignSystem.Hard.Dimension.iPodScreenBoundaryWidth, height: DesignSystem.Hard.Dimension.iPodScreenBoundaryHeight)
						ScreenView()
							.environmentObject(podObservable)
					}
					
					// 화면과 클릭휠 사이의 간격
					Spacer()
						.frame(height: DesignSystem.Hard.Dimension.screenWheelDistance)
					
					// 클릭휠
                    WheelView(deviceColor: deviceColor)
					
					// 실물 iPod 하단과 상단의 여백 차이를 반영하기 위한 Spacer
                    Spacer()
						.frame(height: DesignSystem.Hard.Dimension.topBottomDifference)
					
//					 아이폰의 위아래 safe area 높이 비교하고, 위쪽이 더 길면 아래에 그만큼 공백을 더해준다.
					if geometry.safeAreaInsets.top > geometry.safeAreaInsets.bottom {
                        Spacer()
							.frame(height: geometry.safeAreaInsets.top - geometry.safeAreaInsets.bottom)
					}
				}

				GestureView()
					.environmentObject(podObservable)
			}
            .statusBarHidden(true)
            .alert(Text("구독 상태 안내"), isPresented: $podObservable.subscriptionAlertIsPresented, actions: {
                Button {
                    podObservable.subscriptionAlertIsPresented = false
                } label: {
                    Text("OK")
                }
            }, message: {Text("현재 Apple Music을 구독하고 있지 않습니다. 앱에서 음악을 재생하려면 Apple Music을 구독해야 합니다.")
            })
		}
	}
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView()
    }
}
