//
//  UserProvider.swift
//  Rapid
//
//  Created by Joseph Peter, Gabriel Benny Francis on 1/13/20.
//  Copyright © 2020 Gabby. All rights reserved.
//

import UIKit

class UserProvider: NSObject {
    var users: [User] = []
    var errorMessage = ""
    typealias QueryResult = ([User]?, String) -> ()
    lazy var defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }()
    var dataTask : URLSessionDataTask?
    let decoder = JSONDecoder()
    
    func getUsers(completion: @escaping QueryResult) {
        dataTask?.cancel()
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return
        }
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            }
            else if let data = data {
                self.updateResults(data)
            }
            DispatchQueue.main.async {
                completion(self.users, self.errorMessage)
            }
        }
        dataTask?.resume()
    }
    
    func updateResults(_ data: Data) {
        users.removeAll()
        do {
            let list = try decoder.decode([User].self , from: data)
            users = list
        }
        catch let decodeError as NSError {
            self.errorMessage += "Decoder error: \(decodeError.localizedDescription)"
            return
        }
    }
    
}
