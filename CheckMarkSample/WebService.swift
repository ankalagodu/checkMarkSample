//
//  WebService.swift
//  CheckMarkSample
//
//  Created by Koushik on 30/07/18.
//  Copyright © 2018 Wolken Software Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

class WebService{
    
    
    class var sharedInstance : WebService {
        struct Static {
            static let instance : WebService = WebService()
        }
        //Static.instance.setUPS()
        return Static.instance
    }
    
    // post request to API header
    func postRequestURLEncodingWithURL(_ strURL : String, params : [String : Any]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        
        // Alamofire post request
        request(strURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            // checking response from API is success
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            // checking response from API is failure
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    func onmobileGetWatcherUsers(_ success:@escaping (Bool,JSON) -> Void,failure:@escaping(Error) ->Void){
            
            // get the base url
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                return
            }
            let baseUrl = appDelegate.gnocBaseUrl
            
            // login url
            let url = "\(baseUrl)/issuetracker/services/service/getWatcherUsers"
            
            let userID = "22"
            let sessionID = "hqZbzxH6Pw"
        
            // header for post request
            let header : HTTPHeaders = ["userId":userID, "sessionId":sessionID, "Content-Type": "application/json"]
            
            // show network activity
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            self.postRequestURLEncodingWithURL(url, params: nil, headers: header, success: {
                (JSONResponse) -> Void in
                
                print("got response in API:\(JSONResponse)")
                
                /*got response in API:{
                 "watcherDetails" : [
                 {
                 "userPsNo" : "super_admin",
                 "userFullName" : "Super Admin",
                 "userLname" : "Admin",
                 "userFname" : "Super",
                 "userEmail" : "poornima@wolkensoftware.com",
                 "userId" : 1,
                 "activeUser" : true
                 },
                 {
                 "userPsNo" : "onm_admin",
                 "userFullName" : "admin Admin",
                 "userLname" : "Admin",
                 "userFname" : "admin",
                 "userEmail" : "poornima@wolkensoftware.com",
                 "userId" : 2,
                 "activeUser" : true
                 }
                 ],
                 "statusDesc" : "Success",
                 "userId" : null,
                 "sessionId" : null,
                 "companyId" : null
                 }*/
                // hide network activity
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if (JSONResponse == JSON.null) {
                    success(false,JSONResponse)
                    return
                }
                let status = JSONResponse["statusDesc"].stringValue
                if (status == "Success") {
                    success(true,JSONResponse)
                }else{
                    success(false,JSONResponse)
                }
            }) {
                (error) -> Void in
                failure(error)
            }
        }
        
}


