//
//  CheckoutsViewController.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 21.06.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import BButton
import MBProgressHUD
import SCLAlertView

class ViewControllerCheckouts: UIViewController,UITableViewDelegate, UITableViewDataSource {

   @IBOutlet weak var logoutButton: BButton!
   
   @IBOutlet weak var CheckoutsTable: UITableView!
   
   var httpsSession = HTTPSSession.sharedInstance
   
   var hud: MBProgressHUD?
   
   var checkoutlist: Array<CheckoutDTO>?
   
   var index: Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      logoutButton.color = UIColor.bb_dangerColorV2()
      logoutButton.setStyle(BButtonStyle.BootstrapV2)
      logoutButton.setType(BButtonType.Danger)
      logoutButton.addAwesomeIcon(FAIcon.FASignOut, beforeTitle: false)
      
      CheckoutsTable.delegate = self
      CheckoutsTable.dataSource = self
      
      hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      hud?.labelText = "Checkouts List Loading in progress"
      hud?.labelFont = UIFont(name: "HelveticaNeue", size: 30)!
      
      httpsSession.getListCheckout(){
         (success: Bool, errorDescription:String, listCheckoutDTO : Array<CheckoutDTO>) in
         
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
            self.checkoutlist = listCheckoutDTO
            if(listCheckoutDTO.count == 0)
            {
               let alertView = SCLAlertView(appearance: appearance)
               alertView.addButton("Logout"){
                  self.httpsSession.logout()
                  
                  self.performSegueWithIdentifier("logoutSegue", sender: self)
               }
               alertView.showInfo("Checkouts List Info", subTitle: "Please, ask your administrator for a new checkout.")
            }
            
            self.CheckoutsTable.reloadData();
            
         }
         else
         {
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("Logout"){
               self.httpsSession.logout()
               
               self.performSegueWithIdentifier("logoutSegue", sender: self)
            }
            alertView.showError("Checkouts List Loading Error", subTitle: errorDescription)
         }
      }

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
      if (segue.identifier == "checkoutMenuSegue") {
         let svc = segue.destinationViewController as! ViewControllerCheckoutMenu;
         svc.toPass = self.checkoutlist![index];
      }
   }
   
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if checkoutlist != nil {
         return (checkoutlist?.count)!
      }
      
      return 0;
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("checkoutCell", forIndexPath: indexPath)
      cell.textLabel?.text = (checkoutlist?[indexPath.row].name)! + " : " + (checkoutlist?[indexPath.row].uuid)!
      cell.backgroundColor = UIColor(colorLiteralRed: 0.88, green: 0.93, blue: 0.91, alpha: 0.7)
      
      return cell
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

      index = indexPath.row
      
      self.performSegueWithIdentifier("checkoutMenuSegue", sender: self)
      
   }
   
   @IBAction func logoutAction(sender: AnyObject) {
      
      httpsSession.logout()
      
      self.performSegueWithIdentifier("logoutSegue", sender: self)
   }

}
