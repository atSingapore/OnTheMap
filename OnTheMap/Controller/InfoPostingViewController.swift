//
//  InfoPostingViewController.swift
//  PinSample
//
//  Created by Anya Traille on 22/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class InfoPostingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate
{
    var mapString: String!
    var mediaURLString: String!
    var geoLocation: CLLocationCoordinate2D!
    var hardCodedLocation: CLLocationCoordinate2D!
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    //@IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detectLocationButton: UIButton!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        
        self.locationTextField.text =  ""
        self.linkTextField.text = ""
        
        self.locationTextField.delegate = self
        self.linkTextField.delegate = self
        
    }
    
    @IBAction func findLocation(_ sender: Any)
    {
        mapString = locationTextField.text
        mediaURLString = linkTextField.text
        setFindingLocation(true)
        //getHardCodedCoordinates()
        getCoordinate(addressString: mapString, completion: handleGetCoordinates(location:error:))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        //if linkTextField.isFirstResponder
        if self.linkTextField.isEditing
        {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification)
    {
        if self.linkTextField.isEditing
        {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    func setFindingLocation(_ findingLocation: Bool)
    {
        findingLocation ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        locationTextField.isEnabled = !findingLocation
        linkTextField.isEnabled = !findingLocation
        findLocationButton.isEnabled = !findingLocation
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let secondControllerTakeData = segue.destination as! FindLocationViewController
        secondControllerTakeData.mapString = self.mapString
        secondControllerTakeData.mediaURLString = self.mediaURLString
        secondControllerTakeData.geoLocation = self.geoLocation
    }
    
    func getHardCodedCoordinates()
    {
        let test1 = CLLocationCoordinate2D(latitude: 33.7, longitude: -84.3)
        self.geoLocation = test1
        print("Hardcoded location is \(test1)")
    }
    
    
    func getCoordinate(addressString: String, completion: @escaping(CLLocationCoordinate2D, NSError?) -> Void)
    {
        print("Calling Get Coordinate with \(addressString)")
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil
            {
                if let placemark = placemarks?[0]
                {
                    if let location = placemark.location
                    {
                        self.geoLocation = location.coordinate
                        if self.linkTextField.text == "" || self.locationTextField.text == ""
                        {
                            self.showAlert(title: "Missing Fields", message: "Location and/or URL Empty")
                        }
                        //self.performSegue(withIdentifier: "findLocation", sender: nil)
                        completion(location.coordinate, nil)
                    }
                }
            } else
            {
                completion(kCLLocationCoordinate2DInvalid, error as NSError?)
            }
        }
    }
    
    func showAlert(title: String, message: String)
    {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
        setFindingLocation(false)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "findLocation"
        {
            if self.geoLocation == nil
            {
                return false
            }
        }
        if self.locationTextField.text == "" || self.linkTextField.text == ""
        {
            return false
        }
        return true
    }

    func handleGetCoordinates(location: CLLocationCoordinate2D, error: NSError?)
    {
        
        if let _ = error
        {
            self.showAlert(title: "Location Error", message: "there was an error in finding that location")
            
        } else
        {
            setFindingLocation(false)
            performSegue(withIdentifier: "findLocation", sender: nil)
        }
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
        }
    }

    @IBAction func cancelButton()
    {
        self.dismiss(animated: true, completion: nil)
    }



}
