//
//  APIManager.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire

enum APIError: Error {
    case somethingWentWrong(String)
    
    var localizedDescription: String {
        get {
            var locDesc = "Something went wrong "
            switch self {
            case .somethingWentWrong(let descriptions):
                locDesc += descriptions
            }
            return locDesc
        }
    }
}

class APIManager {
    
    class func performRequest<T: Decodable>(route: APIRouter, _ completion: @escaping((DataResponse<T>) -> Void)) {
        
        let url = route.endpoint
        var headers: HTTPHeaders = [:]
        let token = loadToken()
        if let token = token {
            if !token.isEmpty {
                headers["token"] = token
            }
        }
        if let params = route.parameters {
            switch route {
            case .all, .gif, .login:
                load(url, route.method, params, headers, completion)
            case .create, .image:
                upload(url, route.method, params, headers, completion)
            }
        } else {
            load(url, route.method, route.parameters, headers, completion)
        }
    }
    
    //MARK: - Private
    
    private class func load<T: Decodable>(_ url: String, _ method: HTTPMethod, _ parameters: [String: Any]?, _ headers: HTTPHeaders, _ completion: @escaping((DataResponse<T>) -> Void)) {
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodableObject(completionHandler: completion).responseJSON { (responseObject) in
            if let statusCode = responseObject.response?.statusCode, statusCode == 403 {
                RoutManager.shared.lounchSplashView()
            }
        }
    }
    
    private class func upload<T: Decodable>(_ url: String, _ method: HTTPMethod, _ parameters: [String: Any], _ headers: HTTPHeaders, _ completion: @escaping((DataResponse<T>) -> Void)) {
       
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
                upload.responseDecodableObject(completionHandler: completion)
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { (responseObject) in
                    if let statusCode = responseObject.response?.statusCode, statusCode == 403 {
                        RoutManager.shared.lounchSplashView()
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
        }
    }
}
