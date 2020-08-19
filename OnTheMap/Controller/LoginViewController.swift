//
//  LoginViewController.swift
//  PinSample
//
//  Created by Anya Traille on 17/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.activityIndicator.hidesWhenStopped = true
        emailTextField.text = ""
        passwordTextField.text = ""
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func loginTapped(_ sender: UIButton)
    {
        setLoggingIn(true)
        OnTheMapClient.login(userName: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
    }
    
    @IBAction func signUp(_ sender: UIButton)
    {
        let urlString = "https://auth.udacity.com/sign-up"
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else
        {
            // Fallback on earlier versions
        }
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
        if passwordTextField.isEditing
        {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification)
    {
        if passwordTextField.isEditing
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
    
    func setLoggingIn(_ logginIn: Bool)
    {
        logginIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        emailTextField.isEnabled = !logginIn
        passwordTextField.isEnabled = !logginIn
        loginButton.isEnabled = !logginIn
    }
    
    func handleLoginResponse(success: Bool, error: Error?)
    {
        setLoggingIn(false)
        print(OnTheMapClient.Auth.requestToken)
        if success
        {
            OnTheMapClient.getStudentUserData(completion: handleGetStudentUserData(success:error:))
            OnTheMapClient.getUserInfo(completion: handleGetUserLocationData(data:error:))
        } else
        {
            showAlert(heading: "Login Error", message: error?.localizedDescription ?? "")
        }
    }
    
    func showAlert(heading: String, message: String)
    {
        let alertVC = UIAlertController(title: heading, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func handleGetStudentUserData(success: Bool, error: Error?)
    {
        if !success
        {
            showAlert(heading: "User Data Error", message: error?.localizedDescription ?? "")
        }
    }
    
    func handleGetUserLocationData(data: [StudentInformation], error: Error?)
    {
        if error == nil
        {
            StudentModel.data = data
            setLoggingIn(false)
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else
        {
            showAlert(heading: "Location Data Error", message: error?.localizedDescription ?? "")
        }
    }
}
