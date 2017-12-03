//
//  ZalandoAPI.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import Foundation

let kZalandoAPIScheme            = "https"
let kZalandoAPIEndpoint          = "api.zalando.com"

final class ZalandoAPI: WebAPI {
    enum APIType {
        case `public`
        case `private`
    }
}
