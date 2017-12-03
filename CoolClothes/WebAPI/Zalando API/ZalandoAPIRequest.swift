//
//  ZalandoAPIRequest.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import Foundation
import APIKit

let kZalandoAPIUserAgentHeader   = "User Agent"
let kZalandoAPIPageSizeKey       = "size"
let kZalandoAPIDefaultPageSize   = 25

protocol ZalandoAPIRequest: Request {
    var apiType: ZalandoAPI.APIType { get }
}

extension ZalandoAPIRequest {
    var baseURL: URL {
        return URL(string: "\(kZalandoAPIScheme)://\(kZalandoAPIEndpoint)")!
    }
    
    var queryParameters: [String: Any]? {
        return defaultQueryParameters
    }
    
    var headerFields: [String: String] {
        let fields = [kZalandoAPIUserAgentHeader : WebAPI.userAgent,]
        return fields
    }

    var defaultQueryParameters: [String: Any] {
        return [
            kZalandoAPIPageSizeKey : kZalandoAPIDefaultPageSize,
        ]
    }
}

