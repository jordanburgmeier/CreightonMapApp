//
//  mapTab.swift
//  draftCSC599
//
//  Created by Jordan Burgmeier on 11/2/20.
//  Copyright © 2020 Jordan Burgmeier. All rights reserved.
//

import Foundation

import UIKit
import MapKit

//model to add in locations for buildings/events
struct Location {
    var name: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
}

@available(iOS 13.0, *)
class mapTab: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, HomeModelProtocol {
    
    //variable locationManager
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    var feedItems: NSArray = NSArray()
    var selectedLocation : LocationModel = LocationModel()
    
    let listTableView = UITableView(frame: CGRect(
    x: 0, y: 0, width: 500, height: 200))
    
    // each location should be listed here for events w/ latitude and longitude
    let locations = [
        Location(name: "Swanson Residence Hall", latitude: 41.264292, longitude: -95.947964),
        Location(name: "Deglman Residence Hall", latitude: 41.264550, longitude: -95.947219),
        Location(name: "Brandeis Dining Hall", latitude: 53.4308, longitude: -2.96096),
        Location(name: "Kiewit Fitness Center", latitude: 41.264314, longitude: -95.948444),
        Location(name: "Skutt Student Center", latitude: 41.264452, longitude: -95.949571),
        Location(name: "Kiewit Residence Hall", latitude: 41.264251, longitude: -95.950419),
        Location(name: "Gallagher Residence Hall", latitude: 41.264491, longitude: -95.951119),
        Location(name: "St. John's", latitude: 41.265335, longitude: -95.948337),
        Location(name: "Reinert Alumni Library", latitude: 41.265280, longitude: -95.949032),
        Location(name: "Hitchcock Communication for the Arts", latitude: 41.265206, longitude: -95.949887),
        Location(name: "Dowling Hall", latitude: 41.265164, longitude: -95.950582),
        Location(name: "Rigge Science Building", latitude: 41.265743, longitude: -95.950482),
        Location(name: "Creighton Hall", latitude: 41.264491, longitude: -95.951119),
        Location(name: "Jesuit Gardens", latitude: 41.265873, longitude: -95.947804),
        Location(name: "Criss I", latitude: 41.265824, longitude: -95.951106),
        Location(name: "Criss II & III", latitude: 41.266445, longitude: -95.950940),
        Location(name: "Hixson-Lied Science Building", latitude: 41.266202, longitude: -95.950303),
        Location(name: "Eppley Hall", latitude: 41.265952, longitude: -95.950056),
        Location(name: "Old Gym", latitude: 41.266554, longitude: -95.948245),
        Location(name: "Markoe Hall", latitude: 41.266712, longitude: -95.948673),
        Location(name: "McGloin Residence Hall", latitude: 41.265007, longitude: -95.945679),
        Location(name: "Lied Education Center for the Arts", latitude: 41.264249, longitude: -95.945744),
        Location(name: "Creighton Ahmanson School of Law", latitude: 41.264394, longitude: -95.944392),
        Location(name: "Harper Center", latitude: 41.265015, longitude: -95.943491),
        Location(name: "Davis Residence Hall", latitude: 41.266366, longitude: -95.943094),
        Location(name: "Opus Residence Hall", latitude: 41.265003, longitude: -95.942069),
        Location(name: "Championship Center", latitude: 41.265557, longitude: -95.940754),
        Location(name: "Morrison Stadium", latitude: 41.264876, longitude: -95.939389),
        Location(name: "DJ Sokol Arena", latitude: 41.266130, longitude: -95.940674),
        Location(name: "Ryan Athletics Center", latitude: 41.266108, longitude: -95.940274),
        Location(name: "Rasmussen Fitness Center", latitude: 41.266122, longitude: -95.939166),
        Location(name: "Kenefick Residence Hall", latitude: 41.262409, longitude: -95.942712),
        Location(name: "Heider Residence Hall", latitude: 41.261965, longitude: -95.945254)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        checkLocationServices()
        fetchLocationsOnMap(locations)
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        
        constrainMap()
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
            let alert = UIAlertController(title: "Your Location Will Not Be Displayed", message: "Turn on Location Services in Settings or Current Location will not be displayed.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler:
                { action in
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            }))
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

            self.present(alert, animated: true)
        }
    }
    
    
    // checks to see if user has authorized permission for location use
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            
        // For these case, you need to show a pop-up telling users what's up and how to turn on permission if needed
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
    func fetchLocationsOnMap(_ locations: [Location]) {
        for location in locations {
            let annotations = MKPointAnnotation()
            annotations.title = location.name
            annotations.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(annotations)
        }
    }
    
    func constrainMap() {
        let initialLocation = CLLocation(latitude: 41.265357, longitude: -95.944885)
        //Sets the 2d scrolling constraints, zoom levels
        let rectBounds = MKMapRect(origin: MKMapPoint((CLLocationCoordinate2D(latitude: 41.266023, longitude: -95.951263))),size: MKMapSize(width: 9000,height: 3000))
        mapView.centerToLocation(initialLocation)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 200, // Minimum zoom value
            maxCenterCoordinateDistance: 5000) // Max zoom value
        mapView.cameraBoundary = MKMapView.CameraBoundary(mapRect: rectBounds)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Creates annotation for user location
        if annotation.isEqual(mapView.userLocation) {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
            annotationView.markerTintColor = UIColor.white
            annotationView.glyphImage = UIImage(named:"userPin")
            annotationView.glyphTintColor = UIColor(red: (149/255), green: (210/255), blue: (243/255), alpha: 1.0)
            return annotationView
        }
        // Creates annotations for all locations, has detail button to open table
        else {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
            annotationView.markerTintColor = UIColor(red: (149/255), green: (210/255), blue: (243/255), alpha: 1.0)
            annotationView.glyphImage = UIImage(named: "pinLogo")
            /* we can try to set can show callout false if there are no events for the week
             if {
                annotationView.canShowCallout = false
             }
             else {
                annotationView.canShowCallout = true
             }*/
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            annotationView.calloutOffset = CGPoint(x: -5, y: 5)
            
            listTableView.delegate = self
            listTableView.dataSource = self
            
            /*let rect = CGRect(
                x: 0, y: 0, width: 500, height: 200)
            */
            let rightButton = UIButton(type: .detailDisclosure)
            //rightButton.addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
            annotationView.rightCalloutAccessoryView = rightButton
            //annotationView.detailCalloutAccessoryView = listTableView
            return annotationView
        }
    }
    
    @IBAction func segmentedControlAction(sender: UISegmentedControl!) {
        switch (sender.selectedSegmentIndex) {
            case 0:
                mapView.mapType = .mutedStandard
            case 1:
                mapView.mapType = .satellite
            default:
                mapView.mapType = .mutedStandard
        }
    }
    
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        self.listTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return feedItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "eventCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item: LocationModel = feedItems[indexPath.row] as! LocationModel
        // Get references to labels of cell
        myCell.textLabel!.text = item.event
        
        return myCell
    }
}
private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 700
        ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
