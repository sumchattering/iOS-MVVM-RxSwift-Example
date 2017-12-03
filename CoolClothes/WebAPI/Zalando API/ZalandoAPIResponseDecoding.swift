//
//  ZalandoAPIResponseDecoding.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import Foundation
import APIKit

extension ZalandoAPIRequest where Response: Decodable {
    var dataParser: DataParser {
        return DecodableDataParser()
    }
    
    func response(from object: Any, urlResponse _: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = DateFormatter.iso8601.date(from: dateString) {
                return date
            }
            
            if let date = DateFormatter.iso8601noneMilliSec.date(from: dateString) {
                return date
            }
            
            throw ResponseError.unexpectedObject(object)
        }
        
        return try decoder.decode(ZalandoAPI.Response<Response>.self, from: data).result
    }
}
