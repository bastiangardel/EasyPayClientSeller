//
//  ViewControllerHistory.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 27.06.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import BButton
import MBProgressHUD
import SCLAlertView

class ViewControllerHistory: UIViewController,UITableViewDelegate, UITableViewDataSource {

   @IBOutlet weak var ReceiptListTable: UITableView!
   
   @IBOutlet weak var returnButton: BButton!
   
   var toPass: CheckoutDTO?
   
   var receiptlist: Array<ReceiptHistoryDTO>?
   
   var httpsSession = HTTPSSession.sharedInstance
   
   var hud: MBProgressHUD?
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
      returnButton.color = UIColor.bb_dangerColorV2()
      returnButton.setStyle(BButtonStyle.BootstrapV2)
      returnButton.setType(BButtonType.Danger)
      returnButton.addAwesomeIcon(FAIcon.FAAngleDoubleLeft, beforeTitle: true)
      
      ReceiptListTable.delegate = self
      ReceiptListTable.dataSource = self
      
      
      hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      hud?.labelText = "Receipt List Loading in progress"
      hud?.labelFont = UIFont(name: "HelveticaNeue", size: 30)!
      
      httpsSession.getReceiptHistory((toPass?.uuid)!){
         (success: Bool, errorDescription:String, listCheckoutDTO : Array<ReceiptHistoryDTO>) in
         
         self.hud!.hide(true)
         
         let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 30)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 30)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 25)!,
            kWindowWidth: 500.0,
            kWindowHeight: 500.0,
            kTitleHeight: 50,
            showCloseButton: false
         )
         
         if(success)
         {
            self.receiptlist = listCheckoutDTO
            if(listCheckoutDTO.count == 0)
            {
               let alertView = SCLAlertView(appearance: appearance)
               alertView.addButton("Return to Menu"){
                  
                  self.performSegueWithIdentifier("returnMenuHistorySegue", sender: self)
               }
               alertView.showInfo("Receipt List Info", subTitle: "List Empty")
            }
            
            self.ReceiptListTable.reloadData();
            
         }
         else
         {
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("Return to Menu"){
               
               self.performSegueWithIdentifier("returnMenuHistorySegue", sender: self)
            }
            alertView.showError("Receipt List Loading Error", subTitle: errorDescription)
         }
      }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   @IBAction func returnMenuAction(sender: AnyObject) {
      self.performSegueWithIdentifier("returnMenuHistorySegue", sender: self)
      
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
      if (segue.identifier == "returnMenuHistorySegue") {
         let svc = segue.destinationViewController as! ViewControllerCheckoutMenu;
         svc.toPass = toPass
      }
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if receiptlist != nil {
         return (receiptlist?.count)!
      }
      
      return 0;
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("receiptCell", forIndexPath: indexPath)
      cell.backgroundColor = UIColor(colorLiteralRed: 0.88, green: 0.93, blue: 0.91, alpha: 0.7)
      cell.textLabel?.text = " ID: " + (receiptlist![indexPath.row].id)!.description + ", Amount: CHF " + (receiptlist![indexPath.row].amount)!.description + ", Payed By: " + (receiptlist![indexPath.row].payBy)!
      return cell
   }

}
