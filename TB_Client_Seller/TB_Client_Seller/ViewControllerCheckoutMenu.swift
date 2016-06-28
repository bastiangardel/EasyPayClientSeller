//
//  ViewControllerCheckoutMenu.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 23.06.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import BButton
import MBProgressHUD
import SCLAlertView

class ViewControllerCheckoutMenu: UIViewController {
   
   @IBOutlet weak var receiptHistoryButton: BButton!
   
   @IBOutlet weak var newCheckoutButton: BButton!
   
   @IBOutlet weak var lastReceiptButton: BButton!
   
   @IBOutlet weak var returnButton: BButton!
   
   @IBOutlet weak var deleteReceiptButton: BButton!
   
   var httpsSession = HTTPSSession.sharedInstance
   
   var toPass: CheckoutDTO?
   
   var hud: MBProgressHUD?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
      receiptHistoryButton.color = UIColor.bb_defaultColorV2()
      receiptHistoryButton.setStyle(BButtonStyle.BootstrapV2)
      receiptHistoryButton.setType(BButtonType.Default)
      receiptHistoryButton.addAwesomeIcon(FAIcon.FAHistory, beforeTitle: false)
      
      newCheckoutButton.color = UIColor.bb_defaultColorV2()
      newCheckoutButton.setStyle(BButtonStyle.BootstrapV2)
      newCheckoutButton.setType(BButtonType.Default)
      newCheckoutButton.addAwesomeIcon(FAIcon.FAPlusSquare, beforeTitle: false)
      
      lastReceiptButton.color = UIColor.bb_defaultColorV2()
      lastReceiptButton.setStyle(BButtonStyle.BootstrapV2)
      lastReceiptButton.setType(BButtonType.Default)
      lastReceiptButton.addAwesomeIcon(FAIcon.FAShoppingCart, beforeTitle: false)
      
      deleteReceiptButton.color = UIColor.bb_defaultColorV2()
      deleteReceiptButton.setStyle(BButtonStyle.BootstrapV2)
      deleteReceiptButton.setType(BButtonType.Default)
      deleteReceiptButton.addAwesomeIcon(FAIcon.FATrashO, beforeTitle: false)
      
      returnButton.color = UIColor.bb_dangerColorV2()
      returnButton.setStyle(BButtonStyle.BootstrapV2)
      returnButton.setType(BButtonType.Danger)
      returnButton.addAwesomeIcon(FAIcon.FAAngleDoubleLeft, beforeTitle: true)
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   @IBAction func returnAction(sender: AnyObject) {
      self.performSegueWithIdentifier("returnCheckoutListSegue", sender: self)
   }
   
   @IBAction func receiptToPayAction(sender: AnyObject) {
      self.performSegueWithIdentifier("receiptToPaySegue", sender: self)
   }
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
      if (segue.identifier == "receiptToPaySegue") {
         let svc = segue.destinationViewController as! ViewControllerReceiptToPay;
         svc.toPass = toPass
      }
      
      if (segue.identifier == "receiptHistorySegue") {
         let svc = segue.destinationViewController as! ViewControllerHistory;
         svc.toPass = toPass
      }
      
   }
   
   @IBAction func historyAction(sender: AnyObject) {
      self.performSegueWithIdentifier("receiptHistorySegue", sender: self)
      
   }
   @IBAction func deletReceiptAction(sender: AnyObject) {
      
      let appearance = SCLAlertView.SCLAppearance(
         kTitleFont: UIFont(name: "HelveticaNeue", size: 30)!,
         kTextFont: UIFont(name: "HelveticaNeue", size: 30)!,
         kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 25)!,
         kWindowWidth: 500.0,
         kWindowHeight: 500.0,
         kTitleHeight: 50
      )
      
      let alertView = SCLAlertView(appearance: appearance)
      alertView.addButton("ok"){
         alertView.hideView()
         
         self.httpsSession.deleteReceiptToPay((self.toPass?.uuid)!){
            (success: Bool, errorDescription:String) in
            
            if(success)
            {
               
               let alertView = SCLAlertView(appearance: appearance)
               alertView.showSuccess("Delete Last Receipt", subTitle: "Delete with success")
               
               
            }
            else
            {
               let alertView = SCLAlertView(appearance: appearance)
               alertView.showError("Delete Last Receipt", subTitle: errorDescription)
            }
            
            
         }
         
         
         
      }
      alertView.showWarning("Delete Warning", subTitle: "Do you really want to delete the last receipt?")
   }
   
   
   
}
