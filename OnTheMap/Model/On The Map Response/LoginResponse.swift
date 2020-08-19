//
//  MapResponse.swift
//  PinSample
//
//  Created by Anya Traille on 18/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct LoginResponse: Codable
{
    let account: Account
    let session: Session
}

struct Account: Codable
{
    let registered: Bool
    let key: String
}

struct Session: Codable
{
    let id: String
    let expiration: String
}

extension LoginResponse: LocalizedError
{
    var errorDescription: String?
    {
        return "Invalid username or password"
    }
}
