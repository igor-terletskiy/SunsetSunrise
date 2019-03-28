//
//  RequestManager.swift
//  sunriseSunset sunrise sunset
//
//  Created by Igor on 3/25/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation


class  RequestManager {
    
    static func getSunriseSunsetTime(lat: String, lng: String, completionHandler: @escaping (SunriseSunsetResponse) -> ()) {
        
        let session = URLSession.shared
      
        guard let url = URL(string: "https://api.sunrise-sunset.org/json?lat=\(lat)&lng=\(lng)") else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                print("Data error")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SunriseSunsetResponse.self, from: data)
                completionHandler(response)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

