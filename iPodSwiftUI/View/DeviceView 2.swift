//
//  DeviceView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/17.
//

import SwiftUI
import Combine

struct DeviceView: View {
	@StateObject var iPodModel = IPodModel()

	var body: some View {
		GeometryReader { geometry in
			ZStack {
				VStack(spacing: 0) {
//					 아이폰의 위아래 safe area 높이 비교하고, 아래쪽이 더 길면 위에 그만큼 공백을 더해준다.
					if geometry.safeAreaInsets.top < geometry.safeAreaInsets.bottom {
						Spacer()
							.frame(height: geometry.safeAreaInsets.bottom - geometry.safeAreaInsets.top)
					}
					
					// 화면 주변 검은 영역과 ScreenView의 ZStack
					ZStack {
						RoundedRectangle(cornerRadius: DesignSystem.Hard.Dimension.blackCornerRadius)
							.frame(width: DesignSystem.Hard.Dimension.blackWidth, height: DesignSystem.Hard.Dimension.blackHeight)
						ScreenView()
							.environmentObject(iPodModel)
					}
					
					// 화면과 클릭휠 사이의 간격
					Spacer()
						.frame(height: DesignSystem.Hard.Dimension.screenWheelDistance)
					
					// 클릭휠
					WheelView()
					
					// 실물 iPod 하단과 상단의 여백 차이를 반영하기 위한 Spacer
					Spacer()
						.frame(height: DesignSystem.Hard.Dimension.topBottomDifference)
					
//					 아이폰의 위아래 safe area 높이 비교하고, 위쪽이 더 길면 아래에 그만큼 공백을 더해준다.
					if geometry.safeAreaInsets.top > geometry.safeAreaInsets.bottom {
						Spacer()
							.frame(height: geometry.safeAreaInsets.top - geometry.safeAreaInsets.bottom)
					}
				}
                Text(String(format: "%.0f", iPodModel.wheelValue) + " degree(s)")
					.offset(y: 280)

				GestureView()
					.environmentObject(iPodModel)
			}
		}
	}
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView()
    }
}
