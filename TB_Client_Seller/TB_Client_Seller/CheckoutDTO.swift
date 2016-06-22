//
//  CheckoutDTO.swift
//  TB_Client_Seller
//
//  Created by Bastian Gardel on 22.06.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import ObjectMapper

public class CheckoutDTO: Mappable {
   
   var uuid: String?
   
   var name: String?
   
   
   required public init?(_ map: Map){
      
   }
   
   public func mapping(map: Map) {
      uuid    <- map["uuid"]
      name    <- map["name"]
   }
}
