//
//  ApiResource.swift
//  sunriseSunset sunrise sunset
//
//  Created by Igor on 3/25/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

protocol ApiResource {
    associatedtype Model
    var methodPath: String { get } // the methodPath property it the path of the resource in the URL, for example, /questions.
    func makeModel(serialization: Serialization) -> Model
}

extension ApiResource {
    var url: URL {
        let baseUrl = "https://api.sunrise-sunset.org/json?/"
        let lat = "lat="
        let lng = "lng="
        
        let url = baseUrl + lat + "" + "&" + lng + ""
        return URL(string: url)!
    }
    
    /*
     In a real app, these would likely need to change according to the resource we want to access. So they would have to be requirements in the protocol like the methodPath property, instead of constants.
     
     There is still some functionality all the resources share.
     */
    
    func makeModel(data: Data) -> [Model]? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return nil
        }
        guard let jsonSerialization = json as? Serialization else {
            return nil
        }
        let wrapper = ApiWrapper(serialization: jsonSerialization)
        return wrapper.items.map(makeModel(serialization:))
    }
}
