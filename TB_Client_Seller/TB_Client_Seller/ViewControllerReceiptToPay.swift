//
//  ReceiptToPayViewController.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 27.06.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import SwiftQRCode
import BButton
import MBProgressHUD
import SCLAlertView



class ViewControllerReceiptToPay: UIViewController {
   

   var toPass: CheckoutDTO?

   @IBOutlet weak var ReceiptIDLabel: UILabel!
   
   @IBOutlet weak var qrcode: UIImageView!
   
   @IBOutlet weak var returnButton: BButton!
   
   @IBOutlet weak var amountLabel: UILabel!
   
   var httpsSession = HTTPSSession.sharedInstance
   
   var receipt: ReceiptPayDTO?
   
   
   var hud: MBProgressHUD?
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
      returnButton.color = UIColor.bb_dangerColorV2()
      returnButton.setStyle(BButtonStyle.BootstrapV2)
      returnButton.setType(BButtonType.Danger)
      returnButton.addAwesomeIcon(FAIcon.FAAngleDoubleLeft, beforeTitle: true)
      
      qrcode.image = QRCode.generateImage((toPass?.uuid)!, avatarImage: UIImage(named: "avatar"), avatarScale: 0.3)
      
      hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      hud?.labelText = "Receipt Loading in progress"
      hud?.labelFont = UIFont(name: "HelveticaNeue", size: 30)!
      
      httpsSession.getReceiptToPay((toPass?.uuid)!){
         (success: Bool, errorDescription:String, receiptPayDTO : ReceiptPayDTO?) in
         
         self.hud!.hide(true)
         
         if(success)
         {
            self.receipt = receiptPayDTO
            
            self.amountLabel.text = "CHF " + (self.receipt?.amount?.description)!
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
    
   @IBAction func returnMenuAction(sender: AnyObject) {
      self.performSegueWithIdentifier("returnMenuSegue", sender: self)
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
      if (segue.identifier == "returnMenuSegue") {
         let svc = segue.destinationViewController as! ViewControllerCheckoutMenu;
         svc.toPass = toPass
      }
   }
}
