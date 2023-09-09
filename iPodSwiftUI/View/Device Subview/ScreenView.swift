//
//  ScreenView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/17.
//

import SwiftUI

struct ScreenView: View {
	@EnvironmentObject var podObservable: PodObservable
	
    var body: some View {
		ZStack {
			Rectangle()
				.fill(.white)
            VStack(spacing: 0) {
                HeaderView(title: podObservable.pageData.headerTitle, timeTitle: podObservable.timeTitle, playingState: podObservable.playingState, batteryState: podObservable.batteryState, batteryLevel: podObservable.batteryLevel, headerTimeIsShown: podObservable.headerTimeIsShown, wantsToSeeTimeInHeader: podObservable.wantsToSeeTimeInHeader)
                    .offset(x: (podObservable.photoDetailIsShown || podObservable.videoDetailIsShown || podObservable.currentKeyIsNowPlayingVideo) ? -DesignSystem.Soft.Dimension.w : 0)
                    .animation(.linear(duration: DesignSystem.Time.slidingAnimationTime).delay(DesignSystem.Time.lagTime), value: podObservable.photoDetailIsShown)
                    .animation(.linear(duration: DesignSystem.Time.slidingAnimationTime).delay(DesignSystem.Time.lagTime), value: podObservable.videoDetailIsShown)
                    .animation(.linear(duration: DesignSystem.Time.slidingAnimationTime).delay(DesignSystem.Time.lagTime * 2.0), value: podObservable.currentKeyIsNowPlayingVideo)
				PageBodyStackView()
					.environmentObject(podObservable)
			}
            Rectangle()
                .fill(DesignSystem.Hard.Color.screenBlueCover)
		}
		.frame(width: DesignSystem.Hard.Dimension.iPodScreenWidth, height: DesignSystem.Hard.Dimension.iPodScreenHeight)
        .clipped()
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
            .environmentObject(PodObservable.shared)
    }
}
