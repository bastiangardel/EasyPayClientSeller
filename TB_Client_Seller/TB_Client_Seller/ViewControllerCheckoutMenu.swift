//
//  ViewControllerCheckoutMenu.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 23.06.16.
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


// ** Class ViewControllerCheckoutMenu **
//
// View Menu Checkout Controller
//
// Author: Bastian Gardel
// Version: 1.0
class ViewControllerCheckoutMenu: UIViewController {
   
   @IBOutlet weak var receiptHistoryButton: BButton!
   
   @IBOutlet weak var newCheckoutButton: BButton!
   
   @IBOutlet weak var lastReceiptButton: BButton!
   
   @IBOutlet weak var returnButton: BButton!
   
   @IBOutlet weak var deleteReceiptButton: BButton!
   
   var httpsSession = HTTPSSession.sharedInstance
   
   var toPass: CheckoutDTO?
   
   var hud: MBProgressHUD?
   
   var rotateActive: Bool = true;

   
   override func shouldAutorotate() -> Bool {
      return rotateActive
   }
   
   //View Initialisation
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
   
   //Click on return button handler
   @IBAction func returnAction(sender: AnyObject) {
      self.performSegueWithIdentifier("returnCheckoutListSegue", sender: self)
   }
   
   //Click on receiptToPay button handler
   @IBAction func receiptToPayAction(sender: AnyObject) {
      self.performSegueWithIdentifier("receiptToPaySegue", sender: self)
   }
   
   //Prepare transfer values for next view
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
      if (segue.identifier == "receiptToPaySegue") {
         let svc = segue.destinationViewController as! ViewControllerReceiptToPay;
         svc.toPass = toPass
      }
      
      if (segue.identifier == "receiptHistorySegue") {
         let svc = segue.destinationViewController as! ViewControllerHistory;
         svc.toPass = toPass
      }
      
      if (segue.identifier == "receiptCreationSegue") {
         let svc = segue.destinationViewController as! ViewControllerReceiptCreation;
         svc.toPass = toPass
      }
      
   }
   
   //Click on History button handler
   @IBAction func historyAction(sender: AnyObject) {
      self.performSegueWithIdentifier("receiptHistorySegue", sender: self)
      
   }
   
   //Click on deleteReceipt button handler
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
      alertView.addButton("Delete"){
         alertView.hideView()
         
         self.httpsSession.deleteReceiptToPay((self.toPass?.uuid)!){
            (success: Bool, errorDescription:String) in
            
            if(success)
            {
               
               let alertView = SCLAlertView(appearance: appearance)
               alertView.showSuccess("Delete Last Receipt", subTitle: "With Success")
               
               
            }
            else
            {
               let alertView = SCLAlertView(appearance: appearance)
               alertView.showError("Error Delete Last Receipt", subTitle: errorDescription)
            }
            
            
         }
         
         
         
      }
      alertView.showWarning("Delete Warning", subTitle: "Do you really want to delete the last receipt?")
   }
   
   
   //Click On createReceipt Button handler
   @IBAction func createReceiptAction(sender: AnyObject) {
      
      self.performSegueWithIdentifier("receiptCreationSegue", sender: self)
      
   }
   
}
