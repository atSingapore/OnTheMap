//
//  ErrorResponse.swift
//  PinSample
//
//  Created by Anya Traille on 24/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class OnTheMapResponse: Codable, Error
{
    
    let status: Int
    let message: String
    
    enum CodingKeys: String, CodingKey
    {
        case status = "status"
        case message = "error"
    }
}

extension OnTheMapResponse: LocalizedError
{
    var errorDescription: String?
    {
        return message
    }
}
