import Foundation
import CoreLocation
import Combine
import Amplify

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isDiscoverModeOn: Bool = false {
        didSet {
            if isDiscoverModeOn {
                
                print("Discover Mode ON")
                checkIfLocationServicesIsEnabled()
            } else {
                print("Discover Mode OFF")
                stopLocationUpdates()
            }
        }
    }
    private var locationManager: CLLocationManager?
    private var locationUpdateTimer: AnyCancellable?
    
//    override init() {
//        super.init()
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//    }
    
    func requestLocationPermissions() {
        print("Requesting Permissions")
//        locationManager?.re
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
    }
    
    func startLocationUpdates() {
        print("Started Location Updates")
        locationManager?.startUpdatingLocation()
        print("Called Schedule Location Updates")
        scheduleLocationUpdates()
    }
    
    func stopLocationUpdates() {
        locationManager?.stopUpdatingLocation()
        locationUpdateTimer?.cancel()
    }
    
    private func scheduleLocationUpdates() {
        locationUpdateTimer = Timer.publish(every: 10, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                print("called upload current location function")
                self?.uploadCurrentLocation()
            }
    }
    
    private func uploadCurrentLocation() {
        guard let location = locationManager?.location else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("Got the location \(latitude), \(longitude)")
        // Replace with actual DynamoDB uploading logic
//        uploadLocationToDynamoDB(latitude: latitude, longitude: longitude)
    }
    
    private func uploadLocationToDynamoDB(latitude: Double, longitude: Double) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        
        let location = Location(id: UUID().uuidString, userId: userId, latitude: latitude, longitude: longitude, timestamp: .now())
        
//        Amplify.DataStore.save(location) { result in
//            switch result {
//            case .success:
//                print("Location saved successfully")
//            case .failure(let error):
//                print("Failed to save location: \(error)")
//            }
//        }
    }
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        }else{
            print("Enable location services")
        }
    }
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else {return}
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("Not determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Restricted")
        case .denied:
            print("You have denied, go to app settings and enable it")
        case .authorizedAlways:
            print("Authorized always")
        case .authorizedWhenInUse:
            print("Authorized when in use")
        case .authorized:
            print("Authorized")
        @unknown default:
            break
        }
    }
}
extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if (status == .authorizedAlways || status == .authorizedWhenInUse) && isDiscoverModeOn {
            checkLocationAuthorization()
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // Send location to DynamoDB and Redis
        print("Updated location: \(location)")
    }
}
