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
    let token: String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case token
        case avatar
    }
}

struct Gallery: Codable {
    let gifs: [GGif]
    let images: [GImage]
    
    enum CodingKeys: String, CodingKey {
        case gifs = "gif"
        case images
    }
}

struct GImage: Codable {
    let id: Int
    let description: String
    let hashtag: String
    let parameters: GIParameters
    let smallImagePath: String
    let bigImagePath: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case hashtag
        case parameters
        case smallImagePath
        case bigImagePath
    }
}

struct GIParameters: Codable {
    let longitude: CGFloat
    let latitude: CGFloat
    let address: String?
    let weather: String
    
}

struct GGif: Codable {
    let id: Int
    let weather: String
    let path: String
}

struct SGif: Codable {
    let gif: String
}

struct NImage: Codable {
    let parameters: NIParameters
    
    let smallImage: String
    let bigImage: String
}

struct NIParameters: Codable {
    let address: String
    let weather: String
}

