//
//  GTDataModel.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 30/03/22.
//

import Foundation
//MARK: Data Model Protocol
//Define necessary data model attributes
protocol GTListDataModelProtocol {
    var id:UUID {get set}
    var name:String? {get set}
    var description:String? {get set}
}

// MARK: ToDo List Data model
struct GTListDataModel:Codable,GTListDataModelProtocol {
    var id:UUID
    var name:String?
    var description:String?
}

//MARK: Map to Data Model
extension ToDoList {
    func mapToDoDataModel() -> GTListDataModelProtocol  {
        GTListDataModel(id: todoid ?? UUID(), name: todoname, description: tododescription)
    }
}
