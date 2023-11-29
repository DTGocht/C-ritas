//
//  Mapa.swift
//  RetoPruebas
//
//  Created by Jimena Gallegos on 19/10/23.
//

import SwiftUI
import MapKit

struct City: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct Mapa: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.644763, longitude: -100.285844), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    
    let annotations = [
        City(name: "Ubi", coordinate: CLLocationCoordinate2D(latitude: 25.644763, longitude: -100.285844))
    ]
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: annotations) {
            MapMarker(coordinate: $0.coordinate)
        }
        .frame(width: 100, height: 100)
        .cornerRadius(10)
    }
}

struct Mapa_Previews: PreviewProvider {
    static var previews: some View {
        Mapa()
    }
}
