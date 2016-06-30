//
//  ViewControllerReceiptCreation.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 29.06.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import BButton
import MBProgressHUD
import SCLAlertView
import KeychainSwift

class ViewControllerReceiptCreation: UIViewController {
   
   
   @IBOutlet weak var createButton: BButton!
   @IBOutlet weak var amountTF: UITextField!
   
   var toPass: CheckoutDTO?
   
   var receiptlist: Array<ReceiptHistoryDTO>?
   
   var httpsSession = HTTPSSession.sharedInstance
   
   var hud: MBProgressHUD?
   
   let keychain = KeychainSwift()

    override func viewDidLoad() {
        super.viewDidLoad()

      createButton.color = UIColor.bb_defaultColorV2()
      createButton.setStyle(BButtonStyle.BootstrapV2)
      createButton.setType(BButtonType.Default)
      createButton.addAwesomeIcon(FAIcon.FACheck, beforeTitle: false)
      
      
        // Do any additional setup after loading the view.
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
            
            let alertView = SCLAlertView(appearance: appearance1)
            alertView.addButton("Return to menu"){
               self.performSegueWithIdentifier("returnMenuRCreationSegue", sender: self)
            }
            
            httpsSession.createReceipt(receipt){
               (success: Bool, description: String) in
               
               self.hud!.hide(true)
               
               if(success)
               {
                  alertView.showSuccess("Receipt Creation", subTitle: description)
               }
               else
               {
                  alertView.showError("Receipt Creation Error", subTitle: description)
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
