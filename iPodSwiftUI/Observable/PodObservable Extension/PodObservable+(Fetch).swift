//
//  PodObservable+(Fetch).swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/16.
//

import Foundation

extension PodObservable {
    func fetchAllMedia(networkAccessIsAllowed: Bool) {
        libraryUpdateSymbolState = .loading
        fetchCounter = 0
        videoHandler.fetchFavoriteVideoAssets(networkAccessIsAllowed: networkAccessIsAllowed) {
            DispatchQueue.main.async {
                self.fetchCounter += 1
            }
        }
        photoHandler.fetchFavoritePhotos(networkAccessIsAllowed: networkAccessIsAllowed) {
            DispatchQueue.main.async {
                self.fetchCounter += 1
            }
        }
        musicHandler.requestUpdateLibrary() {
            DispatchQueue.main.async {
                self.fetchCounter += 1
            }
        }
        musicHandler.requestUpdatePlaylists() {
            DispatchQueue.main.async {
                self.fetchCounter += 1
            }
        }
    }
}
