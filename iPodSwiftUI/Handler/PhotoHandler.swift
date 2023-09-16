//
//  PhotoHandler.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/25.
//

import SwiftUI
import Photos

final class PhotoHandler {
    
    static let shared = PhotoHandler()
    
    private init() {}

    func fetchFavoritePhotos(networkAccessIsAllowed: Bool, completion: @escaping () -> Void) {
        DataModel.shared.favoritePhotoArray = []
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        let resultCount = fetchResult.count
        
        guard resultCount > 0 else {
            DataModel.shared.favoritePhotoArray = []
            completion()
            return
        }
        
        var asyncCounter = 0
        var tempPhotoArray: [UIImage?] = Array(repeating: nil, count: resultCount)

        fetchResult.enumerateObjects { asset, index, _ in
            // getUIImage completion starts in order;  but works concurrently.
            // need to do countings below to preserve the order of photos
            self.getUIImage(for: asset, networkAccessIsAllowed: networkAccessIsAllowed) { image in
                if let image = image {
                    tempPhotoArray[index] = image
                    asyncCounter += 1
                } else {
                    asyncCounter += 1
                }

                if asyncCounter == resultCount {
                    DataModel.shared.favoritePhotoArray = tempPhotoArray.compactMap { $0 }
                    completion()
                }
            }
        }
    }

    func getUIImage(for asset: PHAsset, networkAccessIsAllowed: Bool, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = networkAccessIsAllowed
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        PHImageManager.default()
            .requestImage(for: asset, targetSize: CGSize(width: 800, height: 800), contentMode: .aspectFit, options: options) { image, _ in
                if let image {
                        completion(image)
                        return
                } else {
                    completion(nil)
                    return
                }
            }
    }
}
