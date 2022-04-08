//
//  GTListWorkerMock.swift
//  SimpleTodoTests
//
//  Created by Abhijithkrishnan on 02/04/22.
//

import UIKit
import CoreData
@testable import SimpleTodo
class GTListWorkerMock: GTWorkerProtocol {
    var viewContext:NSManagedObjectContext?
    var dbHelper:CFCoreDataHelper = CFCoreDataHelper.shared
   
     init() {
         dbHelper.storageType = NSInMemoryStoreType
         viewContext = dbHelper.context
      }
    //MARK: Insert single todo item
    func insertToDoItem(_ item:GTListDataModelProtocol) {
        let entity = ToDoList.entity()
        let newToDoItem = ToDoList(entity: entity, insertInto: viewContext)
        newToDoItem.todoid = item.id
        newToDoItem.todoname = item.name
        newToDoItem.tododescription = item.description
        dbHelper.create(newToDoItem)
        calledMethods.append(.insertToDoItem)
    }
    
    //MARK: Fetch All todo items
    func fetchToDoList(completion: @escaping toDoCompletion){
        let todoresult:Result<[ToDoList],Error> = dbHelper.fetch(ToDoList.self, predicate:nil)
        switch todoresult {
        case .success(let result):
            completion(.Success(result.map{$0.mapToDoDataModel()}))
            break
        case .failure(let error):
            completion(.Failure(error))
            break
        }
        calledMethods.append(.fetchToDoList)
    }
    //MARK: Update single todo item
    func updateItem(_ item:GTListDataModelProtocol) {
        let result:Result<[ToDoList],Error> = dbHelper.fetch(ToDoList.self, predicate: getPredicateWithParam([String(describing: item.id)]))
        switch result {
        case .success(let result):
            if let newToDoItem = result.first{
            newToDoItem.todoid = item.id
            newToDoItem.todoname = item.name
            newToDoItem.tododescription = item.description
            dbHelper.update(newToDoItem)
            }
            break
        case .failure(_):
            /// DB fetch Failure... Since it is BG operation no need birng as a prompt to user
            print("****DB FETCH FAILED WHILE UPDATING****\(result)")
            break
        }
        calledMethods.append(.insertToDoItem)
    }
    
    //MARK: delete single todo item
    func deleteItem(_ item:GTListDataModelProtocol) {
        let result:Result<[ToDoList],Error> = dbHelper.fetch(ToDoList.self, predicate: getPredicateWithParam([String(describing: item.id)]))
        switch result {
        case .success(let result):
            if let newToDoItem = result.first{
            dbHelper.delete(newToDoItem)
            }
            break
        case .failure(_):
            /// DB fetch Failure... Since it is BG operation no need birng as a prompt to user
            print("****DB FETCH FAILED WHILE DELETING****\(result)")
            break
        }
        calledMethods.append(.deleteToDoItem)
    }
    
    //MARK: delete all todo items
    func flushDB(){
        dbHelper.flushDB(ToDoList.self)
        calledMethods.append(.deleteAllItems)
    }
    private func getPredicateWithParam(_ filterParam:[String]) -> NSCompoundPredicate {
        var compPredicateArr = [NSPredicate]()
        
        filterParam.forEach { param in
            compPredicateArr.append(NSPredicate(format: "todoid == '\(param)'"))
        }
        return NSCompoundPredicate(type: .or, subpredicates: compPredicateArr)
    }
    //MARK:- Test Helpers
    enum CalledMethods:Equatable {
        case fetchToDoList
        case deleteToDoItem
        case insertToDoItem
        case deleteAllItems
        static func == (lhs:GTListWorkerMock.CalledMethods, rhs:GTListWorkerMock.CalledMethods) -> Bool {
            switch (lhs,rhs) {
            case (.fetchToDoList, .fetchToDoList),
                 (.deleteToDoItem, .deleteToDoItem),
                (.insertToDoItem, .insertToDoItem),
                (.deleteAllItems, .deleteAllItems):
                return true
            default:
                return false
            }
        }
    }
    var calledMethods = [CalledMethods]()
}
extension GTListWorkerMock {
    func calledMethod(_ method: CalledMethods) -> Bool {
        return calledMethods.first(where: {$0 == method}) != nil
    }
    func numberOfTimesCalled(_ method: CalledMethods) -> Int {
        return calledMethods.filter({$0 == method }).count
    }
}


