//
//  LocalAI.swift
//  AIChats
//
//  Created by sinduke on 11/12/25.
//

@preconcurrency import FoundationModels
import Foundation
import Playgrounds

#Playground("LocalAI") {
    let seccion = LanguageModelSession()
    let prompt = "What are the colors of the rainbow?"
    
    Task {
        let response = try await seccion.respond(to: prompt)
        print(prompt)
        print(response)
    }
}

import MapKit

#Playground("MapKit") {
    // Golden Gate Park
    let latitude = 37.768552
    let longitude = -122.481616
    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
}
