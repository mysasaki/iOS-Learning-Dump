//
//  ContentView.swift
//  BucketList
//
//  Created by Mylla Sasaki on 21/05/26.
//

import SwiftUI
import MapKit

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            Button(viewModel.standardMode ? "Hybrid Mode" : "Standard Mode") {
                viewModel.standardMode.toggle()
            }
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
            
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Button {
                                viewModel.selectedPlace = location
                                } label: {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 30, height: 30)
                                        .background(.white)
                                        .clipShape(.circle)
                                }
                        }
                    }
                }
                    .mapStyle(viewModel.standardMode ? .standard : .hybrid)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
            }
        }
        else {
            Button("Unlock places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert("Authentication error", isPresented: $viewModel.showAuthError) {
                    Button("Ok", role: .cancel) {}
                } message: {
                    Text("Error while authenticating. Please try again.")
                }
        }
    }
}

#Preview {
    ContentView()
}
