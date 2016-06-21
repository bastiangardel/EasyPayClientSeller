//
//  ViewController.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 20.06.16.
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
   
   @IBOutlet weak var SaveLP: UISwitch!
   
   @IBOutlet weak var loginButton: BButton!
   
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

}

