//
//  Data+Extensions.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import Foundation

extension Data {
    func utf8String() -> String? {
        return String(data: self, encoding:.utf8)
    }
}
