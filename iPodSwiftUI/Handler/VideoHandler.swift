//
//  VideoHandler.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/04.
//

import Photos
import UIKit
import AVKit
import AVFoundation

final class VideoHandler {
    
    static let shared = VideoHandler()
    
    var player: AVPlayer = AVPlayer()
    
    var videoIndex: Int?
    
    private init() {}

    func fetchFavoriteVideoAssets(completion: @escaping () -> Void) {
        DataModel.shared.favoriteVideoArray = []
        DataModel.shared.favoriteVideoThumbnailArray = []
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        
        let resultCount = fetchResult.count
        
        var asyncCounter = 0
        var tempThumbnailArray: [UIImage?] = Array(repeating: nil, count: resultCount)
        var tempVideoArray: [PHAsset?] = Array(repeating: nil, count: resultCount)

        fetchResult.enumerateObjects { asset, index, _ in
            // getUIImage completion starts in order;  but works concurrently.
            // need to do countings below to preserve the order of photos
            self.getUIImage(for: asset) { image in
                if let image = image {
                    tempThumbnailArray[index] = image
                    tempVideoArray[index] = asset
                    asyncCounter += 1
                } else {
                    asyncCounter += 1
                }

                if asyncCounter == resultCount {
                    DataModel.shared.favoriteVideoThumbnailArray = tempThumbnailArray.compactMap { $0 }
                    DataModel.shared.favoriteVideoArray = tempVideoArray.compactMap { $0 }
                    DataModel.shared.favoriteVideoRatioArray = DataModel.shared.favoriteVideoThumbnailArray.map { Float($0.size.width) / Float($0.size.height) }
                    completion()
                }
            }
        }
    }

    func getUIImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default()
            .requestImage(for: asset, targetSize: CGSize(width: 400, height: 400), contentMode: .aspectFit, options: options) { image, _ in
                if let image {
                    if image.size.width >= 300 || image.size.height >= 300 {
                        completion(image)
                        return
                    }
                    // ignore low-resolution temporary image
                    else {
                        _ = 0
                        return
                    }
                } else {
                    completion(nil)
                    return
                }
            }
    }
    
    func play(_ asset: PHAsset) {
        MusicHandler.shared.virtuallyStopped = true
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
            if let avAsset {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print("VideoHandler | play() | error setting session: \(error.localizedDescription)")
                }
                let playerItem = AVPlayerItem(asset: avAsset)
                let player = AVPlayer(playerItem: playerItem)
                player.isMuted = false
                player.preventsDisplaySleepDuringVideoPlayback = true
                self.player = player
                self.player.play()
            }
            print("avAsset nil")
        }
    }
    
    func pause() {
        self.player.pause()
    }
    
    func clearPlayer() {
        player.replaceCurrentItem(with: nil)
    }
    
    func restart() {
        player.play()
    }
    
    func seekToBeginning() {
        Task {
            player.seek(to: CMTime(value: 0, timescale: 600))
        }
    }
    
    func playNext() {
        let videoCount = DataModel.shared.favoriteVideoArray.count
        if videoCount > 0 {
            if let videoIndex {
                clearPlayer()
                if videoIndex < videoCount - 1 {
                    self.videoIndex = videoIndex + 1
                    play(DataModel.shared.favoriteVideoArray[self.videoIndex!])
                } else {
                    self.videoIndex = 0
                    play(DataModel.shared.favoriteVideoArray[self.videoIndex!])
                }
            }
        }
    }
    
    func playPrev() {
        let videoCount = DataModel.shared.favoriteVideoArray.count
        if videoCount > 0 {
            if let videoIndex {
                clearPlayer()
                if videoIndex > 0 {
                    self.videoIndex = videoIndex - 1
                    play(DataModel.shared.favoriteVideoArray[self.videoIndex!])
                } else {
                    self.videoIndex = videoCount - 1
                    play(DataModel.shared.favoriteVideoArray[self.videoIndex!])
                }
            }
        }
    }
    
    func seek(to seconds: CGFloat) {
        Task {
                player.seek(to: CMTime(value: CMTimeValue(Double(seconds * 600)), timescale: 600))
        }
    }
    
    func getPlayerState() -> VideoRealPlayingState {
        if player.currentItem == nil {
            return .stopped
        } else {
            if player.timeControlStatus == .playing {
                return .playing
            } else {
                return .paused
            }
        }
    }
}

