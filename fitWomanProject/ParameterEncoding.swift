//
//  ParameterEncoding.swift
//  fitWomanProject
//
//  Created by marwa on 26/11/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import Foundation
extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
