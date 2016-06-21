//
//  ReceiptDTO.swift
//  TB_Client_Buyer
//
//  Created by Bastian Gardel on 20.05.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import ObjectMapper

public class ReceiptPayDTO: Mappable {
   
   var id : Int?
   var amount : Double?
   
   
   required public init?(_ map: Map){
      
   }
   
   public func mapping(map: Map) {
      id    <- map["id"]
      amount    <- map["amount"]

   }

}
