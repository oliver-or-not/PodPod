//
//  BodyStackView.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/07/23.
//

import SwiftUI

struct BodyStackView: View {
    
    @EnvironmentObject var iPodModel: IPodModel
    
    var body: some View {
        HStack {
            ForEach(0..<iPodModel.depth) { i in
                BodyView(key: iPodModel.viewKeyArray[i], rowNum: iPodModel.chosenRowNumArray[i], style: iPodModel.bodyViewStyleDictionary[iPodModel.viewKeyArray[i]], rowData: iPodModel.rowDataDictionary[iPodModel.viewKeyArray[i]])
            }
        }
        .offset(x: DesignSystem.Soft.Dimension.pw * CGFloat(iPodModel.depth - 1) * 0.5)
        .animation(.linear(duration: 0.5), value: iPodModel.depth)
        
    }
}

struct BodyStackView_Previews: PreviewProvider {
    static var previews: some View {
        BodyStackView()
            .environmentObject(IPodModel())
    }
}
