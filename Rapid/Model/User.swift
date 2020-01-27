//
//  User.swift
//  Rapid
//
//  Created by Joseph Peter, Gabriel Benny Francis on 1/13/20.
//  Copyright © 2020 Gabby. All rights reserved.
//

import UIKit

/*
 {
   "id": 1,
   "name": "Leanne Graham",
   "username": "Bret",
   "email": "Sincere@april.biz",
   "address": {
     "street": "Kulas Light",
     "suite": "Apt. 556",
     "city": "Gwenborough",
     "zipcode": "92998-3874",
     "geo": {
       "lat": "-37.3159",
       "lng": "81.1496"
     }
   },
   "phone": "1-770-736-8031 x56442",
   "website": "hildegard.org",
   "company": {
     "name": "Romaguera-Crona",
     "catchPhrase": "Multi-layered client-server neural-net",
     "bs": "harness real-time e-markets"
   }
 },
 
 */


struct User: Codable {
    var id: Int
    var name: String
    var userName: String
    var email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case userName = "username"
        case email
    }
}

extension User {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.email = try container.decode(String.self, forKey: .email)
    }
}

struct UsersList: Codable {
    let results: [User]
}
