//
//  Notification.swift
//  EZER
//
//  Created by TimerackMac1 on 27/12/17.
//  Copyright © 2017 TimerackMac1. All rights reserved.
//

import Foundation
extension Notification.Name {
    // notify to customer
    static let orderStatusChange = Notification.Name(rawValue: "orderStatusChange")
    
    // notifyToCustomer to clear its home values
    static let resetCustomerHomeData = Notification.Name(rawValue: "resetCustomerHomeData") // clear home text fields and locations
    
    // reload customer home screen
    //static let refreshCustomerData = Notification.Name(rawValue: "refreshCustomerData") // when customer make changes to orders
    
    // local notification order cancel by customer
    static let ownOrderCancel = Notification.Name(rawValue: "OwnOrderCancel")
    
    // local notification order added by customer
    static let ownOrderPlaced = Notification.Name(rawValue: "ownOrderPlaced")
    
    // reload customer home screen
    static let orderCancelFromDriver = Notification.Name(rawValue: "orderCancelFromDriver")
    
    // notify to Driver
    static let immediateOrderAvailble = Notification.Name(rawValue: "immediateOrderAvailble")// s

    // notify to Driver
    static let scheduleOrderAvailble = Notification.Name(rawValue: "scheduleOrderAvailble")
    
    // reload driver home screen
    static let refreshDriverData = Notification.Name(rawValue: "refreshDriverHome")
    
    // order cancel from customer notify to driver
    static let orderCancelFromCustomer = Notification.Name(rawValue: "orderCancelFromCustomer")
    
    //scheduled order cancelled
    static let scheduledOrderCancelFromCustomer = Notification.Name(rawValue: "scheduledOrderCanceled")
}
