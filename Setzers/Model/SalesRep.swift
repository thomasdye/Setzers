//
//  SalesRep.swift
//  Setzers
//
//  Created by Thomas Dye on 10/14/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import Foundation

class SalesRep: Decodable {
  var name: String
  var phoneNumber: String
  var emailAddress: String
  
  init(name: String, phoneNumber: String, emailAddress: String) {
    self.name = name
    self.phoneNumber = phoneNumber
    self.emailAddress = emailAddress
  }
}

// Create Sales Reps
let ed = SalesRep(name: "Ed", phoneNumber: "1234567890", emailAddress: "ed@email.com")
let kelly = SalesRep(name: "Kelly", phoneNumber: "1234567890", emailAddress: "kelly@email.com")
let greg = SalesRep(name: "Greg", phoneNumber: "1234567890", emailAddress: "greg@email.com")
let scott = SalesRep(name: "Scott", phoneNumber: "1234567890", emailAddress: "scott@email.com")
let jason = SalesRep(name: "Jason", phoneNumber: "1234567890", emailAddress: "jason@email.com")
let lori = SalesRep(name: "Lori", phoneNumber: "1234567890", emailAddress: "lori@email.com")
let pete = SalesRep(name: "Pete", phoneNumber: "1234567890", emailAddress: "pete@email.com")
let frank = SalesRep(name: "Frank", phoneNumber: "1234567890", emailAddress: "frank@email.com")
let ken = SalesRep(name: "Ken", phoneNumber: "1234567890", emailAddress: "ken@email.com")
let blake = SalesRep(name: "Blake", phoneNumber: "1234567890", emailAddress: "blake@email.com")
let berka = SalesRep(name: "Berka", phoneNumber: "1234567890", emailAddress: "berka@email.com")
let michael = SalesRep(name: "Michael", phoneNumber: "1234567890", emailAddress: "michael@email.com")
