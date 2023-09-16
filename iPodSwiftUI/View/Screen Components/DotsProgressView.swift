//
//  DotsProgressView.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/17.
//

import SwiftUI

struct DotsProgressView: View {
    
    var brightBack = false
    
    @State var timer: Timer?
    @State var level = 0
    @State var flicker = true
    
    func levelUp() {
        level = (level + 1) % 4
    }
    
    init(brightBack: Bool) {
        self.brightBack = brightBack
    }
    
    var body: some View {
        Group {
            ZStack {
                Color(.red)
                    .opacity(0.0000001)
                    .onAppear {
                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                            levelUp()
                        }
                    }
                    .onDisappear {
                        timer?.invalidate()
                    }
                if brightBack {
                    switch level {
                        case 0:
                            Image(systemName: "ellipsis", variableValue: 0.0)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.black)
                        case 1:
                            Image(systemName: "ellipsis", variableValue: 0.33)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.black)
                        case 2:
                            Image(systemName: "ellipsis", variableValue: 0.66)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.black)
                        case 3:
                            Image(systemName: "ellipsis", variableValue: 1.0)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.black)
                        default:
                            Image(systemName: "ellipsis", variableValue: 1.0)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.black)
                    }
                }
                else {
                    switch level {
                        case 0:
                            Image(systemName: "ellipsis", variableValue: 0.0)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.white)
                        case 1:
                            Image(systemName: "ellipsis", variableValue: 0.33)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.white)
                        case 2:
                            Image(systemName: "ellipsis", variableValue: 0.66)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.white)
                        case 3:
                            Image(systemName: "ellipsis", variableValue: 1.0)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.white)
                        default:
                            Image(systemName: "ellipsis", variableValue: 1.0)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

struct DotsProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            DotsProgressView(brightBack: true)
        }
    }
}
