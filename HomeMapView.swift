import SwiftUI
import MapKit

struct HomeMapView: View {
    private var locationManager = UserLocationManager()
    
    // Use MapCameraPosition in iOS 17+ instead of binding an MKCoordinateRegion directly.
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 45.4642, longitude: 9.1900),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var showProfile = false

    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: $cameraPosition) {
                    // Replaces showsUserLocation: true
                    UserAnnotation()
                }
                .edgesIgnoringSafeArea(.all)
                .onChange(of: locationManager.lastLocation) {
                    if let loc = locationManager.lastLocation {
                        let region = MKCoordinateRegion(
                            center: loc.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                        cameraPosition = .region(region)
                    }
                }

                VStack {
                    HStack {
                        Button {
                            print("SOS tapped!")
                        } label: {
                            BigCircleButton(icon: "exclamationmark.triangle.fill", color: .red, size: 70)
                        }

                        Spacer()

                        Button {
                            showProfile = true
                        } label: {
                            BigCircleButton(icon: "person.crop.circle", color: .blue, size: 70)
                        }
                    }
                    .padding()

                    Spacer()
                }
            }
            // Use modern navigation API instead of deprecated NavigationLink(isActive:)
            .navigationDestination(isPresented: $showProfile) {
                ProfileView()
            }
        }
    }
}

struct HomeMapView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMapView()
    }
}
