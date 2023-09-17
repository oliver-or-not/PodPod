//
//  trackSortRule.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/17.
//

import MusicKit

let trackSortRule: (Song, Song) -> Bool = {
    if let t0 = $0.trackNumber, let t1 = $1.trackNumber {
        return t0 <= t1
    } else if let t0 = $0.trackNumber, $1.trackNumber == nil {
        return true
    } else if $0.trackNumber == nil, let t0 = $1.trackNumber {
        return false
    }
    // $0.trackNumber == nil && $1.trackNumber == nil
    else {
        return true
    }
}
