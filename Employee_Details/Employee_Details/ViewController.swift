//
//  ViewController.swift
//  Employee_Details
//
//  Created by Developer on 31/01/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var employeeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        employeeTableView.delegate = self
        employeeTableView.dataSource = self
        // Do any additional setup after loading the view.
        addnavigationBarTitleAndButton()
       
    }
    
    /** Set navigation bar with title and button **/
    func addnavigationBarTitleAndButton() {
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "create.png"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton

        var moneyLabel: UILabel?
        let moneyFrame = CGRect(x: 0, y: 0, width:
            100, height: 20)
        moneyLabel = UILabel(frame: moneyFrame)
        moneyLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        moneyLabel?.textColor = UIColor.blue
        moneyLabel!.text = "Employee List"
        self.navigationItem.titleView = moneyLabel!
        
    }
    
    /** Navigation bar create button Action. **/
    @objc func createButtonPressed() {
        
        self.NavigateToEmployeeDetailsController(type: "3")
    }
    
    /** Display actionSheet for Multip[le option display details of employee,update employee details and delete employee details. **/
    func showActionSheet() {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Employee details", style: .default, handler: { (_) in
            print("User click Employee details button")
            self.NavigateToEmployeeDetailsController(type: "1")
        }))
        
        alert.addAction(UIAlertAction(title: "Update employee details", style: .default, handler: { (_) in
            print("User click Update employee details button")
            self.NavigateToEmployeeDetailsController(type: "2")
        }))
        
        alert.addAction(UIAlertAction(title: "Delete employee details", style: .default, handler: { (_) in
            print("User click Delete employee details button")
            self.showAlertforDelete()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
            
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    /** Show alert for delete employee details **/
    func showAlertforDelete() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete employee details.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Delete",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Delete action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /** Navigate to employee details viewcontroller. **/
    func NavigateToEmployeeDetailsController(type:String) {
        let emplyeeDetailCntrl = self.storyboard?.instantiateViewController(identifier: "EmployeeDetailsViewController") as! EmployeeDetailsViewController
        emplyeeDetailCntrl.typeString = type
        self.navigationController?.pushViewController(emplyeeDetailCntrl, animated: true)
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActionSheet()
    }
    
}


