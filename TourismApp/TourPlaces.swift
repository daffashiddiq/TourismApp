//
//  TourPlaces.swift
//  TourismApp
//
//  Created by Daffashiddiq on 29/05/21.
//

import Foundation

struct TourPlaces:Decodable {
    let error: Bool
    let message: String
    let count: Int
    var places = [Place]()
    
}

struct Place:Decodable {
    let id: Int
    let name: String
    let description: String
    let address: String
    let longitude: Double
    let latitude: Double
    let like: Int
    let image: String
}
