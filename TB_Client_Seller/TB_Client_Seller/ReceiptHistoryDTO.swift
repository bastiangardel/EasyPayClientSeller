//
//  ReceiptHistoryDTO.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 27.06.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import ObjectMapper

public class ReceiptHistoryDTO: Mappable {

   var id : Int?
   var amount : Double?
   var payBy : String?
   var created: String?
   
   
   required public init?(_ map: Map){
      
   }
   
   public func mapping(map: Map) {
      id        <- map["id"]
      amount    <- map["amount"]
      payBy    <- map["payBy"]
      created    <- map["created"]
   }
}
