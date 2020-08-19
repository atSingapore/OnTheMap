//
//  OnTheMapClient.swift
//  PinSample
//
//  Created by Anya Traille on 18/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class OnTheMapClient {
    
    static var sessionId = ""
    
    struct Auth
    {
        
        static var requestToken = "" // remove?
        static var sessionId = "" // remove?
        static var objectId = ""
        static var uniqueKey = ""
    }
    
    struct UserInfo
    {
        static var firstName = ""
        static var lastName = ""
    }
    
    enum Endpoints
    {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        static let apiKeyParam = ""
        
        case getRequestToken // this should be called login
        case createSessionId
        case logout
        case getUserData
        case get100Students
        case postNewLocation
        
        var stringValue: String
        {
            switch self
            {
            case .getRequestToken:
                return Endpoints.base + "/session"
            case .createSessionId:
                return Endpoints.base + "/session"
            case .logout:
                return Endpoints.base + "/session"
            case .getUserData:
                return Endpoints.base + "/users/\(Auth.uniqueKey)"
            case .get100Students:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .postNewLocation:
                return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL
        {
            return URL(string: stringValue)!
        }
    }
    
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void)
    {
        completion(true, nil)
    }
    
    class func login(userName: String, password: String, completion: @escaping (Bool, Error?) -> Void)
    {
        let body = LoginRequest(udacity: Udacity(username: userName, password: password))
        
        taskForPOSTRequest(url: OnTheMapClient.Endpoints.createSessionId.url, responseType: LoginResponse.self, body: body, toRemove: true) { (response, error) in
            if let response = response
            {
                Auth.uniqueKey = response.account.key
                completion(true, nil)
            } else
            {
                completion(false, error)
            }
        }
    }
    
    class func addLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void)
    {
        let body = LocationRequest(firstName: UserInfo.firstName, lastName: UserInfo.lastName, mapString: mapString, latitude: latitude, longitude: longitude, mediaURL: mediaURL, uniqueKey: Auth.uniqueKey)
        
        taskForPOSTRequest(url: OnTheMapClient.Endpoints.postNewLocation.url, responseType: AddLocationResponse.self, body: body, toRemove: false) { (response, error) in
            if let response = response
            {
                Auth.objectId = response.objectId
                print("student location added")
                completion(true, nil)
            } else
            {
                completion(false, error)
            }
        }
    }
    
    class func removeChars(_ data: Data, toRemove: Bool) -> Data
    {
        if toRemove
        {
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            return newData
        }
        return data
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, toRemove: Bool, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask
    {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else
            {
                print("error, session not working")
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            let decoder = JSONDecoder()
            let newData = removeChars(data, toRemove: toRemove)
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async { completion(responseObject, nil) }
                
            } catch
            {
                
                do
                {
                    let errorResponse = try decoder.decode(OnTheMapResponse.self, from: newData)
                    DispatchQueue.main.async { completion(nil, errorResponse) }
                }
                catch
                {
                    DispatchQueue.main.async { completion(nil, error) }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func createSessionId(completion: @escaping (Bool, Error?) -> Void)
    {
        taskForGETRequest(url: Endpoints.getRequestToken.url, responseType: LoginResponse.self, toRemove: false) {(response, error) in
            if let response = response
            {
                Auth.sessionId = response.session.id
                completion(true, nil) }
            else
            {
                completion(false, nil)
            }
        }
    }
    
    class func getStudentUserData(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData.url, responseType: StudentDataResponse.self, toRemove: true) { (response, error) in
            if let response = response
            {
                UserInfo.firstName = response.firstName!
                UserInfo.lastName = response.lastName!
                completion(true, nil)
            } else
            {
                completion(false, error)
            }
        }
    }
    
    class func getUserInfo(completion: @escaping ([StudentInformation], Error?) -> Void)
    {
        taskForGETRequest(url: Endpoints.get100Students.url, responseType: StudentLocationResponse.self, toRemove: false) { (response, error) in
            
            if let response = response
            {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, toRemove: Bool, completion: @escaping (ResponseType?, Error?) -> Void)
    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else
            {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            let newData = removeChars(data, toRemove: toRemove)
            print(String(data: newData, encoding: .utf8)!)
            
            do
            {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch
            {
                
                do
                {
                    let errorResponse = try decoder.decode(OnTheMapResponse.self, from: newData)
                    
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping () -> Void)
    {
        
        let url = Endpoints.logout.url
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies!
        {
            if cookie.name == "XSRF-TOKEN" {xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie
        {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else
            {
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            completion()
        }
        task.resume()
    }
}
