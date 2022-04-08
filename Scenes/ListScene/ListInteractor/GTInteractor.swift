//
//  GTInteractor.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 30/03/22.
//

import Foundation

//MARK: Interactor Protocol
protocol GTInteractorProtocol {
    /// Presenter connection to expose the fetched results to pipeline
    var ToDoPresenter:GTPresenterProtocol? {get set}
    /// Work connection to act as helper
    var ToDoWorker:GTWorkerProtocol? {get set}
    
    /// Data fetch initiation interface
    func fetchToDoList()
    
    ///Interface used to delete data based on selection
    func deleteToDoItem(_ todoItem:GTListDataModelProtocol)
    
    ///Interface used to insert data based on selection
    func insertToDoItem(_ title:String, _ description:String, _ id:UUID, _ isUpdate:Bool)
    
    ///Interface used to Flush DB
    func deleteAllItems()
}
class GTInteractor:GTInteractorProtocol{
    var ToDoWorker: GTWorkerProtocol?
    var ToDoPresenter: GTPresenterProtocol?
}

//MARK: Protocol requirement implementation
extension GTInteractor {
    
    //MARK: Fetch All ToDo items
    func fetchToDoList() {
        ToDoWorker?.fetchToDoList(completion: {[weak self] todoResult in
            switch todoResult {
            case .Success(let todoList):
                self?.ToDoPresenter?.didFetchToDoList(todoList)
            case .Failure(let error):
                self?.ToDoPresenter?.bindError(error)
            }
        })
    }
    
    //MARK: Delete All ToDo items
    func deleteAllItems() {
        privateQueues.customSerialQueue.async {
            self.ToDoWorker?.flushDB()
            self.fetchToDoList()
        }
    }
    
    //MARK: Delete single ToDo items
    func deleteToDoItem(_ todoItem:GTListDataModelProtocol) {
        privateQueues.customSerialQueue.async {
            self.ToDoWorker?.deleteItem(todoItem)
            self.fetchToDoList()
        }
    }
    
    //MARK: Insert/Update single ToDo item
    func insertToDoItem(_ title:String, _ description:String, _ id:UUID, _ isUpdate:Bool){
        privateQueues.customSerialQueue.async {
            if isUpdate{
                self.ToDoWorker?.updateItem(GTListDataModel(id: id, name: title, description: description))
            }else{
                self.ToDoWorker?.insertToDoItem(GTListDataModel(id: id, name: title, description: description))
            }
            self.fetchToDoList()
        }
    }
}

