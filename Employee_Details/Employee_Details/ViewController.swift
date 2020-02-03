//
//  ViewController.swift
//  Employee_Details
//
//  Created by Developer on 31/01/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var employeeTableView: UITableView!
    var employeelistArray = [DataEmpList]()
    var employeeId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        employeeTableView.delegate = self
        employeeTableView.dataSource = self
        // Do any additional setup after loading the view.
        addnavigationBarTitleAndButton()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getEmployeeList()
    }
    /** Set navigation bar with title and button **/
    func addnavigationBarTitleAndButton() {
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "create.png"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        var navTittle: UILabel?
        let navFrame = CGRect(x: 0, y: 0, width:
            100, height: 20)
        navTittle = UILabel(frame: navFrame)
        navTittle?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        navTittle?.textColor = customAppColor
        navTittle!.text = "Employee List"
        self.navigationItem.titleView = navTittle!
        
    }
    
    /** Navigation bar create button Action. **/
    @objc func createButtonPressed() {
        self.NavigateToEmployeeDetailsController(type: "3", empId_: "")
    }
    
    /** Display actionSheet for Multip[le option display details of employee,update employee details and delete employee details. **/
    func showActionSheet(empID : String) {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Employee details", style: .default, handler: { (_) in
            print("User click Employee details button")
            self.NavigateToEmployeeDetailsController(type: "1", empId_: empID)
        }))
        
        alert.addAction(UIAlertAction(title: "Update employee details", style: .default, handler: { (_) in
            print("User click Update employee details button")
            self.NavigateToEmployeeDetailsController(type: "2", empId_: empID)
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
                                        self.deleteEmployeeData(empId:self.employeeId)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /** Navigate to employee details viewcontroller. **/
    func NavigateToEmployeeDetailsController(type:String , empId_ : String) {
        let emplyeeDetailCntrl = self.storyboard?.instantiateViewController(identifier: "EmployeeDetailsViewController") as! EmployeeDetailsViewController
        emplyeeDetailCntrl.typeString = type
        emplyeeDetailCntrl.empID = empId_
        emplyeeDetailCntrl.employeeDetails = employeelistArray
        self.navigationController?.pushViewController(emplyeeDetailCntrl, animated: true)
    }
    
    // Api Call services
    
    func getEmployeeList () {
        let url : String = "http://dummy.restapiexample.com/api/v1/employees"
        
        CommonData.sharedInstance.showActivityIndicatorOnView(view: self.view)
        AF.request(url).responseData { (response) in
            debugPrint("Response----", response)
            CommonData.sharedInstance.removeActivityIndicator()
            if let error = response.error {
                print("error -- ", error)
            }
            
            guard let data = response.data else {
                print("no data found")
                return
            }
            do {
                let decoder = JSONDecoder()
                let empData = try decoder.decode(EmployeeData.self, from: data)
                self.employeelistArray = empData.data ?? []
                
                DispatchQueue.main.async {
                    self.employeeTableView.reloadData()
                }
                
            } catch {
                print("Error due to parsing")
            }
        }
    }
    
    
    func deleteEmployeeData(empId:String) {
        
        let url = "http://dummy.restapiexample.com/api/v1/delete/\(empId)"
        
        CommonData.sharedInstance.showActivityIndicatorOnView(view: self.view)
        AF.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            CommonData.sharedInstance.removeActivityIndicator()
            print("UPDATE response ------ ",response)
            
            let responseStr = CommonData.getStringFromData(data: response.data ?? Data())
            print("UPDATE response ------ ",responseStr!)
            
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: (responseStr?.data(using: .utf8))! , options: []) as? Dictionary<String, Any>
                
                if jsonDict?["status"] as! String == "success"  {
                    self.showAlert(str: jsonDict?["message"] as! String)
                } else {
                     self.showAlert(str: jsonDict?["message"] as! String)
                }
            } catch {
                
            }
        }
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeelistArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        let indexPath = indexPath.row
        cell.NameLabel.text = employeelistArray[indexPath].employee_name
        cell.ageLabel.text = employeelistArray[indexPath].employee_age
        cell.salaryLabel.text = employeelistArray[indexPath].employee_salary
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        employeeId = employeelistArray[indexPath.row].id ?? ""
        showActionSheet(empID: String(indexPath.row))
    }
    
    func showAlert(str : String) {
        let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


