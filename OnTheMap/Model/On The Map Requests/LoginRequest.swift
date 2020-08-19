//
//  LoginRequest.swift
//  PinSample
//
//  Created by Anya Traille on 19/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct LoginRequest: Codable
{
    let udacity: Udacity
}

struct Udacity: Codable
{
    let username: String
    let password: String
}
