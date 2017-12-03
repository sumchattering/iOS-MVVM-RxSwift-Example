//
//  ZalandoArticle.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import Foundation

struct ZalandoArticle {
    let articleID: String
    let modelID: String
    let name: String
    let color: String
    let available: Bool
    let season: String
    let seasonYear: String
    let activationDate: Date
    let images: [ZalandoImage]
    
    enum CodingKeys: String, CodingKey {
        case articleID = "id"
        case modelID = "modelId"
        case name = "name"
        case color = "color"
        case available = "available"
        case season = "season"
        case seasonYear = "seasonYear"
        case activationDate = "activationDate"
        case media = "media"
    }
    
    enum MediaKeys: String, CodingKey {
        case images
    }
}

extension ZalandoArticle: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaContainer = try container.nestedContainer(keyedBy: MediaKeys.self, forKey: .media)
        
        self.init(articleID: try container.decode(String.self, forKey: .articleID),
                  modelID: try container.decode(String.self, forKey: .modelID),
                  name: try container.decode(String.self, forKey: .name),
                  color: try container.decode(String.self, forKey: .color),
                  available: try container.decode(Bool.self, forKey: .available),
                  season: try container.decode(String.self, forKey: .season),
                  seasonYear: try container.decode(String.self, forKey: .seasonYear),
                  activationDate: try container.decode(Date.self, forKey: .activationDate),
                  images: try mediaContainer.decode(Array.self, forKey: .images))
    }
}
