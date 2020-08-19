//
//  FindLocation.swift
//  PinSample
//
//  Created by Anya Traille on 25/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreLocation

class FindLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.mapView.delegate = self
    }
    
    var mapString: String!
    var mediaURLString: String!
    var geoLocation: CLLocationCoordinate2D!
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        annotateMap()
    }
    
    @IBAction func submitLocation(_sender: Any)
    {
        OnTheMapClient.addLocation(mapString: mapString, mediaURL: mediaURLString, latitude: geoLocation.latitude, longitude: geoLocation.longitude, completion: handleAddLocationResponse(success:error:))
    }
    
    func handleAddLocationResponse(success: Bool, error: Error?)
    {
        if success
        {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } else
        {
            self.postLocationFailedAlert(message: error?.localizedDescription ?? "")
        }
    }
    
    func postLocationFailedAlert(message: String)
     {
         let alertVC = UIAlertController(title: "Location Error", message: message, preferredStyle: .alert)
         alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         present(alertVC, animated: true, completion: nil)
     }
    
    private func annotateMap()
    {
        var annotations = [MKPointAnnotation]()
        let lat = CLLocationDegrees(geoLocation.latitude)
        let lon = CLLocationDegrees(geoLocation.longitude)
        let coordinate = CLLocationCoordinate2DMake(lat, lon)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Mary Jane"
        annotation.subtitle = mediaURLString
        annotations.append(annotation)
        
        self.mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)

        let regionRadius: CLLocationDegrees = 12000
        let location = CLLocation(latitude: lat, longitude: lon)
        let coodinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2, longitudinalMeters: regionRadius * 2)
        mapView.setRegion(coodinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else
        {
            pinView!.annotation = annotation
        }
        return pinView
    }
}
