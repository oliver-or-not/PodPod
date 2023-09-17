//
//  discAndTrackSortRule.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/17.
//

import MusicKit

let discAndTrackSortRule: (Song, Song) -> Bool = {
    if let d0 = $0.discNumber, let d1 = $1.discNumber {
        if d0 < d1 {
            return true
        } else if d0 > d1 {
            return false
        }
        // d0 == d1
        else {
            return trackSortRule($0, $1)
        }
    } else if let d0 = $0.discNumber, $1.discNumber == nil {
        return true
    } else if $0.discNumber == nil, let d1 = $1.discNumber {
        return false
    }
    // $0.discNumber == nil && $1.discNumber == nil
    else {
        return trackSortRule($0, $1)
    }
}
