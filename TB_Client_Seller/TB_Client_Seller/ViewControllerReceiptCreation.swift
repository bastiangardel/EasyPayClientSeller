//
//  ViewControllerReceiptCreation.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 29.06.16.
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
import BButton
import MBProgressHUD
import SCLAlertView
import KeychainSwift

// ** Class ViewControllerReceiptCreation **
//
// View Receipt Creation Controller
//
// Author: Bastian Gardel
// Version: 1.0
class ViewControllerReceiptCreation: UIViewController {
   
   
   @IBOutlet weak var createButton: BButton!
   @IBOutlet weak var amountTF: UITextField!
   @IBOutlet weak var returnMenuButton: BButton!
   
   var toPass: CheckoutDTO?
   
   var receiptlist: Array<ReceiptHistoryDTO>?
   
   var httpsSession = HTTPSSession.sharedInstance
   
   var hud: MBProgressHUD?
   
   let keychain = KeychainSwift()
   
   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      amountTF.endEditing(true)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      createButton.color = UIColor.bb_defaultColorV2()
      createButton.setStyle(BButtonStyle.BootstrapV2)
      createButton.setType(BButtonType.Default)
      createButton.addAwesomeIcon(FAIcon.FACheck, beforeTitle: false)
      
      returnMenuButton.color = UIColor.bb_dangerColorV2()
      returnMenuButton.setStyle(BButtonStyle.BootstrapV2)
      returnMenuButton.setType(BButtonType.Danger)
      returnMenuButton.addAwesomeIcon(FAIcon.FAAngleDoubleLeft, beforeTitle: true)
      
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
      if (segue.identifier == "returnMenuRCreationSegue") {
         let svc = segue.destinationViewController as! ViewControllerCheckoutMenu;
         svc.toPass = toPass
      }
      
      if (segue.identifier == "paymentSegue") {
         let svc = segue.destinationViewController as! ViewControllerReceiptToPay;
         svc.toPass = toPass
      }
      
   }
   
   
   @IBAction func returnMenuAction(sender: AnyObject) {
      self.performSegueWithIdentifier("returnMenuRCreationSegue", sender: self)
   }
   
   @IBAction func createAction(sender: AnyObject) {
      
      let appearance1 = SCLAlertView.SCLAppearance(
         kTitleFont: UIFont(name: "HelveticaNeue", size: 30)!,
         kTextFont: UIFont(name: "HelveticaNeue", size: 30)!,
         kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 25)!,
         kWindowWidth: 500.0,
         kWindowHeight: 500.0,
         kTitleHeight: 50,
         showCloseButton: false
      )
      
      let appearance2 = SCLAlertView.SCLAppearance(
         kTitleFont: UIFont(name: "HelveticaNeue", size: 30)!,
         kTextFont: UIFont(name: "HelveticaNeue", size: 30)!,
         kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 25)!,
         kWindowWidth: 500.0,
         kWindowHeight: 500.0,
         kTitleHeight: 50
      )
      
      amountTF.endEditing(true)
      
      hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      hud?.labelText = "Receipt List Loading in progress"
      hud?.labelFont = UIFont(name: "HelveticaNeue", size: 30)!
      
      var amount: Double?
      
      
      
      if amountTF.text != ""
      {
         amount = Double.init(amountTF.text!)
         if  amount != nil
         {
            let receipt : ReceiptCreationDTO = ReceiptCreationDTO(uuid: (toPass?.uuid)!,amount: amount!, deviceToken: keychain.get("deviceToken")!)
            
            let alertView2 = SCLAlertView(appearance: appearance1)
            alertView2.addButton("Return to menu"){
               self.performSegueWithIdentifier("returnMenuRCreationSegue", sender: self)
            }
            
            let alertView1 = SCLAlertView(appearance: appearance1)
            alertView1.addButton("Go to paiement screen"){
               self.performSegueWithIdentifier("paymentSegue", sender: self)
            }
            
            httpsSession.createReceipt(receipt){
               (success: Bool, description: String) in
               
               self.hud!.hide(true)
               
               if(success)
               {
                  alertView1.showSuccess("Receipt Creation", subTitle: description)
               }
               else
               {
                  alertView2.showError("Receipt Creation Error", subTitle: description)
               }
            }
         }
         else
         {
            self.hud!.hide(true)
            
            amountTF.text = ""
            
            let alertView = SCLAlertView(appearance: appearance2)
            alertView.showError("Receipt Creation Error", subTitle: "Wrong Entry")
         }
      }
      else
      {
         self.hud!.hide(true)
         
         let alertView = SCLAlertView(appearance: appearance2)
         alertView.showError("Receipt Creation Error", subTitle: "No Amount defined")
      }
      
      
   }
   
}
