//
//  GTWorker.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 30/03/22.
//

import Foundation
import Foundation
import CoreData


// MARK: View Protocol
/// Responsibile for DB worker requirements
///All DB operations and error are injected through this interface
typealias toDoCompletion = (_ todoList: GTRecipeResult<[GTListDataModelProtocol]>) -> Void
protocol GTWorkerProtocol {
    ///Requirement for fetching all the todo list
    func fetchToDoList(completion: @escaping toDoCompletion)
    ///Requirement for inserting the todo item
    func insertToDoItem(_ item:GTListDataModelProtocol)
    ///Requirement for updating the todo item
    func updateItem(_ item:GTListDataModelProtocol)
    ///Requirement for deleting the todo item
    func deleteItem(_ item:GTListDataModelProtocol)
    ///Requirement for deleting all the todo items
    func flushDB()
    var dbHelper:CFCoreDataHelper {get set}
}

class GTWorker: GTWorkerProtocol {
    var dbHelper:CFCoreDataHelper
    var viewContext:NSManagedObjectContext?
    init(_ dbhelper:CFCoreDataHelper){
        dbHelper = dbhelper
        viewContext = dbHelper.context
    }
}

//MARK: Protocol requirement implementation
extension GTWorker {
    private func checkDBLoaded()-> Bool {
        let result:Result<[ToDoList],Error> = dbHelper.fetch(ToDoList.self, predicate: nil)
        switch result {
        case .success(let items):
            return !items.isEmpty
        case .failure:
            return false
        }
    }
}

//MARK: DB OPERATIONS INTERFCES
extension GTWorker {
    
    //MARK: Insert single todo item
    func insertToDoItem(_ item:GTListDataModelProtocol) {
        let entity = ToDoList.entity()
        let newToDoItem = ToDoList(entity: entity, insertInto: viewContext)
        newToDoItem.todoid = item.id
        newToDoItem.todoname = item.name
        newToDoItem.tododescription = item.description
        dbHelper.create(newToDoItem)
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
    }
    //MARK: Update single todo item
    func updateItem(_ item:GTListDataModelProtocol) {
        let result:Result<[ToDoList],Error> = dbHelper.fetch(ToDoList.self, predicate: getPredicateWithParam([String(describing: item.id)]))
        switch result {
        case .success(let result):
            let newToDoItem = result[0]
            newToDoItem.todoid = item.id
            newToDoItem.todoname = item.name
            newToDoItem.tododescription = item.description
            dbHelper.update(newToDoItem)
            break
        case .failure(_):
            /// DB fetch Failure... Since it is BG operation no need birng as a prompt to user
            print("****DB FETCH FAILED WHILE UPDATING****\(result)")
            break
        }
        
    }
    
    //MARK: delete single todo item
    func deleteItem(_ item:GTListDataModelProtocol) {
        let result:Result<[ToDoList],Error> = dbHelper.fetch(ToDoList.self, predicate: getPredicateWithParam([String(describing: item.id)]))
        switch result {
        case .success(let result):
            let newToDoItem = result[0]
            dbHelper.delete(newToDoItem)
            break
        case .failure(_):
            /// DB fetch Failure... Since it is BG operation no need birng as a prompt to user
            print("****DB FETCH FAILED WHILE DELETING****\(result)")
            break
        }
    }
    
    //MARK: delete all todo items
    func flushDB(){
        dbHelper.flushDB(ToDoList.self)
    }
}

//MARK:- Predicates
extension GTWorker {
    private func getPredicateWithParam(_ filterParam:[String]) -> NSCompoundPredicate {
        var compPredicateArr = [NSPredicate]()
        
        filterParam.forEach { param in
            compPredicateArr.append(NSPredicate(format: "todoid == '\(param)'"))
        }
        return NSCompoundPredicate(type: .or, subpredicates: compPredicateArr)
    }
}

