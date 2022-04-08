//
//  GTCommonExtensions.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 30/03/22.

import Foundation
import UIKit

//MARK: ALERT EXTENSIONS
extension UIAlertController {
   static func showAlert(title:String, message:String,cancelButtonTitle:String,otherButtons:NSArray, preferredStyle:UIAlertController.Style, vwController:UIViewController, completion: @escaping (_ action: UIAlertAction,_ index:Int) -> Void)    {
        var clickedIndex:Int = 0
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alertController.addAction(UIAlertAction(title:cancelButtonTitle, style: .cancel, handler:{ action in
            DispatchQueue.main.async {
                completion(action,0)
            }
        }))
        for title in otherButtons{
            clickedIndex+=1
            alertController.view.tag = clickedIndex;
            let singleButton = UIAlertAction(title: title as? String, style: .default, handler:{ action in
                DispatchQueue.main.async {
                    completion(action,alertController.actions.firstIndex(of: action) ?? 0)
                    
                }
            })
            alertController.addAction(singleButton)
        }
        DispatchQueue.main.async {
            vwController.present(alertController, animated: true, completion: nil)
        }
    }
}
