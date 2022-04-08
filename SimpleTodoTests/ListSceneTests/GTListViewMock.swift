//
//  GTListViewMock.swift
//  SimpleTodoTests
//
//  Created by Abhijithkrishnan on 02/04/22.
//

import UIKit
import XCTest
@testable import SimpleTodo
class GTListViewMock: ToDoViewProtocol {
    var GTListInteractor: GTInteractorProtocol?
    var exp:XCTestExpectation?
    var GTListRouter: GTRouterProtocol?
    var toDoList = [GTListDataModelProtocol]()
    func didFetchToDoList(_ todoList: [GTListDataModelProtocol]) {
        self.toDoList = todoList
        exp?.fulfill()
        calledMethods.append(.didFetchToDoList)
    }
    
    func bindError(_ error: Error) {
        exp?.fulfill()
        calledMethods.append(.bindError)
    }
    //MARK:- Test Helpers
    enum CalledMethods:Equatable {
        case didFetchToDoList
        case bindError
        static func == (lhs:GTListViewMock.CalledMethods, rhs:GTListViewMock.CalledMethods) -> Bool {
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
extension GTListViewMock {
    func calledMethod(_ method: CalledMethods) -> Bool {
        return calledMethods.first(where: {$0 == method}) != nil
    }
    func numberOfTimesCalled(_ method: CalledMethods) -> Int {
        return calledMethods.filter({$0 == method }).count
    }
}

