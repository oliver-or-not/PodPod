//
//  PHAsset+.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/04.
//

import Photos

extension PHAsset {
    var localURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(self.localIdentifier)
        return fileURL
    }
}
