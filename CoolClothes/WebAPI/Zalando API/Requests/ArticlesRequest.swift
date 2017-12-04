//
//  ArticlesRequest.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import Foundation
import APIKit

extension ZalandoAPI {
    struct ArticlesRequest: ZalandoAPIRequest {
        typealias Response = [ZalandoArticle]
        
        let apiType: ZalandoAPI.APIType = .public
        let method: HTTPMethod = .get
        let path: String = "/articles"
        var query: String? = nil
        
        var queryParameters: [String: Any]? {
            if let query = query {
                return ["query":query]
            }
            return nil
        }
    }
}
