//
//  ViewControllerCheckoutMenu.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 23.06.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import BButton

class ViewControllerCheckoutMenu: UIViewController {
   
   @IBOutlet weak var receiptHistoryButton: BButton!
   
   @IBOutlet weak var newCheckoutButton: BButton!
   
   @IBOutlet weak var lastReceiptButton: BButton!
   
   @IBOutlet weak var returnButton: BButton!
   
   var toPass: CheckoutDTO?

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
