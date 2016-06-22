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
   
   var data = ["Apple", "Apricot", "Banana", "Blueberry", "Cantaloupe", "Cherry",
               "Clementine", "Coconut", "Cranberry", "Fig", "Grape", "Grapefruit",
               "Kiwi fruit", "Lemon", "Lime", "Lychee", "Mandarine", "Mango",
               "Melon", "Nectarine", "Olive", "Orange", "Papaya", "Peach",
               "Pear", "Pineapple", "Raspberry", "Strawberry"]
   
   var checkoutlist: Array<CheckoutDTO?>?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      logoutButton.color = UIColor.bb_dangerColorV2()
      logoutButton.setStyle(BButtonStyle.BootstrapV2)
      logoutButton.setType(BButtonType.Danger)
      logoutButton.addAwesomeIcon(FAIcon.FASignOut, beforeTitle: false)
      
      CheckoutsTable.delegate = self
      CheckoutsTable.dataSource = self
      
      httpsSession.getListCheckout(){
         (success: Bool, errorDescription:String, listCheckoutDTO : Array<CheckoutDTO?>?) in
         
         self.hud!.hide(true)
         
         if(success)
         {
            self.checkoutlist = listCheckoutDTO
         }
         else
         {
            let appearance = SCLAlertView.SCLAppearance(
               kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
               kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
               kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
               showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("Return to menu"){
               self.httpsSession.logout()
               
               self.performSegueWithIdentifier("logoutSegue", sender: self)
            }
            alertView.showError("Receipt Loading Error", subTitle: errorDescription)
         }
      }

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return data.count
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      print("test")
      let cell = tableView.dequeueReusableCellWithIdentifier("FruitCell", forIndexPath: indexPath)
      cell.textLabel?.text = data[indexPath.row]
      
      //cell.backgroundColor = UIColor(red: 219, green: 234, blue: 227, alpha: 0)
      cell.backgroundColor = UIColor(colorLiteralRed: 0.88, green: 0.93, blue: 0.91, alpha: 0.7)
      
      return cell
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
   }
   
   @IBAction func logoutAction(sender: AnyObject) {
      
      httpsSession.logout()
      
      self.performSegueWithIdentifier("logoutSegue", sender: self)
   }

}
