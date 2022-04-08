//
//  CoreDataHelper.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 30/03/22.
//

import Foundation
import CoreData
enum StorageType:Comparable {
  case persistent, inMemory
}

class CFCoreDataHelper: DBHelperInterface {
    
    static let shared = CFCoreDataHelper ()
    
    typealias ObjectType = NSManagedObject
    typealias PredicateType = NSPredicate
    var storageType:String = NSSQLiteStoreType
    lazy var context : NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    lazy var persistentContainer:NSPersistentContainer = {
        let container = NSPersistentCloudKitContainer(name: "ToDoDB")
        let description = container.persistentStoreDescriptions.first
        description?.type = storageType
        container.persistentStoreDescriptions = [description!]
        container.loadPersistentStores(completionHandler:{ (storeDescription, error) in
            if let error = error as NSError? {
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    private init(){}
}
//MARK:- Core Data Helpers
extension CFCoreDataHelper {
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                _ = error as NSError
            }
        }
    }
}

//MARK:- DBHelper protocol
extension CFCoreDataHelper {
    func create(_ object: NSManagedObject) {
        saveContext()
    }
    
    func fetch<T:ObjectType>(_ objectType: T.Type, predicate: PredicateType?, limit: Int? = nil) -> Result<[T], Error> {
        let request = objectType.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        if let limit = limit {
            request.fetchLimit = limit
        }
        do {
            let result = try context.fetch(request)
            return .success(result as?[T] ?? [])
        }catch {
            return .failure(error)
        }
    }
    
    func fetchFirst<T:ObjectType>(_ objectType: T.Type, predicate: PredicateType?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try context.fetch(request) as? [T]
            return .success(result?.first)
        }catch {
            return .failure(error)
        }
    }
    
    func update(_ object: ObjectType) {
        saveContext()
    }
    
    func delete(_ object: ObjectType) {
        context.delete(object)
        saveContext()
    }
    func flushDB<T:ObjectType>(_ objectType: T.Type) {
        let request = objectType.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            result.forEach{ mo in
                delete(mo as! NSManagedObject)
            }
            saveContext()
            
        }catch {
            
        }
    }
}
