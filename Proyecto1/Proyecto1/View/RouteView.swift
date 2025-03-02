import SwiftUI
import MapKit

struct RouteView: View {
    @Binding var route: Route
    
    @State private var mapRegion: MKCoordinateRegion
    @State private var routePolyline: MKPolyline?

    init(route: Binding<Route>) {
        _route = route
        
        // Default region is centered on the start location
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        _mapRegion = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: route.wrappedValue.locationStart.latitude, longitude: route.wrappedValue.locationStart.longitude),
            span: span
        ))
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 75) {
                VStack(spacing: 5) {
                    Text(route.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(formattedTime(route.timeStart))
                        .font(.callout)
                        .fontWeight(.regular)
                    
                    Text(formattedDuration(route.timeStart, route.timeEnd))
                        .font(.callout)
                        .fontWeight(.regular)
                }
                
                if let image = route.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .cornerRadius(5)
                } else {
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding(20)
            .background(.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Show the map with the route
            Map(coordinateRegion: $mapRegion, annotationItems: [route.locationStart, route.locationEnd]) { location in
                MapPin(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), tint: .blue)
            }
            .cornerRadius(10)
            .padding(50)
            .frame(height: 450)
            .onAppear {
                calculateRoute()
            }
            
            Text("\(route.distance, specifier: "%.2f") km")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
    
    private func calculateRoute() {
        let startCoordinate = CLLocationCoordinate2D(latitude: route.locationStart.latitude, longitude: route.locationStart.longitude)
        let endCoordinate = CLLocationCoordinate2D(latitude: route.locationEnd.latitude, longitude: route.locationEnd.longitude)
        
        let startPlacemark = MKPlacemark(coordinate: startCoordinate)
        let endPlacemark = MKPlacemark(coordinate: endCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPlacemark)
        request.destination = MKMapItem(placemark: endPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            guard let response = response, error == nil else {
                print("Error calculating directions: \(String(describing: error))")
                return
            }
            
            if let route = response.routes.first {
                self.routePolyline = route.polyline
                self.mapRegion = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: (route.polyline.coordinate.latitude + route.polyline.coordinate.latitude) / 2,
                                                    longitude: (route.polyline.coordinate.longitude + route.polyline.coordinate.longitude) / 2),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                
                let mapView = MKMapView()
                                mapView.addOverlay(route.polyline)
            }
        }
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
    RouteView(route: .constant(Route(
        title: "Rosarito-Tijuana",
        timeStart: Date(),
        timeEnd: Date().addingTimeInterval(14 * 60),
        locationStart: Location(latitude: 32.5332, longitude: -117.0193), 
        locationEnd: Location(latitude: 32.6165, longitude: -117.0198),
        distance: 12.45,
        image: nil
    )))
}
