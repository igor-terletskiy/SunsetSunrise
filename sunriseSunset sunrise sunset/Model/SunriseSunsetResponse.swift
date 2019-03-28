//
//  SimpleStruct.swift
//  sunriseSunset sunrise sunset
//
//  Created by Igor on 3/25/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

struct SunriseSunsetResponse: Codable {
    let results: SunriseSunsetInformation
    let status: String
}

struct SunriseSunsetInformation: Codable {
    let sunrise: String
    let sunset: String
    let solarNoon: String
    let dayLength: String
    let civilTwilightBegin: String
    let civilTwilightEnd: String
    let nauticalTwilightBegin: String
    let nauticalTwilightEnd: String
    let astronomicalTwilightBegin: String
    let astronomicalTwilightEnd: String
    
    private enum CodingKeys: String, CodingKey {
        case sunrise, sunset
        case solarNoon = "solar_noon"
        case dayLength = "day_length"
        case civilTwilightBegin = "civil_twilight_begin"
        case civilTwilightEnd = "civil_twilight_end"
        case nauticalTwilightBegin = "nautical_twilight_begin"
        case nauticalTwilightEnd = "nautical_twilight_end"
        case astronomicalTwilightBegin = "astronomical_twilight_begin"
        case astronomicalTwilightEnd = "astronomical_twilight_end"
    }
}
