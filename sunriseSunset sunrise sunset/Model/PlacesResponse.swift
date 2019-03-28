//
//  File.swift
//  sunriseSunset sunrise sunset
//
//  Created by Igor on 3/26/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation


struct PlacesResponse: Codable {
    let htmlAttributions: [String]
    let results: [PlacesInformation]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case htmlAttributions = "html_attributions"
        case results, status
    }
}

struct PlacesInformation: Codable {
    let formattedAddress: String
    let geometry: Geometry
    let icon: String
    let id, name: String
    let photos: [Photo]
    let placeID, reference: String
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case geometry, icon, id, name, photos
        case placeID = "place_id"
        case reference, types
    }
}

struct Geometry: Codable {
    let location: Location
    let viewport: Viewport
}

struct Location: Codable {
    let lat, lng: Double
}

struct Viewport: Codable {
    let northeast, southwest: Location
}

struct Photo: Codable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}
