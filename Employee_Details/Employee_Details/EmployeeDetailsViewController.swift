//
//  EmployeeDetailsViewController.swift
//  Employee_Details
//
//  Created by Pooja Anbhule on 30/01/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class EmployeeDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txtEmployeeName: UITextField!
    @IBOutlet weak var txtEmployeeAge: UITextField!
    @IBOutlet weak var txtEmployeeSalary: UITextField!
    var typeString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setViewcontroller()
    }
    
    /** Display viewcontrollerwith type
     create - 3
     update - 2
     viewDetails - 1. **/
    func setViewcontroller() {
        if typeString == "1" {
            titleLabel.text = "Employee Details"
            txtEmployeeName.isUserInteractionEnabled = false
            txtEmployeeAge.isUserInteractionEnabled = false
            txtEmployeeSalary.isUserInteractionEnabled = false
        }else if typeString == "2" {
            titleLabel.text = "Update Employee Details"
            txtEmployeeName.isUserInteractionEnabled = true
            txtEmployeeAge.isUserInteractionEnabled = true
            txtEmployeeSalary.isUserInteractionEnabled = true
        }else {
            titleLabel.text = "Create New Employee"
            txtEmployeeName.isUserInteractionEnabled = true
            txtEmployeeAge.isUserInteractionEnabled = true
            txtEmployeeSalary.isUserInteractionEnabled = true
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
