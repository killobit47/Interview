//
//  APIManager+Routes.swift
//  Interview
//
//  Created by Developer on 7/31/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import Foundation
import CoreGraphics
import Alamofire

let baseUrl = "http://api.doitserver.in.ua/"

public enum APIRouter {
    case create(username: String?, email: String, password: String, avatar: Data)
    case login(email: String, password: String)
    case all
    case gif(weather: String?)
    case image(image: Data, description: String?, hashtag: String?, latitude: CGFloat, longitude: CGFloat)
    
    var path: String {
        switch self {
        case .create:
            return "create"
        case .all:
            return "all"
        case .gif(let weather):
            return "gif?_format=json&weather=\(weather ?? "")"
        case .image:
            return "image"
        case .login:
            return "login"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .create(let username, let  email, let  password, let avatar):
            return ["username": username ?? "", "email": email, "password": password, "avatar": avatar]
        case .image(let image, let description, let hashtag, let latitude, let longitude):
            return ["image": image, "description": description ?? "", "hashtag": hashtag ?? "", "latitude": latitude, "longitude": longitude]
        case .login(let email, let password):
            return ["email": email, "password": password]
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .all, .gif:
            return .get
        case .create, .image, .login:
            return .post
        }
    }
    
    var endpoint: String {
        return baseUrl + path
    }
}
