//
//  GestureView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/21.
//

import SwiftUI

struct GestureView: View {
    @EnvironmentObject var podObservable: PodObservable
    
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
    
    @State private var seekDragInitialLocation: CGPoint? = nil
    
    @State private var testCounter = 0
    
    private var vibeHandler = VibeHandler.shared
    
    
    var body: some View {
        GeometryReader { geometry in
            
            let wheelCenterCoordinate = CGPoint(x: DesignSystem.Hard.Dimension.wheelCenterCoordinateWithoutSafeAreaData.x, y: DesignSystem.Hard.Dimension.wheelCenterCoordinateWithoutSafeAreaData.y - geometry.safeAreaInsets.top)
            
            let wheelTopButtonCoordinate = CGPoint(x: DesignSystem.Hard.Dimension.wheelTopButtonCoordinateWithoutSafeAreaData.x ,y: DesignSystem.Hard.Dimension.wheelTopButtonCoordinateWithoutSafeAreaData.y - geometry.safeAreaInsets.top)
            let wheelBottomButtonCoordinate = CGPoint(x: DesignSystem.Hard.Dimension.wheelBottomButtonCoordinateWithoutSafeAreaData.x ,y: DesignSystem.Hard.Dimension.wheelBottomButtonCoordinateWithoutSafeAreaData.y - geometry.safeAreaInsets.top)
            let wheelLeadingButtonCoordinate = CGPoint(x: DesignSystem.Hard.Dimension.wheelLeadingButtonCoordinateWithoutSafeAreaData.x ,y: DesignSystem.Hard.Dimension.wheelLeadingButtonCoordinateWithoutSafeAreaData.y - geometry.safeAreaInsets.top)
            let wheelTrailingButtonCoordinate = CGPoint(x: DesignSystem.Hard.Dimension.wheelTrailingButtonCoordinateWithoutSafeAreaData.x ,y: DesignSystem.Hard.Dimension.wheelTrailingButtonCoordinateWithoutSafeAreaData.y - geometry.safeAreaInsets.top)
            
            let wheelButtonsTapRadius = DesignSystem.Hard.Dimension.wheelButtonsTapRadius
            let centerButtonTapRadius = DesignSystem.Hard.Dimension.centerButtonTapRadius
            
            ZStack {
                Color(.green)
                    .ignoresSafeArea(.all)
                    .opacity(0.000001)
                    .onTapGesture { coordinate in
                        if dist(wheelCenterCoordinate, coordinate) < centerButtonTapRadius {
                            testCounter += 1
                            podObservable.centerButtonTapped()
                        }
                        else if dist(wheelTopButtonCoordinate, coordinate) < wheelButtonsTapRadius {
                            testCounter += 1
                            podObservable.topButtonTapped()
                        }
                        else if dist(wheelBottomButtonCoordinate, coordinate) < wheelButtonsTapRadius {
                            testCounter += 1
                            podObservable.bottomButtonTapped()
                        }
                        else if dist(wheelLeadingButtonCoordinate, coordinate) < wheelButtonsTapRadius {
                            testCounter += 1
                            podObservable.leadingButtonTapped()
                        }
                        else if dist(wheelTrailingButtonCoordinate, coordinate) < wheelButtonsTapRadius {
                            testCounter += 1
                            podObservable.trailingButtonTapped()
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                // sets initial(L/R) and reentry(L/R)
                                if initialLocation == nil {
                                    initialLocation = gesture.startLocation
                                    if let initialLocation {
                                        initialRawAngle = angle(of: initialLocation, from: wheelCenterCoordinate)
                                        reentryLocation = initialLocation
                                        reentryRawAngle = initialRawAngle
                                    }
                                }
                                
                                // updates tempRealTimeLocation
                                if let initialLocation {
                                    tempRealTimeLocation = CGPoint(x: initialLocation.x + dragOffset.width, y: initialLocation.y + dragOffset.height)
                                }
                                
                                // updates prev(L/R)
                                // prevLocation can be nil at the first time
                                prevLocation = realTimeLocation
                                prevRawAngle = realTimeRawAngle
                                
                                // updates realTime(L/R)
                                realTimeLocation = tempRealTimeLocation
                                if let realTimeLocation {
                                    realTimeRawAngle = angle(of: realTimeLocation, from: wheelCenterCoordinate)
                                }
                                
                                
                                if let prevLocation, let realTimeLocation {
                                    // when re-entering
                                    if !pIsInTouchArea(p: prevLocation, center: wheelCenterCoordinate) && pIsInTouchArea(p: realTimeLocation, center: wheelCenterCoordinate) {
                                        reentryLocation = realTimeLocation
                                        reentryRawAngle = realTimeRawAngle
                                        rotationCounter = 0
                                    }
                                    // when leaving
                                    if pIsInTouchArea(p: prevLocation, center: wheelCenterCoordinate) && !pIsInTouchArea(p: realTimeLocation, center: wheelCenterCoordinate) {
                                        resetAfterLeaving()
                                    }
                                }
                                
                                // updates rotationCounter
                                if let realTimeRawAngle, let prevRawAngle {
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
                                if let realTimeRawAngle, let reentryRawAngle, let realTimeLocation {
                                    if pIsInTouchArea(p: realTimeLocation, center: wheelCenterCoordinate) {
                                        podObservable.wheelValue = realTimeRawAngle - reentryRawAngle
                                        + CGFloat(rotationCounter) * 360.0
                                    }
                                }
                            }
                            .updating($dragOffset, body: { (value, state, transaction) in
                                state = value.translation
                            })
                            .onEnded { gesture in
                                resetAfterEndOfDrag()
                            }
                    )
            }
        }
    }
    
    private func resetAfterEndOfDrag() {
        podObservable.wheelValue = nil
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
        podObservable.wheelValue = nil
        reentryLocation = nil
        reentryRawAngle = nil
        rotationCounter = 0
    }
    
    // a little bit larger area than visual area of click wheel
    private func pIsInTouchArea(p: CGPoint, center: CGPoint) -> Bool {
        if dist(p, center) >= DesignSystem.Hard.Dimension.wheelDragInnerRadius && dist(p, center) <= DesignSystem.Hard.Dimension.wheelDragOuterRadius {
            return true
        }
        return false
    }
}

struct GestureView_Previews: PreviewProvider {
    static var previews: some View {
        GestureView()
            .environmentObject(PodObservable.shared)
    }
}





