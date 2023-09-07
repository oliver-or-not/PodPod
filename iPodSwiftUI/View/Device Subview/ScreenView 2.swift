//
//  ScreenView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/17.
//

import SwiftUI

struct ScreenView: View {
	@EnvironmentObject var iPodModel: IPodModel
	
    var body: some View {
		ZStack {
			Rectangle()
				.foregroundColor(.white)
            VStack(spacing: 0) {
                HeaderView(title: iPodModel.headerTitleDictionary[iPodModel.viewKeyArray[iPodModel.depth - 1]] ?? "")
				BodyStackView()
					.environmentObject(iPodModel)
			}
		}
		.frame(width: DesignSystem.Hard.Dimension.iPodScreenWidth, height: DesignSystem.Hard.Dimension.iPodScreenHeight)
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
			.environmentObject(IPodModel())
    }
}
