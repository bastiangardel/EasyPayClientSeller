//
//  ViewController.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 14.06.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import KeychainSwift
import BButton
import MBProgressHUD
import SCLAlertView

class ViewControllerLogin: UIViewController {
   
   @IBOutlet weak var LoginTF: UITextField!
   @IBOutlet weak var PasswordTF: UITextField!
   
   @IBOutlet weak var loginButton: BButton!
   
   @IBOutlet weak var SaveLP: UISwitch!
   
   let keychain = KeychainSwift()
   
   var httpsSession = HTTPSSession.sharedInstance
   
   var hud: MBProgressHUD?
   
   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      LoginTF.endEditing(true)
      PasswordTF.endEditing(true)
      
   }
   
   
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
   
   @IBAction func loginAction(sender: AnyObject) {
      keychain.set(SaveLP.on, forKey: "SaveLP");
      
      loginButton.enabled = false
      
      hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      hud?.labelText = "Login Request in Progress"
      
      httpsSession.login(LoginTF.text!, password: PasswordTF.text!){
         (success: Bool, errorDescription:String) in
         
         self.hud!.hide(true)
         if(success)
         {
            if ((self.keychain.get("login")) == nil && (self.keychain.get("password")) == nil) {
               if self.SaveLP.on {
                  self.keychain.set(self.LoginTF.text!, forKey: "login");
                  self.keychain.set(self.PasswordTF.text!, forKey: "password");
               }
            }
            else
            {
               if !self.SaveLP.on {
                  self.keychain.delete("login")
                  self.keychain.delete("password");
               }
               
            }
            self.performSegueWithIdentifier("loginSegue", sender: self)
         }
         else
         {
            
            
            let alertView = SCLAlertView()
            alertView.showError("Login Error", subTitle: errorDescription)
            
            self.loginButton.enabled = true
            
         }
         
      }

   }

   
}

