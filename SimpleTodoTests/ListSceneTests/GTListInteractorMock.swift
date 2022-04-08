//
//  GTListInteractorMock.swift
//  SimpleTodoTests
//
//  Created by Abhijithkrishnan on 02/04/22.
//

import UIKit
@testable import SimpleTodo
class GTListInteractorMock: GTInteractorProtocol {
    var ToDoPresenter: GTPresenterProtocol?
    
    var ToDoWorker: GTWorkerProtocol?
    
    func fetchToDoList() {
        ToDoWorker?.fetchToDoList(completion: {[weak self] todoResult in
            switch todoResult {
            case .Success(let todoList):
                self?.ToDoPresenter?.didFetchToDoList(todoList)
            case .Failure(let error):
                self?.ToDoPresenter?.bindError(error)
            }
        })
        calledMethods.append(.fetchToDoList)
    }
    
    func deleteToDoItem(_ todoItem: GTListDataModelProtocol) {
        privateQueues.customSerialQueue.async {
            self.ToDoWorker?.deleteItem(todoItem)
            self.fetchToDoList()
        }
        calledMethods.append(.deleteToDoItem)
    }
    
    func insertToDoItem(_ title: String, _ description: String, _ id: UUID, _ isUpdate: Bool) {
        privateQueues.customSerialQueue.async {
            if isUpdate{
                self.ToDoWorker?.updateItem(GTListDataModel(id: id, name: title, description: description))
            }else{
                self.ToDoWorker?.insertToDoItem(GTListDataModel(id: id, name: title, description: description))
            }
            self.fetchToDoList()
        }
        calledMethods.append(.insertToDoItem)
    }
    
    func deleteAllItems() {
        privateQueues.customSerialQueue.async {
            self.ToDoWorker?.flushDB()
            self.fetchToDoList()
        }
        calledMethods.append(.deleteAllItems)
    }
    //MARK:- Test Helpers
    enum CalledMethods:Equatable {
        case fetchToDoList
        case deleteToDoItem
        case insertToDoItem
        case deleteAllItems
        static func == (lhs:GTListInteractorMock.CalledMethods, rhs:GTListInteractorMock.CalledMethods) -> Bool {
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
extension GTListInteractorMock {
    func calledMethod(_ method: CalledMethods) -> Bool {
        return calledMethods.first(where: {$0 == method}) != nil
    }
    func numberOfTimesCalled(_ method: CalledMethods) -> Int {
        return calledMethods.filter({$0 == method }).count
    }
}

