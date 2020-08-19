//
//  StudentInformation.swift
//  PinSample
//
//  Created by Anya Traille on 19/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentInformation: Codable
{
    // When created
    let createdAt: String
    
    // Student identification
    let firstName: String
    let lastName: String
    
    // Location coordinates
    let latitude: Double
    let longitude: Double
    
    //
    let mapString: String
    
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
