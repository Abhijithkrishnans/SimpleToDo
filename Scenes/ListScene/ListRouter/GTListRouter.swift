//
//  GTListRouter.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 31/03/22.
//

import Foundation
import UIKit

//MARK: Router protocol
protocol GTRouterProtocol:AnyObject {
    var navigationController: UINavigationController? { get set}
    /// ToDo Navigation interfaces
    func navigateTo(_ destination: UIViewController, isModelPresentation:Bool)
}
class GTListRouter: GTRouterProtocol {
   weak var navigationController: UINavigationController?
}

//MARK: ToDo Navigation interfaces
extension GTListRouter {
    func navigateTo(_ destination: UIViewController, isModelPresentation:Bool) {
        if isModelPresentation {
            navigationController?.present(destination, animated: false)
        }
        else {
            navigationController?.pushViewController(destination, animated: true)
        }
    }
}
