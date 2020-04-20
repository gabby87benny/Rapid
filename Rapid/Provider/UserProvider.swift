//
//  UserProvider.swift
//  Rapid
//
//  Created by Joseph Peter, Gabriel Benny Francis on 1/13/20.
//  Copyright © 2020 Gabby. All rights reserved.
//

import UIKit

struct URLConstants {
    static let userUrl = "https://jsonplaceholder.typicode.com/users"
}

enum RapidError: Error {
    case RapidErrorNone
    case RapidErrorNetwork
    case RapidErrorOther
}

enum Result {
    case success([User])
    case failure(Error)
}

class UserProvider: NSObject {
    var users: [User] = []
    typealias QueryResult = (Result) -> ()
    lazy var defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }()
    var dataTask : URLSessionDataTask?
    let decoder = JSONDecoder()
    var rapidError = RapidError.RapidErrorNone
    
    func getUsers(completion: @escaping QueryResult) {
        dataTask?.cancel()
        guard let url = URL(string: URLConstants.userUrl) else {
            return
        }
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            if error != nil {
                completion(.failure(RapidError.RapidErrorNetwork))
            }
            else if let data = data {
                self.updateResults(data)
                DispatchQueue.main.async {
                    completion(.success(self.users))
                }
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
        catch {
            self.rapidError = RapidError.RapidErrorOther
            return
        }
    }
    
}
