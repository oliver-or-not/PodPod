//
//  VibeHandler.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/09/02.
//

import UIKit

final class VibeHandler {
    static let shared = VibeHandler()
    
    private init() {}
    
    let mediumVibeGenerator = UIImpactFeedbackGenerator(style: .medium)
    let heavyVibeGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    func mediumVibe(if vibeIsActivated: Bool) {
        if vibeIsActivated {
            mediumVibeGenerator.impactOccurred()
        }
    }
    
    func heavyVibe(if vibeIsActivated: Bool) {
        if vibeIsActivated {
            heavyVibeGenerator.impactOccurred()
        }
    }
    
    func heavyVibeThreeTimes(if vibeIsActivated: Bool) {
        if vibeIsActivated {
            heavyVibeGenerator.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
                self.heavyVibeGenerator.impactOccurred()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                self.heavyVibeGenerator.impactOccurred()
            }
        }
    }
}
