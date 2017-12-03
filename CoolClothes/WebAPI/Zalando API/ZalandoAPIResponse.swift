//
//  ZalandoAPIResponse.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import Foundation

extension ZalandoAPI {
    struct Response<ResultType: Decodable> {
        enum CodingKeys: String, CodingKey {
            case content
        }
        let content: ResultType
    }
}

extension ZalandoAPI.Response: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(content: try container.decode(ResultType.self, forKey: .content))
    }
}
