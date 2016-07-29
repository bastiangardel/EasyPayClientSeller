//
//  ViewController.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 20.06.16.
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
import KeychainSwift
import BButton
import MBProgressHUD
import SCLAlertView

// ** Class ViewControllerLogin **
//
// View Login Controller
//
// Author: Bastian Gardel
// Version: 1.0
class ViewControllerLogin: UIViewController {

   @IBOutlet weak var LoginTF: UITextField!
   
   @IBOutlet weak var PasswordTF: UITextField!
   
   @IBOutlet weak var SaveLP: UISwitch!
   
   @IBOutlet weak var loginButton: BButton!
   
   let keychain = KeychainSwift()
   
   var httpsSession = HTTPSSession.sharedInstance
   
   var hud: MBProgressHUD?
   
   //End edition mode if click outside of the textfield
   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      LoginTF.endEditing(true)
      PasswordTF.endEditing(true)
      
   }
   
   //View initialisation
   override func viewDidLoad() {
      super.viewDidLoad()
      loginButton.color = UIColor.bb_successColorV2()
      loginButton.setStyle(BButtonStyle.BootstrapV2)
      loginButton.setType(BButtonType.Success)
      loginButton.addAwesomeIcon(FAIcon.FASignIn, beforeTitle: false)
      
      
      if ((keychain.get("login")) != nil && (keychain.get("password")) != nil) {
         LoginTF.text = keychain.get("login");
         PasswordTF.text = keychain.get("password")
      }
      
      if keychain.getBool("SaveLP")  != nil {
         SaveLP.setOn(keychain.getBool("SaveLP")!, animated: false)
      }
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }

   //Click on login button handler
   @IBAction func loginAction(sender: AnyObject) {
      keychain.set(SaveLP.on, forKey: "SaveLP");
      
      let appearance = SCLAlertView.SCLAppearance(
         kTitleFont: UIFont(name: "HelveticaNeue", size: 30)!,
         kTextFont: UIFont(name: "HelveticaNeue", size: 30)!,
         kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 25)!,
         kWindowWidth: 500.0,
         kWindowHeight: 500.0,
         kTitleHeight: 50
      )
      
      loginButton.enabled = false
      LoginTF.endEditing(true)
      PasswordTF.endEditing(true)
      
      hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      
      hud?.labelText = "Login Request in Progress"
      hud?.labelFont = UIFont(name: "HelveticaNeue", size: 30)!
      
      httpsSession.login(LoginTF.text!, password: PasswordTF.text!){
         (success: Bool, errorDescription:String) in
         
         
         self.hud!.hide(true)
         if(success)
         {
            if(self.SaveLP.on)
            {
               self.keychain.set(self.LoginTF.text!, forKey: "login");
               self.keychain.set(self.PasswordTF.text!, forKey: "password");
            }
            else
            {
               self.keychain.delete("login")
               self.keychain.delete("password");
            }
            
            
            self.performSegueWithIdentifier("loginSegue", sender: self)
         }
         else
         {
            
            
            let alertView = SCLAlertView(appearance: appearance)
            alertView.showError("Login Error", subTitle: errorDescription)
            
            self.loginButton.enabled = true
            
         }
         
      }
   }
   
   
}

