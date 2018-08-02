//
//  Models.swift
//  Interview
//
//  Created by Developer on 7/31/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import Foundation
import CoreGraphics



struct User: Codable {
    let token: String?
    let avatar: String?
    let error: String?
    let errors: [String]?
}

struct Gallery: Codable {
    let gifs: [GGif]?
    let images: [GImage]?
    let error: String?
    let errors: [String]?
    
    enum CodingKeys: String, CodingKey {
        case gifs = "gif"
        case images
        case error
        case errors
    }
}

struct GGif: Codable {
    let id: Int
    let weather: String
    let path: String
}

struct GImage: Codable {
    let id: Int
    let description: String
    let hashtag: String
    let parameters: GIParameters
    let smallImagePath: String
    let bigImagePath: String
}

struct GIParameters: Codable {
    let longitude: CGFloat
    let latitude: CGFloat
    let address: String?
    let weather: String?
}

struct SGif: Codable {
    let gif: String?
    let error: String?
    let errors: [String]?
}

struct NImage: Codable {
    let parameters: NIParameters?
    
    let smallImage: String?
    let bigImage: String?
    let error: String?
    let errors: [String]?
}

struct NIParameters: Codable {
    let address: String?
    let weather: String?
}

