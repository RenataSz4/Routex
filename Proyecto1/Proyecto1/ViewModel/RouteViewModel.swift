//
//  Untitled.swift
//  Proyecto1
//
//  Created by CETYS Universidad  on 19/02/25.
//

import Foundation

class RouteViewModel : ObservableObject {
    
    @Published var routes: [Route] = []
    
    func deleteRoute(at indexSet: IndexSet) {
            routes.remove(atOffsets: indexSet)
    }
    
    func updateRoute(updatedRoute: Route) {
        if let index = routes.firstIndex(where: { $0.id == updatedRoute.id }) {
            routes[index] = updatedRoute
        }
    }
    
}

