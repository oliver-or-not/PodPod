//
//  iPodSwiftUIApp.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/17.
//

import SwiftUI

@main
struct iPodSwiftUIApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            DeviceView()
        }
        .onChange(of: scenePhase) { oldScenePhase, newScenePhase in
            switch newScenePhase {
                case .active:
                    StatusModel.shared.inactiveVariety = .fromActive
                    _ = 0
                case .inactive:
                    switch StatusModel.shared.inactiveVariety {
                        case .initial:
                            _ = 0
                        case .fromActive:
                            _ = 0
                        case .fromBackground:
                            PodObservable.shared.setPlayInfoRefresher()
                            PodObservable.shared.setBatteryInfoRefresher()
                            PodObservable.shared.playInfoRefresher?.fire()
                            PodObservable.shared.batteryInfoRefresher?.fire()
                            PodObservable.shared.needsAnimatedView = true
                            PodObservable.shared.nowPlayingUpperTextFlick(needsReset: true)
                    }
                case .background:
                    StatusModel.shared.inactiveVariety = .fromBackground
                    PodObservable.shared.playInfoRefresher?.invalidate()
                    PodObservable.shared.batteryInfoRefresher?.invalidate()
                    PodObservable.shared.needsAnimatedView = false
                @unknown default:
                    _ = 0
            }
        }
    }
}
