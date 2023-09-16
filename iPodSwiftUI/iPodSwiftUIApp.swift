//
//  iPodSwiftUIApp.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/17.
//

import SwiftUI

enum InactiveVariety {
    case initial
    case fromActive
    case fromBackground
}

var inactiveVariety: InactiveVariety = .initial

@main
struct iPodSwiftUIApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            DeviceView()
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
                case .active:
                    inactiveVariety = .fromActive
                    _ = 0
                case .inactive:
                    switch inactiveVariety {
                        case .initial:
                            _ = 0
                        case .fromActive:
                            _ = 0
                        case .fromBackground:
                            PodObservable.shared.setPlayInfoRefresher()
                            PodObservable.shared.setBatteryInfoRefresher()
                            PodObservable.shared.playInfoRefresher?.fire()
                            PodObservable.shared.batteryInfoRefresher?.fire()
                    }
                case .background:
                    inactiveVariety = .fromBackground
                    PodObservable.shared.playInfoRefresher?.invalidate()
                    PodObservable.shared.batteryInfoRefresher?.invalidate()
                @unknown default:
                    _ = 0
            }
        }
    }
}
