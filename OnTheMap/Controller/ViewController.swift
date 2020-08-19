//
//  ViewController.swift
//  PinSample
//
//  Created by Jason on 3/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate
{
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        mapView.delegate = self
        self.tabBarController?.tabBar.isHidden = false
        OnTheMapClient.getUserInfo { (data, error) in
            StudentModel.data = data
            self.annotateMap()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.mapView.delegate = self
    }
    
    private func annotateMap()
    {
        var annotations = [MKPointAnnotation]()
        for studentDictionary in StudentModel.data
        {
            let studentLat = CLLocationDegrees(studentDictionary.latitude)
            let studentLon = CLLocationDegrees(studentDictionary.longitude)
            let studentCoordinate = CLLocationCoordinate2D(latitude: studentLat, longitude: studentLon)
            let studentFirst = studentDictionary.firstName
            let studentLast = studentDictionary.lastName
            let studentMediaURL = studentDictionary.mediaURL
            let studentAnnotation = MKPointAnnotation()
            studentAnnotation.coordinate = studentCoordinate
            studentAnnotation.title = "\(studentFirst) \(studentLast)"
            studentAnnotation.subtitle = studentMediaURL
            annotations.append(studentAnnotation)
        }
        
        self.mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            if let toOpen = view.annotation?.subtitle!
            {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
