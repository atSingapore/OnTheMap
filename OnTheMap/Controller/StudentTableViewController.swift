//
//  StudentTableViewController.swift
//  PinSample
//
//  Created by Anya Traille on 19/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class StudentTableViewController: UITableViewController {
    
    //var students: [StudentModel]!
    
    @IBOutlet var tableView2: UITableView!
    //@IBOutlet weak var tableView: UITableView!
    //@IBOutlet var tableView: UITableView!
    
    //@IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.tableView2.reloadData()
        }
        print("TABLE VIEW IS LOADING")
 
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        tableView2.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        print("THERE ARE \(StudentModel.data.count)")
        return StudentModel.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        let student = StudentModel.data[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedIndex = indexPath.row
        let selectedStudent = StudentModel.data[selectedIndex]
        let studentLinkString = selectedStudent.mediaURL
        if let studentURL = URL(string: studentLinkString)
        {
            UIApplication.shared.open(studentURL, options: [:], completionHandler: nil)
        } else
        {
            let alertVC = UIAlertController(title: "No URL", message: "This student does not have a valid URL", preferredStyle:  .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
    }
        
}

//extension StudentTableViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//
//        print("THERE ARE \(StudentModel.data.count)")
//        return StudentModel.data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
//        let student = StudentModel.data[indexPath.row]
//
//        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
//        cell.imageView?.image = UIImage(named: "icon_pin")
//        return cell
//    }
//
//}

