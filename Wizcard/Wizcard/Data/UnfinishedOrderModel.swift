//
//  UnfinishedOrderModel.swift
//  EZER
//
//  Created by TimerackMac1 on 25/01/18.
//  Copyright © 2018 TimerackMac1. All rights reserved.
//

import Foundation
class UnfinishedOrderModel : NSObject {
    
    var beforeImages: [String] = [String]()
    var loadingTime: Int32 = 0
    var multiWOStatus: String = ""
    var orderId: String = ""
    var status: String = ""
    var stop: Int16 = 0
    var afterImages: [String] = [String]()
    var startTime :Double = 0.0
    override init() {
        
    }
    override var description : String {
     //   print(beforeImages,"load images")
      //  print(afterImages,"unload images")
            return String(format: "loadtime: %d, multiWOStatus: %@, orderId: %@, status: %@ , stop  %d,startTime %d",loadingTime,multiWOStatus,orderId,status,stop,startTime)
        
    }
    
}
