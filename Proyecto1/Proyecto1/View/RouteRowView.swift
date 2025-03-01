//
//  RouteRowView.swift
//  Proyecto1
//
//  Created by CETYS Universidad  on 24/02/25.
//


import SwiftUI
import MapKit

struct RouteRowView: View {
    var route: Route
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(route.title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(formattedTime(route.timeStart))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(formattedDuration(route.timeStart, route.timeEnd))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("\(route.distance, specifier: "%.2f") km")
                    .font(.callout)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            if var image = route.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .cornerRadius(5)
            } else {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
    
    private func formattedDuration(_ start: Date, _ end: Date) -> String {
        let duration = end.timeIntervalSince(start)
        let minutes = Int(duration) / 60
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        if hours > 0 {
            return String(format: "%d hr %d min", hours, remainingMinutes)
        } else {
            return String(format: "%d min", remainingMinutes)
        }
    }
}

#Preview {
    RouteRowView(route: Route(
        title: "Tijuana-Ensenada",
        timeStart: Date(),
        timeEnd: Date().addingTimeInterval(60 * 60),
        locationStart: Location(latitude: 32.5332, longitude: -117.0193),
        locationEnd: Location(latitude: 32.6165, longitude: -117.0585),
        distance: 90.0,
        image: nil
    ))
}
