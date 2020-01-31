//
//  ApiCallManager.swift
//  Config
//
//  Created by Pooja Anbhule on 31/01/20.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation

class Apicall : NSObject {
    
    private var sharedSession: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.httpAdditionalHeaders = ["Cache-Control" : "no-cache"]
        return URLSession(configuration: config)
    }
    
    static let sharedInstance = Apicall()
    
    
   
    
    // MARK:- services methods
    
    class func getStringFromData(data: Data) -> String? {
        guard let str = String(data: data, encoding: .utf8) else { return nil }
        return str
    }
    class func getJSONObject(data: Data) -> Any? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data,
                                                              options: [])
            return jsonObject
        } catch {
            return nil
        }
    }
    
    class func getJSONStringFromObject(_ jsonObject: Any) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject,
                                                      options: .init(rawValue: 0))
            return Apicall.getStringFromData(data: jsonData)
        } catch {
            return nil
        }
    }
    
    
    
      func createEmployee(withParameters parameters:Any, completionBlock : @escaping (_ successful:Bool,_ response:Any?) -> ()) {
          sendPOSTDataWithoutDataKey(serviceUrl: "http://dummy.restapiexample.com/api/v1/create", parameters: parameters, completionBlock: completionBlock)
      }
      
      func getEmployeeList(completionBlock : @escaping (_ successful:Bool,_ responseDict:Any?) -> ()) {
          let urlString = "http://dummy.restapiexample.com/api/v1/employees"
          callGETservice(serviceURL: urlString, completionBlock: completionBlock)
      }
      
      func getEmployeeDetails(empId:String , completionBlock : @escaping (_ successful:Bool,_ responseDict:Any?) -> ()) {
          let urlString = "http://dummy.restapiexample.com/api/v1/employee/" + empId
          callGETservice(serviceURL: urlString, completionBlock: completionBlock)
      }

    
    func sendPOSTDataWithoutDataKey(serviceUrl : String, parameters:Any, completionBlock : @escaping (_ successful:Bool,_ response:Any?) -> ()) {
        guard let url = URL(string: "\(serviceUrl)")
            else {
                DispatchQueue.main.async
                    {
                        completionBlock(false, "Invalid URL")
                }
                return
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters,
                                                  options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        
                        print("\(#function) :  Success \n \(Apicall.getStringFromData(data: data!) ?? "")")
//                        print("\(#function) : Success \n \(String(describing: Apicall.getStringFromData(data: data!)))")
//                        completionBlock(true,(Apicall.getJSONObject(data: data!)))
                        completionBlock(true,(Apicall.getStringFromData(data: data!)))
                    }
                } else {
                    print("\(#function) error : \(error?.localizedDescription ?? "No error")")
                    
                    DispatchQueue.main.async {
                        completionBlock(false, "Connection Error")
                    }
                }
            }
            dataTask.resume()
        } catch let error {
            print("\(#function) error : \(error.localizedDescription)")
            DispatchQueue.main.async {
                completionBlock(false, "Connection Error")
            }
        }
    }

    
    func callGETservice(serviceURL : String, completionBlock : @escaping (_ successful:Bool,_ responseDict:Any?) -> ()) {
        guard let url = URL(string: "\(serviceURL)") else { return }
        print("url is-->> \(url)")
        let dataTask = sharedSession.dataTask(with: url,
                                              completionHandler: { (data, response, error) in
                                                
                                                
                                                if error == nil {
                                                    print("completion block done")
                                                    //                                                    if AppCommonData.getJSONObject(data: data!) != nil
                                                    print("\(String(describing: response))")
                                                    
                                                    
                                                    print(" \(#function) : Success \n \(String(describing: Apicall.getStringFromData(data: data!)))")
                                                    
                                                    //                                                        print("\(#function) : Success \n \(AppCommonData.getJSONObject(data: data!)!)")
                                                    DispatchQueue.main.async {
                                                        //                                                        completionBlock(true,(Apicall.getJSONObject(data: data!)))
                                                        completionBlock(true,(Apicall.getStringFromData(data: data!)))
                                                    }
                                                    //                                                    }else
                                                    //                                                    {
                                                    //                                                        completionBlock(false,"Somethig went wrong")
                                                    //                                                    }
                                                    
                                                } else {
                                                    
                                                    print("\(#function) : failed (\(error?.localizedDescription ?? "No error"))")
                                                    DispatchQueue.main.async {
                                                        
                                                        completionBlock(false,(error?.localizedDescription ?? "No error"))
                                                    }
                                                }
        })
        dataTask.resume()
    }
    
    
}
