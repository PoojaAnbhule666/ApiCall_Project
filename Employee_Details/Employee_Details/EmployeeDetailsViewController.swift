//
//  EmployeeDetailsViewController.swift
//  Employee_Details
//
//  Created by Pooja Anbhule on 30/01/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Alamofire

class EmployeeDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txtEmployeeName: UITextField!
    @IBOutlet weak var txtEmployeeAge: UITextField!
    @IBOutlet weak var txtEmployeeSalary: UITextField!
    @IBOutlet weak var btn_save: UIButton!
    var typeString = ""
    var empID = ""
    var employeeDetails = [DataEmpList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewcontroller()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func tapped_save(_ sender: Any) {
        
        if typeString == "2" {
            let employee = employeeDetails[Int(empID)!]
            self.updateEmployeeData(empId:employee.id ?? "" )
        } else {
            createEmployee()
        }
    }
    /** Display viewcontrollerwith type
     create - 3
     update - 2
     viewDetails - 1. **/
    func setViewcontroller() {
        
        self.btn_save.isHidden = false
        self.btn_save.layer.cornerRadius = 5
        self.btn_save.layer.borderWidth = 1
        self.btn_save.layer.borderColor =  UIColor.systemBlue.cgColor
        if typeString == "1" {
            let employee = employeeDetails[Int(empID)!]
            DispatchQueue.main.async {
                
                self.titleLabel.text = "Employee Details"
                self.txtEmployeeName.isUserInteractionEnabled = false
                self.txtEmployeeAge.isUserInteractionEnabled = false
                self.txtEmployeeSalary.isUserInteractionEnabled = false
                self.txtEmployeeName.text = employee.employee_name
                self.txtEmployeeAge.text = employee.employee_age
                self.txtEmployeeSalary.text = employee.employee_salary
                self.btn_save.isHidden = true
            }
            
        }else if typeString == "2" {
            let employee = employeeDetails[Int(empID)!]
            DispatchQueue.main.async {
                
                self.titleLabel.text = "Update Employee Details"
                self.txtEmployeeName.isUserInteractionEnabled = true
                self.txtEmployeeAge.isUserInteractionEnabled = true
                self.txtEmployeeSalary.isUserInteractionEnabled = true
                self.txtEmployeeName.text = employee.employee_name
                self.txtEmployeeAge.text = employee.employee_age
                self.txtEmployeeSalary.text = employee.employee_salary
                self.btn_save.setTitle("Update", for: .normal)
                
            }
            
        }else {
            DispatchQueue.main.async {
                self.titleLabel.text = "Create New Employee"
                self.txtEmployeeName.isUserInteractionEnabled = true
                self.txtEmployeeAge.isUserInteractionEnabled = true
                self.txtEmployeeSalary.isUserInteractionEnabled = true
                self.btn_save.setTitle("Create", for: .normal)
            }
            
        }
    }
    
    
    // MARK: - APi call
    
    func createEmployee()  {
        
        let url = "http://dummy.restapiexample.com/api/v1/create"
        CommonData.sharedInstance.showActivityIndicatorOnView(view: self.view)
        let  paramdata = ["name" : self.txtEmployeeName.text ?? "" , "salary" :self.txtEmployeeSalary.text ?? "" ,"age" : self.txtEmployeeAge.text ?? ""] as [String : Any]
        print("paramdata--",paramdata)
        
        AF.request(url, method: .post, parameters: paramdata, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            CommonData.sharedInstance.removeActivityIndicator()
            print("create response ------ ",response)
            
            let responseStr = CommonData.getStringFromData(data: response.data ?? Data())
            print("create response ------ ",responseStr!)
            
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: (responseStr?.data(using: .utf8))! , options: []) as? Dictionary<String, Any>
                
                if jsonDict?["status"] as! String == "success"  {
                    self.showAlert(str: "Employee Create Succesfully")
                }
                
            } catch {
                
            }
        }
    }
    
    func updateEmployeeData(empId:String) {
        
        let url = "http://dummy.restapiexample.com/api/v1/update/\(empId)"
        CommonData.sharedInstance.showActivityIndicatorOnView(view: self.view)
        
        let  paramdata = ["name" : self.txtEmployeeName.text ?? "" , "salary" :self.txtEmployeeSalary.text ?? "" ,"age" : self.txtEmployeeAge.text ?? ""] as [String : Any]
        print("paramdata--",paramdata)
        
        AF.request(url, method: .put, parameters: paramdata, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            CommonData.sharedInstance.removeActivityIndicator()
            print("UPDATE response ------ ",response)
            
            let responseStr = CommonData.getStringFromData(data: response.data ?? Data())
            print("UPDATE response ------ ",responseStr!)
            
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: (responseStr?.data(using: .utf8))! , options: []) as? Dictionary<String, Any>
                
                if jsonDict?["status"] as! String == "success"  {
                    self.showAlert(str: "Update Succesfully")
                }
            } catch {
                
            }
        }
    }
    
    func showAlert(str : String) {
        let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
