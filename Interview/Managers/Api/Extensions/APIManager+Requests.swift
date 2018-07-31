//
//  APIManager+Requests.swift
//  Interview
//
//  Created by Developer on 7/31/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import Foundation
import Alamofire

extension APIManager {
    
    public class func login(email: String, password: String, completion: @escaping (User?, Error?) ->Void) {
        performRequest(route: APIRouter.login(email: email, password: password)) { (userObject: DataResponse<User>) in
            if let error = userObject.error {
                completion(nil, error)
            } else if let user = userObject.result.value {
                saveToken(user.token)
                completion(user, nil)
            } else {
                completion(nil, APIError.somethingWentWrong("on login"))
            }
        }
    }
    
    public class func signUP(username: String?, email: String, password: String, avatar: Data, completion: @escaping (User?, Error?) ->Void) {
        performRequest(route: .create(username: username, email: email, password: password, avatar: avatar)) { (userObject: DataResponse<User>) in
            if let error = userObject.error {
                completion(nil, error)
            } else if let user = userObject.result.value {
                saveToken(user.token)
                completion(user, nil)
            } else {
                completion(nil, APIError.somethingWentWrong("on signup"))
            }
        }
    }
    
    public class func uploadPhoto(image: Data, description: String?, hashtag: String?, latitude: CGFloat, longitude: CGFloat, completion: @escaping (NImage?, Error?) ->Void) {
        performRequest(route: .image(image: image, description: description, hashtag: hashtag, latitude: latitude, longitude: longitude)) { (photoObject: DataResponse<NImage>) in
            if let error = photoObject.error {
                completion(nil, error)
            } else if let photo = photoObject.result.value {
                completion(photo, nil)
            } else {
                completion(nil, APIError.somethingWentWrong("on photo upload"))
            }
        }
    }
    
    public class func loadAllPhotos(completion: @escaping (Gallery?, Error?) ->Void) {
        performRequest(route: .all) { (galleryObject: DataResponse<Gallery>) in
            if let error = galleryObject.error {
                completion(nil, error)
            } else if let gallery = galleryObject.result.value {
                completion(gallery, nil)
            } else {
                completion(nil, APIError.somethingWentWrong("on gallery load"))
            }
        }
    }
    
    public class func loadGif(weather: String?, completion: @escaping (SGif?, Error?) ->Void) {
        performRequest(route: .gif(weather: weather)) { (gifObject: DataResponse<SGif>) in
            if let error = gifObject.error {
                completion(nil, error)
            } else if let gif = gifObject.result.value {
                completion(gif, nil)
            } else {
                completion(nil, APIError.somethingWentWrong("on gif load"))
            }
        }
    }
}
