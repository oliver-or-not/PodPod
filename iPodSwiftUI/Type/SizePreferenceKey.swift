//
//  SizePreferenceKey.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/08/31.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
