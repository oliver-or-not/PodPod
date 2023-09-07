//
//  IPodModel.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/15.
//

import Foundation
import Combine

class IPodModel: ObservableObject {
	
	@Published var depth = 1
	
	// name of screen
	// index of array represents that in the order of view sequence
	@Published var viewKeyArray = ["iPod"] + Array(repeating: "", count: 19)
	
	// number of chosen row in screen
	// index of array represents that in the order of view sequence
	@Published var chosenRowNumArray = Array(repeating: 0, count: 20)
    
    @Published var wheelValue: CGFloat = 0.0
    
    private var cancellables: Set<AnyCancellable> = []
    private var previousWheelValue: CGFloat = 0.0

    init() {
        // Combine을 사용하여 "wheelValue"의 변경을 감시하고, 변경될 때마다 동작 수행
        $wheelValue
            .sink { [weak self] newValue in
                self?.handleWheelValueChange(newValue, previousValue: self?.previousWheelValue ?? 0.0)
                self?.previousWheelValue = newValue // 직전 값 갱신
            }
            .store(in: &cancellables)
    }
    func handleWheelValueChange(_ nv: CGFloat, previousValue pv: CGFloat) {
        if abs(nv - pv) < 10.0 {
            // increasing
            if beInt((nv - 0.01) / 360.0 * 22.0) > beInt((pv - 0.01) / 360.0 * 22.0) {
                if chosenRowNumArray[depth - 1] < (rowDataDictionary[viewKeyArray[depth - 1]]?.count ?? 0) - 1 {
                    chosenRowNumArray[depth - 1] += 1
                }
            }
            // decreasing
            else if beInt(nv / 360.0 * 22.0) < beInt(pv / 360.0 * 22.0) {
                if chosenRowNumArray[depth - 1] > 0 {
                    chosenRowNumArray[depth - 1] -= 1
                }
            }
        }
    }
    func beInt(_ x: CGFloat) -> Int {
        if x >= 0 {
            return Int(x)
        } else {
            return Int(x) - 1
        }
    }
    
    //MARK: - Menu Data
    @Published var bodyViewStyleDictionary: [String: BodyViewStyle] = ["": .empty, "iPod": .list, "music": .list]
    
    @Published var headerTitleDictionary: [String: String] = ["": "", "iPod": "iPod", "music": "음악"]
    
    @Published var rowDataDictionary: [String: [(text: String, key: String, style: RowStyle, isShown: Bool)]] = [
        "iPod": [("음악", "music", .list, true),
                 ("사진", "photo", .list, true),
                 ("비디오", "video", .list, true),
                 ("기타", "else", .list, true),
                 ("설정", "setting", .list, true),
                 ("노래 임의 재생", "musicRandomPlay", .music, true)],
        
        "music": [("재생목록", "playlist", .list, true),
                  ("아티스트", "artist", .list, true),
                  ("앨범", "album", .list, true),
                  ("노래", "song", .list, true),
                  ("Podcast", "podcast", .list, true),
                  ("장르", "genre", .list, true),
                  ("작곡가", "composer", .list, true),
                  ("오디오북", "audioBook", .list, true)]
    ]
}
