//
//  DummyPageBodyView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/02.
//

import SwiftUI

struct DummyPageBodyView: View {
    
    var body: some View {
        Color(.white)
        .frame(width: DesignSystem.Soft.Dimension.w, height: DesignSystem.Soft.Dimension.bodyHeight)
    }
}

struct DummyPageBodyView_Previews: PreviewProvider {
    static var previews: some View {
        DummyPageBodyView()
    }
}

