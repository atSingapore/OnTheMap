//
//  TopNavigation.swift
//  PinSample
//
//  Created by Anya Traille on 22/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

// UITabBarController

class TabBarViewController: UITabBarController
{
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let navigationBar = UINavigationBar()
        view.addSubview(navigationBar)
    }
    
    @IBAction func refreshData()
    {
        OnTheMapClient.getUserInfo(completion: handleGetUserLocationData(data:error:))
    }
    
    @IBAction func logoutTapped(_sender: UIBarButtonItem)
    {
        
        OnTheMapClient.logout {
            DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
        }
    }
    
    func handleGetUserLocationData(data: [StudentInformation], error: Error?)
    {
        if error == nil
        {
            StudentModel.data = data
        } else
        {
            showGetUserLocationDataFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleLogout(success: Bool, error: Error?)
    {
        if success
        {
            // congrats
        } else
        {
            print("could not log out")
        }
    }
    
    func showGetUserLocationDataFailure(message: String)
    {
        let alertVC = UIAlertController(title: "Cannot get location data", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
