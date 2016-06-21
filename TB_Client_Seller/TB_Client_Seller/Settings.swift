//
//  Settings.swift
//  TB_Client_Buyer
//
//  Created by Bastian Gardel on 16.05.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit

public class Settings: NSObject  {
   
   
   static let sharedInstance = Settings()
   
   
   private var content: NSUserDefaults?
   
   
   private override init() {
      
      super.init()
      
      content = NSUserDefaults.standardUserDefaults()
      let appDefaults: [String : AnyObject] = [
         "address_preference" : "192.168.1.46",
         "port_preference" : "9000"
      ]
      
      content!.registerDefaults(appDefaults)
      content!.synchronize()
      
      print("load settings")
      
   }
   
   public func getParameterString(key : String) -> String{
      
      content = NSUserDefaults.standardUserDefaults()
      
      return content!.stringForKey(key)!
   }
   

}
