//
//  Untitled.swift
//  Proyecto1
//
//  Created by Renata Sánchez on 01/03/25.
//

import SwiftUI

struct RouteEditView: View {
    @Binding var route: Route?
    @State private var title: String = ""
    @State private var image: UIImage?
    @State private var isImagePickerPresented = false
    @Environment(\.presentationMode) private var presentationMode
    @Binding var showRouteStartView: Bool
    @EnvironmentObject var viewModel: RouteViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
           
                Image(uiImage: image ?? UIImage(systemName: "camera")!)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding()
                    .onTapGesture {
                        isImagePickerPresented.toggle()
                    }

                TextField("Enter route title", text: $title)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)

                Text("Distance: \(route?.distance ?? 0, specifier: "%.2f") km")
                    .font(.title2)
                    .fontWeight(.bold)

                Button(action: {
                    saveChanges()
                }) {
                    Text("Save Changes")
                        .padding()
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                            .fill(.blue)
                            .frame(width: 300)
                        )
                }
                .disabled(title.isEmpty)
                .opacity(title.isEmpty ? 0.3 : 1)
            }
            .navigationTitle("Route Details")
            .padding()
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $image)
            }
        }
        .onAppear {
            if let route = route {
                title = route.title
                image = route.image
            }
        }
    }
    
    private func saveChanges() {
        if var route = route {
            route.title = title
            route.image = image
            
            viewModel.updateRoute(updatedRoute: route)
        }
            
            presentationMode.wrappedValue.dismiss()
            showRouteStartView = false
    }
}

#Preview {
    RouteEditView(route: .constant(Route(
        title: "Rosarito-Tijuana",
        timeStart: Date(),
        timeEnd: Date().addingTimeInterval(14 * 60),
        locationStart: Location(latitude: 32.5332, longitude: -117.0193),
        locationEnd: Location(latitude: 32.6165, longitude: -117.0198),
        distance: 12.45,
        image: nil
    )), showRouteStartView: .constant(false))
}

