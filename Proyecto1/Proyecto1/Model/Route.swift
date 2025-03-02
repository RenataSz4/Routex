//
//  Ruta.swift
//  Proyecto1
//
//  Created by CETYS Universidad  on 19/02/25.
//

import SwiftUI

struct Route: Identifiable, Hashable{
    let id = UUID()
    var title: String
    let timeStart: Date
    let timeEnd: Date
    let locationStart: Location
    let locationEnd: Location
    let distance: Double
    var image: UIImage?
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
