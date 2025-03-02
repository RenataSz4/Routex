import SwiftUI

struct RouteListView: View {
    
    @StateObject private var viewModel = RouteViewModel()
    @State private var showRouteStartView = false
    @State private var selectedRoute: Route?
    

    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.routes) { $route in
                    HStack {
                        NavigationLink(
                            destination: RouteView(route: $route)
                        ) {
                            RouteRowView(route: $route)
                        }
                    }
                    .swipeActions {
                        // Delete
                        Button(role: .destructive) {
                            if let index = viewModel.routes.firstIndex(where: { $0.id == route.id }) {
                                viewModel.routes.remove(at: index)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        // Edit
                        Button {
                            selectedRoute = route
                            
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .navigationTitle("Routes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showRouteStartView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showRouteStartView) {
                RouteStartView(showRouteStartView: $showRouteStartView)
                    .environmentObject(viewModel)
            }
            .sheet(item: $selectedRoute) { route in
                RouteEditView(route: $selectedRoute)
                    .environmentObject(viewModel)
            }

        }
        .environmentObject(viewModel)
    }
}

#Preview {
    RouteListView()
}

