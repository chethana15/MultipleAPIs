//
//  UsersModel.swift
//  MultipleAPIs
//
//  Created by Cumulations Technologies Private Limited on 27/06/23.
//

import Foundation

struct User: Codable{
    
    let id : Int
    let name : String
    let username : String
    let phone : String
    let website : String
    let company : Company
    let address : Address
}

struct Geo : Codable{
    
    let lat : String
    let lng : String
    
}

struct Address: Codable{
    
    let street : String
    let suite : String
    let city : String
    let zipcode : String
    let geo : Geo
    
}

struct Company: Codable{
    let name : String
    let catchPhrase : String
    let bs : String
}

