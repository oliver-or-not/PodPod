//
//  GestureView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/21.
//

import SwiftUI

struct GestureView: View {
	@EnvironmentObject var iPodModel: IPodModel
	
	// initial(L/R) are updated only at the first time of touch.
	@State private var initialLocation: CGPoint? = nil
	@State private var initialRawAngle: CGFloat? = nil
	
	// reentry(L/R) are updated 1) at the first time of touch or 2) rightafter every re-entry to wheel area.
	@State private var reentryLocation: CGPoint? = nil
	@State private var reentryRawAngle: CGFloat? = nil
	
	// realTime(L/R) are updated at every frame
	@State private var realTimeLocation: CGPoint? = nil
	@State private var realTimeRawAngle: CGFloat? = nil
	
	@State private var rotationCounter: Int = 0
	
	@State private var tempRealTimeLocation: CGPoint? = nil
	
	// prev(L/R) are updated at every frame; previous values of realTime(L/R)
	@State private var prevLocation: CGPoint? = nil
	@State private var prevRawAngle: CGFloat? = nil
	
	@GestureState private var dragOffset = CGSize.zero
	
	var body: some View {
		GeometryReader { geometry in
			
			let wheelCenterCoordinate = CGPoint(x: DesignSystem.Hard.Dimension.wheelCenterCoordinateWithoutSafeAreaData.x, y: DesignSystem.Hard.Dimension.wheelCenterCoordinateWithoutSafeAreaData.y - geometry.safeAreaInsets.top)
			
			Color(.green)
				.ignoresSafeArea(.all)
				.opacity(0.000001)
				.gesture(
					DragGesture()
						.onChanged { gesture in
							// sets initial(L/R) and reentry(L/R)
							if initialLocation == nil {
								print("drag init")
								initialLocation = gesture.startLocation
								if let initialLocation = initialLocation {
									initialRawAngle = angle(of: initialLocation, from: wheelCenterCoordinate)
									reentryLocation = initialLocation
									reentryRawAngle = initialRawAngle
								}
							}
							
							// updates tempRealTimeLocation
							if let initialLocation = initialLocation {
								tempRealTimeLocation = CGPoint(x: initialLocation.x + dragOffset.width, y: initialLocation.y + dragOffset.height)
							}
							
							// updates prev(L/R)
							// prevLocation can be nil at the first time
							prevLocation = realTimeLocation
							prevRawAngle = realTimeRawAngle
							
							// updates realTime(L/R)
							realTimeLocation = tempRealTimeLocation
							if let realTimeLocation = realTimeLocation {
								realTimeRawAngle = angle(of: realTimeLocation, from: wheelCenterCoordinate)
							}
							
							
							if let prevLocation = prevLocation, let realTimeLocation = realTimeLocation {
								// when re-entering
								if !pIsInTouchArea(p: prevLocation, center: wheelCenterCoordinate) && pIsInTouchArea(p: realTimeLocation, center: wheelCenterCoordinate) {
									print("re-enter")
									reentryLocation = realTimeLocation
									reentryRawAngle = realTimeRawAngle
									rotationCounter = 0
								}
								// when leaving
								if pIsInTouchArea(p: prevLocation, center: wheelCenterCoordinate) && !pIsInTouchArea(p: realTimeLocation, center: wheelCenterCoordinate) {
									print("leave")
									resetAfterLeaving()
								}
							}
							
							// updates rotationCounter
							if let realTimeRawAngle = realTimeRawAngle, let prevRawAngle = prevRawAngle {
								// when it changes from 359.xx to 0.0
								if prevRawAngle > realTimeRawAngle + 180.0 {
									rotationCounter += 1
								} else
								// when it changes from 0.0 to 359.xx
								if prevRawAngle < realTimeRawAngle - 180.0 {
									rotationCounter -= 1
								}
							}
							
							// updates wheelValue
							if let realTimeRawAngle = realTimeRawAngle, let reentryRawAngle = reentryRawAngle, let realTimeLocation = realTimeLocation {
								if pIsInTouchArea(p: realTimeLocation, center: wheelCenterCoordinate) {
                                    iPodModel.wheelValue = realTimeRawAngle - reentryRawAngle
									+ CGFloat(rotationCounter) * 360.0
								}
							}
						}
						.updating($dragOffset, body: { (value, state, transaction) in
							state = value.translation
						})
						.onEnded { gesture in
							print("drag end")
							resetAfterEndOfDrag()
						}
				)
		}
	}
	
	private func resetAfterEndOfDrag() {
        iPodModel.wheelValue = 0.0
		initialLocation = nil
		initialRawAngle = nil
		reentryLocation = nil
		reentryRawAngle = nil
		realTimeLocation = nil
		realTimeRawAngle = nil
		rotationCounter = 0
		prevLocation = nil
		prevRawAngle  = nil
	}
	
	private func resetAfterLeaving() {
        iPodModel.wheelValue = 0.0
		reentryLocation = nil
		reentryRawAngle = nil
		rotationCounter = 0
	}
	
	private func pIsInTouchArea(p: CGPoint, center: CGPoint) -> Bool {
		if dist(p, center) >= DesignSystem.Hard.Dimension.centerButtonDiameter * 0.5 && dist(p, center) <= DesignSystem.Hard.Dimension.wheelDiameter * 0.5 {
			return true
		}
		return false
	}
}

struct GestureView_Previews: PreviewProvider {
	static var previews: some View {
		GestureView()
			.environmentObject(IPodModel())
	}
}
