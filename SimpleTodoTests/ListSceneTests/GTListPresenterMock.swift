//
//  class GTListPresenterMock.swift
//  SimpleTodoTests
//
//  Created by Abhijithkrishnan on 02/04/22.
//

import UIKit
@testable import SimpleTodo
class GTListPresenterMock: GTPresenterProtocol {
  weak var GTView: ToDoViewProtocol?
    
    func didFetchToDoList(_ todoList: [GTListDataModelProtocol]) {
        GTView?.didFetchToDoList(todoList)
        calledMethods.append(.didFetchToDoList)
    }
    
    func bindError(_ error: Error) {
        GTView?.bindError(error)
        calledMethods.append(.bindError)
    }
    //MARK:- Test Helpers
    enum CalledMethods:Equatable {
        case didFetchToDoList
        case bindError
        static func == (lhs:GTListPresenterMock.CalledMethods, rhs:GTListPresenterMock.CalledMethods) -> Bool {
            switch (lhs,rhs) {
            case (.didFetchToDoList, .didFetchToDoList),
                 (.bindError, .bindError):
                return true
            default:
                return false
            }
        }
    }
    var calledMethods = [CalledMethods]()
}
extension GTListPresenterMock {
    func calledMethod(_ method: CalledMethods) -> Bool {
        return calledMethods.first(where: {$0 == method}) != nil
    }
    func numberOfTimesCalled(_ method: CalledMethods) -> Int {
        return calledMethods.filter({$0 == method }).count
    }
}

