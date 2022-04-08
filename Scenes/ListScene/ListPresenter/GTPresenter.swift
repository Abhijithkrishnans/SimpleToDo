//
//  GTPresenter.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 30/03/22.
//

import Foundation
//MARK: Presenter protocol
protocol GTPresenterProtocol {
    /// Presenter to View Connecter requirement
    /// Should only keep weak reference while confirming with view to avoid retain cycles
    var GTView: ToDoViewProtocol? { get set }
    
    /// Default fetch/Fail handler interfaces
    /// ToDo Fetching interfaces
    func didFetchToDoList(_ todoList:[GTListDataModelProtocol])
    func bindError(_ error:Error)
}
class GTPresenter: GTPresenterProtocol {
    weak var GTView: ToDoViewProtocol?
}

//MARK: Todo List Fetch precentation Methods
extension GTPresenter {
    func didFetchToDoList(_ todoList:[GTListDataModelProtocol]){
        ///Mapping data model to view model
        GTView?.didFetchToDoList(todoList)
    }
    func bindError(_ error:Error) {
        GTView?.bindError(error)
    }
}
