//
//  TMResponse.swift
//  TMAuth
//
//  Created by Jason Tsai on 2017/4/20.
//  Copyright © 2017年 YomStudio. All rights reserved.
//

import Foundation
import ObjectMapper

public class TMResponse: Mappable {
    var status: Int?
    var message: String?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
    }
}
