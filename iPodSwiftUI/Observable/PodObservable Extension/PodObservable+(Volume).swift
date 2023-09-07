//
//  PodObservable+(Volume).swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/09/03.
//

import MediaPlayer

extension PodObservable {
    
    //MARK: - set volume
    
    func setVolume(_ volume: Float) {
        MPVolumeView.setVolume(volume)
    }
}
