//
//  ApiCallManager.swift
//  Config
//
//  Created by Pooja Anbhule on 31/01/20.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
import UIKit

let customAppColor = UIColor(red: 0/255.0, green: 84/255.0, blue: 147/255.0, alpha: 1.0)
class CommonData : NSObject {
        
    static let sharedInstance = CommonData()
    var activityIndicator = UIActivityIndicatorView()
    
    class func getStringFromData(data: Data) -> String? {
        guard let str = String(data: data, encoding: .utf8) else { return nil }
        return str
    }
    
    //----- Add / remove Activity indicators method
    
    func showActivityIndicatorOnView (view : UIView) {
        self.activityIndicator.center = view.center
        self.activityIndicator.color = .gray
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator () {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            
        }
    }
    
    //----- Get string & json from string methods
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
            return CommonData.getStringFromData(data: jsonData)
        } catch {
            return nil
        }
    }
    /////
    

}
