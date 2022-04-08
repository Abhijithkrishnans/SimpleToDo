//
//  DIContainer.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 30/03/22.

import Foundation
import UIKit

//MARK: Dependency Injection
struct DIContainer {
    static func bootstrapView<T>(_ item:DIItems<T>) -> UIViewController? {
        switch item {
        case .ToDoList(let injectedView):
            //MARK: Initialise components.
            guard let view = injectedView as? GTListView else {
                fallthrough
            }
            return getListView(view)
        @unknown default:
            return nil
        }
    }
}

//MARK: Dependencies
extension DIContainer {
    static func getListView(_ view:GTListView) -> GTListView {
        let presenter = GTPresenter()
        let router = GTListRouter()
        let dbHelper = CFCoreDataHelper.shared
        let dbWorker = GTWorker(dbHelper)
        let interactor = GTInteractor()
       interactor.ToDoWorker = dbWorker

       //MARK: link VIP components.
       view.GTListInteractor = interactor
        view.GTListRouter = router
       presenter.GTView = view
       interactor.ToDoPresenter = presenter
       return view
    }
}

//MARK: Dependency Identifier
extension DIContainer {
    enum DIItems<T> {
        case ToDoList(T)
    }
}
