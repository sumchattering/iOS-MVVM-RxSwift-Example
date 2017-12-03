//
//  ZalandoImage.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import Foundation

struct ZalandoImage {
    let orderNumber: String
    let type: String
    let thumbnailHDURL: String
    let smallURL: String
    let smallHDURL: String
    let mediumURL: String
    let mediumHDURL: String
    let largeURL: String
    let largeHDURL: String
    
    enum CodingKeys: String, CodingKey {
        case orderNumber = "orderNumber"
        case type = "type"
        case thumbnailHDURL = "thumbnailHdUrl"
        case smallURL = "smallUrl"
        case smallHDURL = "smallHdUrl"
        case mediumURL = "mediumUrl"
        case mediumHDURL = "mediumHdUrl"
        case largeURL = "largeUrl"
        case largeHDURL = "largeHdUrl"
    }
}

extension ZalandoImage: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(orderNumber: try container.decode(String.self, forKey: .orderNumber),
                  type: try container.decode(String.self, forKey: .type),
                  thumbnailHDURL: try container.decode(String.self, forKey: .thumbnailHDURL),
                  smallURL: try container.decode(String.self, forKey: .smallURL),
                  smallHDURL: try container.decode(String.self, forKey: .smallHDURL),
                  mediumURL: try container.decode(String.self, forKey: .mediumURL),
                  mediumHDURL: try container.decode(String.self, forKey: .mediumHDURL),
                  largeURL: try container.decode(String.self, forKey: .largeURL),
                  largeHDURL: try container.decode(String.self, forKey: .largeHDURL))
    }
}
