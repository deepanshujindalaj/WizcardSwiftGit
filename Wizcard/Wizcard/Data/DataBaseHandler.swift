//
//  DataBaseHandler.swift
//  EZER
//
//  Created by TimerackMac1 on 24/01/18.
//  Copyright © 2018 TimerackMac1. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class DataBaseHandler {
    static let dataBaseHandler = DataBaseHandler()
    
     func saveOrder(unfinishedOrder  : UnfinishedOrderModel)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        let requestFormat : NSFetchRequest<UnfinishedOrder> = UnfinishedOrder.fetchRequest()
        requestFormat.predicate =   NSPredicate(format : "orderId == %@", unfinishedOrder.orderId)
        requestFormat.returnsObjectsAsFaults = false
        do {
           let fetchResults = try context.fetch(requestFormat)
            if !fetchResults.isEmpty{
                return
            }
        } catch let error {
           // print("error in finding",error)
        } // check if order is already exist
        
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "UnfinishedOrder", into:context) as! UnfinishedOrder
        entity.beforeImages = unfinishedOrder.beforeImages
        entity.loadingTime = unfinishedOrder.loadingTime
        entity.multiWOStatus = unfinishedOrder.multiWOStatus
        entity.orderId = unfinishedOrder.orderId
        entity.status = unfinishedOrder.status
        entity.stop = unfinishedOrder.stop
        entity.startTime = unfinishedOrder.startTime
        entity.afterImages = unfinishedOrder.afterImages
        do {
            try context.save()
           // print("saved")
        } catch let error as NSError
        {
         //   print("Could not save. \(error), \(error.userInfo)")
        }
    }
    // MARK : delete all orders
    func deleteUnfinishedData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: UnfinishedOrder.fetchRequest())
            try context.execute(deleteRequest)
            try context.save()
          //  print("order cleared sucess fully")
        }
        catch{
           // print("error in deleting")
        }
    }
    func updateUnfishedOrder(unfinishedOrder  : UnfinishedOrderModel)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            let requestFormat : NSFetchRequest<UnfinishedOrder> = UnfinishedOrder.fetchRequest()
            requestFormat.predicate =   NSPredicate(format : "orderId == %@", unfinishedOrder.orderId)
            requestFormat.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(requestFormat)
                    if fetchResults.count > 0{
                        let entity = fetchResults[0]
                        entity.beforeImages = unfinishedOrder.beforeImages
                        entity.loadingTime = unfinishedOrder.loadingTime
                        entity.multiWOStatus = unfinishedOrder.multiWOStatus
                        //entity.orderId = unfinishedOrder.orderId
                        entity.status = unfinishedOrder.status
                        entity.stop = unfinishedOrder.stop
                        entity.afterImages = unfinishedOrder.afterImages
                        entity.startTime = unfinishedOrder.startTime
                        do
                        {
                            try context.save()
                          //  print("updated")
                        }catch(let error)
                        {
                            print("saving error", error)
                        }
                    }
            
        } catch _ as NSError {
        }
    }
    func updateUnfishedOrderBeforeImages(startTime  : Double,beforeImages: [String],orderId:String)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            let requestFormat : NSFetchRequest<UnfinishedOrder> = UnfinishedOrder.fetchRequest()
            requestFormat.predicate =   NSPredicate(format : "orderId == %@", orderId)
            requestFormat.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(requestFormat)
            if fetchResults.count > 0{
                let entity = fetchResults[0]
                entity.beforeImages = beforeImages
                //entity.orderId = unfinishedOrder.orderId
                entity.startTime = startTime
                do
                {
                    try context.save()
                    
                }catch(let error)
                {
                    print("saving error", error)
                }
            }
            
        } catch _ as NSError {
           // print("error occurred")
        }
    }
    func updateUnfishedOrderAfterImages(orderId:String,afterImages: [String])
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            let requestFormat : NSFetchRequest<UnfinishedOrder> = UnfinishedOrder.fetchRequest()
            requestFormat.predicate =   NSPredicate(format : "orderId == %@", orderId)
            requestFormat.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(requestFormat)
            if fetchResults.count > 0{
                let entity = fetchResults[0]
                entity.afterImages = afterImages
                do
                {
                    try context.save()
                    //print("saved")
                }catch(let error)
                {
                    //print("saving error", error)
                }
            }
            
        } catch _ as NSError {
          
        }
    }
    func updateUnfishedOrderLoadingTime(orderId:String,loadingTime: Int)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            let requestFormat : NSFetchRequest<UnfinishedOrder> = UnfinishedOrder.fetchRequest()
            requestFormat.predicate =   NSPredicate(format : "orderId == %@", orderId)
            requestFormat.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(requestFormat)
            if fetchResults.count > 0{
                let entity = fetchResults[0]
                entity.loadingTime = Int32(loadingTime)
                do
                {
                    try context.save()
                    print("saved")
                }catch(let error)
                {
                    print("saving error", error)
                }
            }
            
        } catch _ as NSError {
            print("error occurred")
        }
    }
    func updateUnfishedOrderStatus(orderId:String,status: String)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            let requestFormat : NSFetchRequest<UnfinishedOrder> = UnfinishedOrder.fetchRequest()
            requestFormat.predicate =   NSPredicate(format : "orderId == %@", orderId)
            requestFormat.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(requestFormat)
            if fetchResults.count > 0{
                let entity = fetchResults[0]
                entity.status = status
                do
                {
                    try context.save()
                }catch(let error)
                {
                    print("saving error", error)
                }
            }
            
        } catch _ as NSError {
        }
    }
    // MARK : Get one unfinished order
    func getUnfinishedOrders() -> UnfinishedOrderModel?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            let requestFormat : NSFetchRequest<UnfinishedOrder> = UnfinishedOrder.fetchRequest()
            //requestFormat.predicate =   NSPredicate(format : "categoryType == %@", categoryType)
            requestFormat.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(requestFormat)
            if fetchResults.count > 0{
                let unfinishedOrder = fetchResults.first!
                let entity = UnfinishedOrderModel()
                entity.beforeImages = unfinishedOrder.beforeImages!
                entity.loadingTime = unfinishedOrder.loadingTime
                entity.multiWOStatus = unfinishedOrder.multiWOStatus!
                entity.orderId = unfinishedOrder.orderId!
                entity.status = unfinishedOrder.status!
                entity.stop = unfinishedOrder.stop
                entity.startTime = unfinishedOrder.startTime
                entity.afterImages = unfinishedOrder.afterImages!
                
                return entity
            }else{
                return nil
            }
        }
        catch{
            return nil
        }
    }
    
}
