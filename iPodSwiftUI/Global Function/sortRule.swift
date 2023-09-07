//
//  sortRule.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/04.
//

import Foundation

let sortRule: (String, String) -> Bool = {
    var temp0 = $0.lowercased()
    var temp1 = $1.lowercased()
    
    if temp0.hasPrefix("a ") && temp0.count > 2 {
        temp0 = String(temp0.dropFirst(2))
    } else if temp0.hasPrefix("an ") && temp0.count > 3 {
        temp0 = String(temp0.dropFirst(3))
    } else if temp0.hasPrefix("the ") && temp0.count > 4 {
        temp0 = String(temp0.dropFirst(4))
    }
    
    if temp1.hasPrefix("a ") && temp1.count > 2 {
        temp1 = String(temp1.dropFirst(2))
    } else if temp1.hasPrefix("an ") && temp1.count > 3 {
        temp1 = String(temp1.dropFirst(3))
    } else if temp1.hasPrefix("the ") && temp1.count > 4 {
        temp1 = String(temp1.dropFirst(4))
    }
    
    return temp0 <= temp1
}

