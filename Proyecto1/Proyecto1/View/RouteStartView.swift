import SwiftUI
import MapKit

struct RouteStartView: View {
    
    @EnvironmentObject private var viewModel: RouteViewModel
    @StateObject private var locationManager = LocationManager()
    @Binding var showRouteStartView: Bool
    @State private var timeStart: Date?
    @State private var timeEnd: Date?
    @State private var locationStart: Location?
    @State private var locationEnd: Location?
    @State private var currentLocation: Location?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 500)
                    .cornerRadius(20)
                    .padding(20)
                
                // Start Button
                Button {
                    locationManager.requestLocation()
                    locationStart = Location(
                        latitude: locationManager.region.center.latitude,
                        longitude: locationManager.region.center.longitude
                    )
                    timeStart = Date()
                } label: {
                    Text("Start")
                        .padding()
                        .foregroundColor(.green)
                        .font(.title)
                        .fontWeight(.semibold)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                            .fill(.green.opacity(0.2))
                            .frame(width: 300)
                        )
                }
                .disabled(locationStart != nil && timeStart != nil)
                .opacity(locationStart != nil && timeStart != nil ? 0.3 : 1)
                
                NavigationLink(
                    destination: RouteDetailsView(
                        startLocation: locationStart,
                        endLocation: locationEnd,
                        timeStart: timeStart,
                        timeEnd: timeEnd,
                        showRouteStartView: $showRouteStartView
                    ),
                    isActive: .constant(locationEnd != nil && timeEnd != nil)
                ) {
                    Button {
                        locationManager.requestLocation()
                        locationEnd = Location(
                            latitude: locationManager.region.center.latitude,
                            longitude: locationManager.region.center.longitude
                        )
                        timeEnd = Date()
                    } label: {
                        Text("End")
                            .padding()
                            .foregroundColor(.red)
                            .font(.title)
                            .fontWeight(.semibold)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 20,
                                    style: .continuous
                                )
                                .fill(.red.opacity(0.2))
                                .frame(width: 300)
                            )
                    }
                    .disabled(locationStart == nil || timeStart == nil)
                    .opacity(locationStart == nil || timeStart == nil ? 0.3 : 1.0)
                }
            }
            .onChange(of: locationManager.region.center.latitude) { newLatitude in
                updateLocation(latitude: newLatitude, longitude: locationManager.region.center.longitude)
            }
            .onChange(of: locationManager.region.center.longitude) { newLongitude in
                updateLocation(latitude: locationManager.region.center.latitude, longitude: newLongitude)
            }
            .navigationTitle("Route Start")
        }
    }
    
    private func updateLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        currentLocation = Location(latitude: latitude, longitude: longitude)
    }
}

#Preview {
    RouteStartView(showRouteStartView: .constant(false))
}
