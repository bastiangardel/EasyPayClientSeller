//
//  MessageDTO.swift
//  TB_Client_Buyer
//
//  Created by Bastian Gardel on 23.05.16.
//  Copyright © 2016 Bastian Gardel. All rights reserved.
//

import UIKit
import ObjectMapper

public class MessageDTO: Mappable {
   
   var message : String?
   
   required public init?(_ map: Map){
      
   }
   
   public func mapping(map: Map) {
      message    <- map["successMessage"]
      
   }

}
