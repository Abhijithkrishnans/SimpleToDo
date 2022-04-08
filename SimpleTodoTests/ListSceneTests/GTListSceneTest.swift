//
//  GTListSceneTest.swift
//  SimpleTodoTests
//
//  Created by Abhijithkrishnan on 02/04/22.
//

import XCTest
import CoreData
@testable import SimpleTodo
class GTListSceneTest: XCTestCase {
    var SUT:GTListViewMock = GTListViewMock()
    let presenter = GTListPresenterMock()
    let interactor = GTListInteractorMock()
    let worker = GTListWorkerMock()
    let router = GTListRouter()
    let id:UUID = UUID(uuidString: "EE8857EF-E2CE-44FF-8FDC-8DC9254A8022") ?? UUID()
    func bootstrapView(){

       interactor.ToDoWorker = worker

       //MARK: link VIP components.
        SUT.GTListInteractor = interactor
        SUT.GTListRouter = router
        SUT.exp = self.expectation(description: "Completion of view didFetch/didFailed")
       presenter.GTView = SUT
       interactor.ToDoPresenter = presenter
        
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        bootstrapView()
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testCompleteFetchSuccessFlow() {
        
        // Initiate Fetch ToDo with expected input model
        SUT.GTListInteractor?.fetchToDoList()
        
        //*** Wait for expectation as we are having asynchronous call in between the flow ***
        waitForExpectations(timeout: 1)
        
        //** All the fetched interfaces should only called once
        XCTAssertTrue(SUT.calledMethod(.didFetchToDoList))
        XCTAssertTrue(SUT.numberOfTimesCalled(.didFetchToDoList) == 1)
        
        XCTAssertTrue(interactor.calledMethod(.fetchToDoList))
        XCTAssertTrue(interactor.numberOfTimesCalled(.fetchToDoList) == 1)
        
        XCTAssertTrue(presenter.calledMethod(.didFetchToDoList))
        XCTAssertTrue(presenter.numberOfTimesCalled(.didFetchToDoList) == 1)
        
        XCTAssertTrue(worker.calledMethod(.fetchToDoList))
        XCTAssertTrue(worker.numberOfTimesCalled(.fetchToDoList) == 1)
        
    }
    func testCompleteInsertFlow() {
        
        SUT.GTListInteractor?.insertToDoItem("Test", "TestDes", id, false)
       //*** Wait for expectation as we are having asynchronous call in between the flow ***
       waitForExpectations(timeout: 1)
       
        //** All the fetched interfaces should only called once
       
       
       XCTAssertTrue(interactor.calledMethod(.insertToDoItem))
       XCTAssertTrue(interactor.numberOfTimesCalled(.insertToDoItem) == 1)
              
       XCTAssertTrue(worker.calledMethod(.insertToDoItem))
       XCTAssertTrue(worker.numberOfTimesCalled(.insertToDoItem) == 1)
       
        XCTAssertTrue(SUT.calledMethod(.didFetchToDoList))
        XCTAssertTrue(SUT.numberOfTimesCalled(.didFetchToDoList) == 1)
        
        XCTAssertTrue(interactor.calledMethod(.fetchToDoList))
        XCTAssertTrue(interactor.numberOfTimesCalled(.fetchToDoList) == 1)
        
        XCTAssertTrue(presenter.calledMethod(.didFetchToDoList))
        XCTAssertTrue(presenter.numberOfTimesCalled(.didFetchToDoList) == 1)
        
        XCTAssertTrue(worker.calledMethod(.fetchToDoList))
        
        XCTAssertTrue(worker.numberOfTimesCalled(.fetchToDoList) == 1)
        XCTAssertNotNil(SUT.toDoList.first?.id)
        XCTAssertEqual(SUT.toDoList.first?.name, "Test")
    }
    func testCompleteUpdateFlow() {
        SUT.GTListInteractor?.insertToDoItem("Update", "TestDes", id, true)
         //*** Wait for expectation as we are having asynchronous call in between the flow ***
         waitForExpectations(timeout: 1)

        XCTAssertTrue(interactor.calledMethod(.insertToDoItem))
        XCTAssertTrue(interactor.numberOfTimesCalled(.insertToDoItem) == 1)
        
    }
    func testCompleteDeleteFlow() {
        SUT.GTListInteractor?.deleteToDoItem(GTListDataModel(id: id, name: "Update", description: "TestDes"))
//         *** Wait for expectation as we are having asynchronous call in between the flow ***
         waitForExpectations(timeout: 1)
        XCTAssertTrue(interactor.calledMethod(.deleteToDoItem))
        XCTAssertTrue(interactor.numberOfTimesCalled(.deleteToDoItem) == 1)
        XCTAssertNil(SUT.toDoList.first?.id)
    }
}
