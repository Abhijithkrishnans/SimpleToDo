//
//  GTUtilities.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 30/03/22.

import Foundation
import UIKit
//MARK: Data Parser Helpers
enum GTUtilities {
    func getDecodedBundleData<T:Codable>(WithName name:String, ext:String, type:T.Type) -> T? {
        let loadedDataModel:T?
        guard let data = getDataFromBundle(WithName: name, ext: ext)  else {
            return nil
        }
        let decoder = JSONDecoder()
        loadedDataModel = try? decoder.decode(type.self, from: data)
        return loadedDataModel
    }
    func getDataFromBundle(WithName name:String, ext:String) -> Data? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: ext) else {
            return nil
        }
        guard let data = try? Data(contentsOf: bundleURL)  else {
            return nil
        }
        return data
    }
    func getDecodedData<T:Codable>(type:T.Type, data:Data) -> T? {
        let decoder = JSONDecoder()
        let loadedDataModel:T?
        loadedDataModel = try? decoder.decode(type.self, from: data)
        return loadedDataModel
    }
}

//MARK:- Custom Queues
enum privateQueues {
    static let customSerialQueue = DispatchQueue(label: "Private Serial Queue", qos: .userInitiated)
}
