//
//  APIManager.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import Foundation
import Alamofire

let baseUrl = "http://api.doitserver.in.ua/"

public enum APILinks: String {
    
    case create = "create"
    case login = "login"
    case all = "all"
    case gif = "gif"
    case image = "image"
    
    func endpoint() -> String {
        return baseUrl + self.rawValue
    }
    
    func method() -> HTTPMethod {
        var method: HTTPMethod!
        switch self {
        case .all:
            method = .get
        case .create:
            method = .post
        case .gif:
            method = .get
        case .image:
            method = .post
        case .login:
            method = .post
        }
        return method
    }
    
}

typealias responseCompletion = (_ responseObject: Any?, _ success: Bool, _ error: Error?) -> Void

class ApiManager {
    
    public class func request(_ endpoint: APILinks, _ parameters: [String: Any]?, _ completion: @escaping(responseCompletion)) {
        
        let url = endpoint.endpoint()
        var headers: HTTPHeaders = [:]
        let token = loadToken()
        if let token = token {
            if !token.isEmpty {
                headers["token"] = token
            }
        }
  
        if let params = parameters {
            if endpoint == APILinks.create || endpoint == APILinks.image {
                upload(url, endpoint.method(), params, headers, completion)
            } else {
                load(url, endpoint.method(), params, headers, completion)
            }
        } else {
            load(url, endpoint.method(), parameters, headers, completion)
        }
    }
    
    //MARK: - Private
    
    private class func load(_ url: String, _ method: HTTPMethod, _ parameters: [String: Any]?, _ headers: HTTPHeaders, _ completion: @escaping(responseCompletion)) {
         
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) in
        
            var response: Any?
            
            if let responseData = responseObject.value as? [String: Any] {
                response = responseData
            }
            
            if let responseData = responseObject.value as? [Any] {
                response = responseData
            }
            
            if let responseData = response {
                
                if let statusCode = responseObject.response?.statusCode {
                    switch statusCode {
                    case 801:
                        print("No Internet")
                        completion(responseData, false, responseObject.error)
                    case 400:
                        print("ERROR DESCRIPTION")
                        completion(responseData, false, responseObject.error)
                    case 401:
                        print("WRONG PARAMS")
                        completion(responseData, false, responseObject.error)
                    case 500:
                        print("Internal Server Error")
                        completion(responseData, false, responseObject.error)
                    case 200:
                        completion(responseData, true, responseObject.error)
                    default:
                        print("SOMETHING WENT WRONG")
                        completion(responseData, false, responseObject.error)
                    }
                }
            } else {
                print("SOMETHING WENT WRONG")
                let responseData = ["message": responseObject.error?.localizedDescription]
                completion(responseData, false, responseObject.error)
            }
        }
    }
    
    private class func upload(_ url: String, _ method: HTTPMethod, _ parameters: [String: Any], _ headers: HTTPHeaders, _ completion: @escaping(responseCompletion)) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = parameters["avatar"] as? Data {
                multipartFormData.append(data, withName: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            
            if let data = parameters["image"] as? Data {
                multipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64(), to: url, method: method, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let responseData = response.value as? [String: Any]
                    print(response)
                    completion(responseData, true, response.error)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion(nil, false, error)
            }
        }
    }
    
}

extension ApiManager {
    
    //MARK: - Token Methods
    class func saveToken(_ token: String?) {
        UserDefaults.standard.setValue(token, forKey: "token")
    }
    
    class func loadToken() -> String? {
        return UserDefaults.standard.value(forKey: "token") as? String
    }
    
    class func clearToken() {
        UserDefaults.standard.removeObject(forKey: "token")
    }
}
