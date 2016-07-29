//
//  Settings.swift
//  TB_Client_Buyer
//
//  Created by Bastian Gardel on 16.05.16.
//
// Copyright © 2016 Bastian Gardel
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

// ** Class Settings **
//
// Settings Loading
//
// Author: Bastian Gardel
// Version: 1.0
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
