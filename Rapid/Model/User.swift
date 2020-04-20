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
    
    var street: String
    var suite: String
    var city: String
    var zipCode: String
    
    var lat: String
    var lng: String
    
    var phone: String
    var website: String
    
    var companyName: String
    var catchPhrase: String
    var bs: String
    
    enum TopCodingKeys: String, CodingKey {
        case id
        case name
        case userName = "username"
        case email
        case address
        case phone
        case website
        case company
    }
    
    enum AddressCodingKeys: String, CodingKey {
        case street
        case city
        case suite
        case zipCode = "zipcode"
        case geo
    }
    
    enum GeoCodingKeys: String, CodingKey {
        case lat
        case lng
    }
    
    enum CompanyCodingKeys: String, CodingKey {
        case companyName = "name"
        case catchPhrase
        case bs
    }
}

extension User {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopCodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.website = try container.decode(String.self, forKey: .website)
        
        let addressContainer = try container.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: .address)
        self.street = try addressContainer.decode(String.self, forKey: .street)
        self.city = try addressContainer.decode(String.self, forKey: .city)
        self.suite = try addressContainer.decode(String.self, forKey: .suite)
        self.zipCode = try addressContainer.decode(String.self, forKey: .zipCode)
        
        let geoContainer = try addressContainer.nestedContainer(keyedBy: GeoCodingKeys.self, forKey: .geo)
        self.lat = try geoContainer.decode(String.self, forKey: .lat)
        self.lng = try geoContainer.decode(String.self, forKey: .lng)
        
        let companyContainer = try container.nestedContainer(keyedBy: CompanyCodingKeys.self, forKey: .company)
        self.companyName = try companyContainer.decode(String.self, forKey: .companyName)
        self.catchPhrase = try companyContainer.decode(String.self, forKey: .catchPhrase)
        self.bs = try companyContainer.decode(String.self, forKey: .bs)
    }
    
}

struct UsersList: Codable {
    let results: [User]
}
