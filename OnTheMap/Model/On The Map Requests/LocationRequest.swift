//
//  LocationRequest.swift
//  PinSample
//
//  Created by Anya Traille on 25/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct LocationRequest: Codable
{
    let firstName: String
    let lastName: String
    let mapString: String
    let latitude: Double
    let longitude: Double
    let mediaURL: String
    let uniqueKey: String
}
