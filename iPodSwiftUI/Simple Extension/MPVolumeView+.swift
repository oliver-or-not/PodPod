//
//  MPVolumeView+.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/14.
//

import AVFoundation
import MediaPlayer

extension MPVolumeView {
    static func setVolume(_ volume: Float) -> Void {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: {$0 is UISlider}) as? UISlider
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            slider?.value = volume
        }
    }
    
    static func getVolume(completion: @escaping (Float) -> Void) {
        let volumeView = MPVolumeView()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            if let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
                completion(slider.value)
            }
        }
    }
}
