//
//  ReceiptCreationDTO.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 30.06.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import ObjectMapper

public class ReceiptCreationDTO: Mappable {
   
   var amount : Double?
   var uuidCheckout : String?
   var deviceToken: String?
   
   
   required public init?(_ map: Map){
      
   }
   
   public init(uuid: String, amount: Double, deviceToken: String)
   {
      self.amount = amount
      self.uuidCheckout = uuid
      self.deviceToken = deviceToken
   }
   
   public func mapping(map: Map) {
      amount    <- map["amount"]
      uuidCheckout    <- map["uuidCheckout"]
      deviceToken    <- map ["deviceToken"]
   }

}
