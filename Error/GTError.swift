//
//  GTError.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 30/03/22.

import Foundation

// MARK: ToDo Error
///Define custom errors if need be
// MARK: ToDo Result
enum GTRecipeResult<T>{
    case Success(T)
    case Failure(Error)
}
