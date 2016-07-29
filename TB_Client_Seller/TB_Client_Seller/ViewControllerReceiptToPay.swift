//
//  ReceiptToPayViewController.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 27.06.16.
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
import SwiftQRCode
import BButton
import MBProgressHUD
import SCLAlertView


// ** Class ViewControllerReceiptToPay **
//
// View Receipt to pay Controller
//
// Author: Bastian Gardel
// Version: 1.0
class ViewControllerReceiptToPay: UIViewController {
   

   var toPass: CheckoutDTO?

   @IBOutlet weak var ReceiptIDLabel: UILabel!
   
   @IBOutlet weak var qrcode: UIImageView!
   
   @IBOutlet weak var returnButton: BButton!
   
   @IBOutlet weak var amountLabel: UILabel!
   
   var httpsSession = HTTPSSession.sharedInstance
   
   var receipt: ReceiptPayDTO?
   
   
   var hud: MBProgressHUD?
   
   //View initialisation
    override func viewDidLoad() {
        super.viewDidLoad()
      
      returnButton.color = UIColor.bb_dangerColorV2()
      returnButton.setStyle(BButtonStyle.BootstrapV2)
      returnButton.setType(BButtonType.Danger)
      returnButton.addAwesomeIcon(FAIcon.FAAngleDoubleLeft, beforeTitle: true)
      
      qrcode.image = QRCode.generateImage((toPass?.uuid)!, avatarImage: UIImage(named: "avatar"), avatarScale: 0.3)
      
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewControllerReceiptToPay.quitView(_:)), name: "quitView", object: nil)
      
      hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      hud?.labelText = "Receipt Loading in progress"
      hud?.labelFont = UIFont(name: "HelveticaNeue", size: 30)!
      
      httpsSession.getReceiptToPay((toPass?.uuid)!){
         (success: Bool, errorDescription:String, receiptPayDTO : ReceiptPayDTO?) in
         
         self.hud!.hide(true)
         
         if(success)
         {
            self.receipt = receiptPayDTO
            
            self.amountLabel.text = "CHF " + String(format: "%.02f", (self.receipt?.amount)!)
            self.ReceiptIDLabel.text = "Receipt ID: " + (self.receipt?.id?.description)!
            
         }
         else
         {
            let appearance = SCLAlertView.SCLAppearance(
               kTitleFont: UIFont(name: "HelveticaNeue", size: 30)!,
               kTextFont: UIFont(name: "HelveticaNeue", size: 30)!,
               kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 25)!,
               kWindowWidth: 500.0,
               kWindowHeight: 500.0,
               kTitleHeight: 50,
               showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("Return to menu"){
               self.performSegueWithIdentifier("returnMenuSegue", sender: self)
            }
            alertView.showError("Receipt Loading Error", subTitle: errorDescription)
         }
      }

      
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   //Quit view action
   func quitView(notification: NSNotification) {
      
      print(notification.userInfo!["aps"]!["uuid"])
      
      if(notification.userInfo!["uuid"]! as? String == toPass?.uuid){
         self.performSegueWithIdentifier("returnMenuSegue", sender: self)
      }
      
   }
   
   //Click on Return button handler
   @IBAction func returnMenuAction(sender: AnyObject) {
      self.performSegueWithIdentifier("returnMenuSegue", sender: self)
   }
   
   //Prepare transfer value for next view
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
      if (segue.identifier == "returnMenuSegue") {
         let svc = segue.destinationViewController as! ViewControllerCheckoutMenu;
         svc.toPass = toPass
      }
   }
}
