//
//  PageBodyStackView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/23.
//

import SwiftUI

struct PageBodyStackView: View {
    
    @EnvironmentObject var podObservable: PodObservable
    
    var body: some View {
        
        ZStack {
            Color(.white)
            
            switch podObservable.transitionState {
                case .normal:
                    HStack(spacing: 0) {
                        ForEach(0..<podObservable.frontierPageNum, id: \.self) { _ in
                            DummyPageBodyView()
                        }
                        PageBodyView(isGhost: false)
                            .environmentObject(podObservable)
                        ForEach((podObservable.frontierPageNum + 1)..<StatusModel.maxPageCount, id: \.self) { _ in
                            DummyPageBodyView()
                        }
                    }
                case .goingRight:
                    HStack(spacing: 0) {
                        ForEach(0..<max(0, podObservable.frontierPageNum - 1), id: \.self) { _ in
                            DummyPageBodyView()
                        }
                        PageBodyView(isGhost: true)
                            .environmentObject(podObservable)
                        PageBodyView(isGhost: false)
                            .environmentObject(podObservable)
                        ForEach((podObservable.frontierPageNum + 1)..<StatusModel.maxPageCount, id: \.self) { _ in
                            DummyPageBodyView()
                        }
                    }
                case .goingLeft:
                    HStack(spacing: 0) {
                        ForEach(0..<podObservable.frontierPageNum, id: \.self) { _ in
                            DummyPageBodyView()
                        }
                        PageBodyView(isGhost: false)
                            .environmentObject(podObservable)
                        PageBodyView(isGhost: true)
                            .environmentObject(podObservable)
                        ForEach((podObservable.frontierPageNum + 2)..<StatusModel.maxPageCount, id: \.self) { _ in
                            DummyPageBodyView()
                        }
                    }
            }
        }
        .offset(x: DesignSystem.Soft.Dimension.w * (CGFloat(StatusModel.maxPageCount) * 0.5 - 0.5 - CGFloat(max(0, podObservable.shownPageNum))))
        .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
//        .clipShape(Rectangle())
        .animation(.linear(duration: DesignSystem.Time.slidingAnimationTime), value: podObservable.shownPageNum)
    }
}

struct BodyStackView_Previews: PreviewProvider {
    static var previews: some View {
        PageBodyStackView()
            .environmentObject(PodObservable())
    }
}
