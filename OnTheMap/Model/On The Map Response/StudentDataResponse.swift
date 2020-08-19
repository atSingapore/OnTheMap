//
//  StudentDataResponse.swift
//  PinSample
//
//  Created by Anya Traille on 19/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentDataResponse: Codable
{
    let firstName: String?
    let lastName: String?
    let key: String?
    
    enum CodingKeys: String, CodingKey
    {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
