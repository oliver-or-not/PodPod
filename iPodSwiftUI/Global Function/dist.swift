//
//  dist.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/24.
//

import Foundation
import UIKit
import SwiftUI

func dist (_ a: CGPoint, _ b: CGPoint) -> CGFloat {
	return sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y))
}
