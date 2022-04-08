//
//  HFConstants.swift
//  iOS Test
//
//  Created by Abhijithkrishnan on 26/03/21.
//

import Foundation

enum GTConstants {
    
    enum fieldNames {
        static let JSON = ".json"
        static let NA = "NA"
        static let Ok = "Ok"
        static let Yes = "Yes"
        static let No = "No"
        static let Save = "Save"
        static let Update = "Update"
        static let Cancel = "Cancel"
        static let empty = ""
        static let space = " "
        static let code = "code"
    }
    enum screenTitle {
        static let todo = "ToDo Items"
        static let addtodo = "Add ToDo"
        static let updatetodo = "Update ToDo"
        
    }
    enum placeholder {
        static let addtodoname = "*Title"
        static let addtododescription = "*Short description"
    }
    enum alertMessage {
        static let deleteAll = "Do you want to delete all todo items?"
        static let deletesingle = "Do you want to delete selected todo item?"
        static let addToDoMessage = "Enter below mandatory fields for aading/updating new ToDo item"
    }
}
