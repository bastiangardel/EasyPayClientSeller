//
//  HTTPSSession.swift
//  TB_Client_Buyer
//
//  Created by Bastian Gardel on 19.04.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import ObjectMapper
import SwiftyJSON


public class HTTPSSession: NSObject {
   
   static let sharedInstance = HTTPSSession()
   
   static let URL : String = Settings.sharedInstance.getParameterString("address_preference")
   
   
   static let PORT : String = Settings.sharedInstance.getParameterString("port_preference")
   
   
   let defaultManager: Alamofire.Manager = {
      let serverTrustPolicies: [String: ServerTrustPolicy] = [
         HTTPSSession.URL : .DisableEvaluation
      ]
      
      let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
      configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
      configuration.timeoutIntervalForRequest = 10
      
      return Alamofire.Manager(
         configuration: configuration,
         serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
      )
   }()
   
   
   private override init() {
      
      super.init()
      
   }
   
   private func completeURL( address : String, port : String, restEndpoint : String) -> String{
      return "https://" + address + ":" + port + restEndpoint;
   }
   
   private func requestParameter(name:String,value:String) -> String{
      
      return String("?") + name + "=" + value
   }
   
   private func errorDescriptionJSON(response : Response<AnyObject,NSError>, error : NSError)->String
   {
      var description: String = ""
      var errorNumber: Int
      
      var json = JSON(data: response.data!)
      let status = json["message"].stringValue
      
      if response.response != nil{
         errorNumber = (response.response?.statusCode)!
         
         switch errorNumber {
         case 401:
            description = "Access Deny : " + status
         case 500:
            description = "Erreur Server : " + status
         case 404:
            description = "Ressource not found : " + status
         case 412:
            description = "Precondition Failed : " + status
         default:
            description = "Undefined : " + status
         }
      }
      else
      {
         errorNumber = error.code
         description = error.localizedDescription
         
      }
      
      return String(errorNumber) + " : " + description
   }
   
   
   private func errorDescriptionDATA(response : Response<NSData,NSError>, error : NSError)->String
   {
      var description: String = ""
      var errorNumber: Int
      
      var json = JSON(data: response.data!)
      let status = json["message"].stringValue
      
      if response.response != nil{
         errorNumber = (response.response?.statusCode)!
         
         switch errorNumber {
         case 401:
            description = "Access Deny : " + status
         case 500:
            description = "Erreur Server : " + status
         case 404:
            description = "Ressource not found : " + status
         case 412:
            description = "Precondition Failed : " + status
         default:
            description = "Undefined : " + status
         }
      }
      else
      {
         errorNumber = error.code
         description = error.localizedDescription
         
      }
      
      return String(errorNumber) + " : " + description
   }
   
   private func updateCookies(response: Response<NSData, NSError>) {
      if let
         headerFields = response.response?.allHeaderFields as? [String: String],
         URL = response.request?.URL {
         let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(headerFields, forURL: URL)
         // Set the cookies back in our shared instance. They'll be sent back with each subsequent request.
         defaultManager.session.configuration.HTTPCookieStorage?.setCookies(cookies, forURL: URL, mainDocumentURL: nil)
      }
   }
   
   public func login (let login: String,  let password: String, completion: (success: Bool, errorDescription: String) -> Void){
      
      let credentials = ["username": login ,"password": password ]
      let headers = [
         "Content-Type": "application/json"
      ]
      
      print("try to login to " + completeURL(HTTPSSession.URL, port: HTTPSSession.PORT, restEndpoint: "/users/auth"))
      
      
      
      defaultManager.request(.POST, completeURL(HTTPSSession.URL, port: HTTPSSession.PORT, restEndpoint: "/users/auth"), headers : headers, parameters: credentials , encoding: .JSON)
         .validate()
         .responseData{ Response in
            switch Response.result {
            case .Success:
               self.updateCookies(Response)
               print("login Successful")
               completion(success: true, errorDescription: "")
               
            case .Failure(let error):
               print("login fail")
               completion(success: false, errorDescription : self.errorDescriptionDATA(Response, error: error))
            }
      }
   }
   
   
   public func getListCheckout (completion: (success: Bool, errorDescription: String, listCheckoutDTO : Array<CheckoutDTO?>?) -> Void){

      var listCheckout : Array<CheckoutDTO?>?
      
      
      let headers = [
         "Content-Type": "application/json",
         "Accept": "application/json"
      ]
      
      print("try to get the list of Checkout")
      
      
      defaultManager.request(.GET, completeURL(HTTPSSession.URL, port: HTTPSSession.PORT, restEndpoint: "/checkouts/checkoutlist"), headers : headers)
         .validate()
         .responseJSON{ Response in
            print(Response.request)
            switch Response.result {
            case .Success:
               print("Get Checkout Successfully")
               listCheckout = Mapper<CheckoutDTO>().mapArray(Response.result.value)!

               completion(success: true, errorDescription: "", listCheckoutDTO: listCheckout)
            
               
            case .Failure(let error):
               print("Get list checkout Failfully")
               completion(success: false, errorDescription : self.errorDescriptionJSON(Response, error: error), listCheckoutDTO: listCheckout)
            }
      }
   }
   
   
   
   public func logout(){
      defaultManager.request(.POST, completeURL(HTTPSSession.URL, port: HTTPSSession.PORT, restEndpoint: "/users/logout")).responseData{ Response in
         print("logout")
      }
      
   }
   
}