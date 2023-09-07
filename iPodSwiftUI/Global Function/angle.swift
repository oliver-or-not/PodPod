//
//  angle.swift
//  iPodSwiftUI
//
//  Created by Wonil Lee on 2023/06/24.
//

import Foundation

func angle(of point: CGPoint, from origin: CGPoint) -> CGFloat {
	// returns a value in 0 <= ... < 360.0
	// note that y gets bigger when a point goes down in screen
	// note that angle gets bigger when it goes clockwise
	// example: angle(of: (10, 0), from: (0, 0)) = 0.0
	// *   (10, 0) is an abbreviation of CGPoint(x: 10, y: 0)
	// *   (0, 0) is an abbreviation of CGPoint(x: 0, y: 0)
	// example: angle(of: (0, 10), from: (0, 0)) = 90.0
	// example: angle(of: (-10, 0), from: (0, 0)) = 180.0
	
	let x: Double = Double(point.x - origin.x)
	let y: Double = Double(point.y - origin.y)
    let d: Double = dist(point, origin)
	
	var radianAngle: CGFloat = 0.0
    
    if x == 0 && y == 0 {
//        mathematically wrong but fine for our use
        radianAngle = CGFloat(0.0)
    } else if y >= 0 {
        radianAngle = CGFloat(acos(x/d))
    } else {
        radianAngle = 2.0 * CGFloat.pi - CGFloat(acos(x/d))
    }
	
//	if x > 0 && y == 0 {
//		radianAngle = CGFloat(0.0)
//	}
//
//	else if x > 0 && y > 0 {
//		radianAngle = CGFloat(atan(y/x))
//	}
//
//	else if x == 0 && y > 0 {
//		radianAngle = CGFloat.pi / 2
//	}
//
//	else if x < 0 && y > 0 {
//		radianAngle = CGFloat(atan(y/x)) + CGFloat.pi
//	}
//
//	else if x < 0 && y == 0 {
//		radianAngle = CGFloat.pi
//	}
//
//	else if x < 0 && y < 0 {
//		radianAngle = CGFloat(atan(y/x)) + CGFloat.pi
//	}
//
//	else if x == 0 && y < 0 {
//		radianAngle = CGFloat.pi * 3 / 2
//	}
//
//	else if x > 0 && y < 0 {
//		radianAngle = CGFloat(atan(y/x)) + CGFloat.pi * 2
//	}
//
//	else if x == 0 && y == 0 {
//		// mathematically wrong but fine for our use
//		radianAngle = CGFloat(0.0)
//	}
	
	return radianAngle * 180.0 / CGFloat.pi
	
	
}
