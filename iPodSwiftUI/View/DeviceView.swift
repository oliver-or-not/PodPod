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
    @StateObject var podObservable = PodObservable.shared
        
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
                // background color of device
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
					// ZStack of screen boundary and ScreenView
					ZStack {
						RoundedRectangle(cornerRadius: DesignSystem.Hard.Dimension.iPodScreenBoundaryCornerRadius)
                            .foregroundColor(DesignSystem.Hard.Color.iPodScreenBoundary)
							.frame(width: DesignSystem.Hard.Dimension.iPodScreenBoundaryWidth, height: DesignSystem.Hard.Dimension.iPodScreenBoundaryHeight)
						ScreenView()
							.environmentObject(podObservable)
					}
					
                    // distance between screen boundary and wheel
					Spacer()
						.frame(height: DesignSystem.Hard.Dimension.screenWheelDistance)
					
					// wheel
                    WheelView(deviceColor: deviceColor)
				}
                .offset(y: (geometry.safeAreaInsets.bottom - geometry.safeAreaInsets.top - DesignSystem.Hard.Dimension.topBottomDifference) * 0.5)

                // transparent view managing gestures
				GestureView()
					.environmentObject(podObservable)
			}
            .statusBarHidden(!(podObservable.subscriptionAlertIsPresented || podObservable.videoNetworkAlertIsPresented || podObservable.mediaRefreshNetworkAlertIsPresented))
            .alert(Text("구독 상태 안내"), isPresented: $podObservable.subscriptionAlertIsPresented) {
                Button {
                    podObservable.subscriptionAlertIsPresented = false
                } label: {
                    Text("확인")
                }
            } message: {Text("현재 Apple Music을 구독하고 있지 않습니다. 앱에서 음악을 재생하려면 Apple Music을 구독해야 합니다.")
            }
            .alert(Text("셀룰러 통신 안내"), isPresented: $podObservable.videoNetworkAlertIsPresented) {
                Button {
                    podObservable.userAllowedVideoNetworkLoading = false
                    podObservable.videoNetworkAlertIsPresented = false
                } label: {
                    Text("아니오")
                }
                Button {
                    podObservable.userAllowedVideoNetworkLoading = true
                    podObservable.videoNetworkAlertIsPresented = false
                } label: {
                    Text("예")
                }
            } message: {Text("셀룰러 네트워크를 사용하여 iCloud에서 영상을 다운로드하시겠습니까?\n\n데이터 요금제에 따라 비용이 발생할 수 있습니다.")
            }
            .alert(Text("셀룰러 통신 안내"), isPresented: $podObservable.mediaRefreshNetworkAlertIsPresented) {
                Button {
                    podObservable.userAllowedMediaRefreshNetworkLoading = false
                    podObservable.mediaRefreshNetworkAlertIsPresented = false
                } label: {
                    Text("아니오")
                }
                Button {
                    podObservable.userAllowedMediaRefreshNetworkLoading = true
                    podObservable.mediaRefreshNetworkAlertIsPresented = false
                } label: {
                    Text("예")
                }
            } message: {Text("셀룰러 네트워크를 사용하여 미디어 목록과 이미지를 다운로드하시겠습니까?\n\n데이터 요금제에 따라 비용이 발생할 수 있습니다.\n\n음악과 비디오 파일은 지금 다운로드하지 않고 재생 화면에서 다운로드합니다.")
            }
		}
	}
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView()
    }
}
