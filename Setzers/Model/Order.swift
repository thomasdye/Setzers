//
//  Order.swift
//  Setzers
//
//  Created by Thomas Dye on 10/14/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import Foundation

struct Records: Decodable {
  let id: String
  let fields: String
  let createdTime: String
}

struct Fields: Decodable {
  let id: String
  let order: Order
  let createdTime: String
}

struct Order: Decodable {
  var stopNumber: Int = 0
  var orderNumber: String = ""
  var orderDetails: String = ""
  var customerName: String = ""
  var customerPhoneNumber: String = ""
  var customerAddress: String = ""
  var salesRep: SalesRep = SalesRep(name: "", phoneNumber: "", emailAddress: "")
  var orderCompleted: Bool = false
}

struct OrderDetails {
  var orderNumber: String = ""
  var customerLastName: String = ""
  var salesRepresentative: String = ""
  var completed: Bool = Bool()
  var issuesDetails: String = ""
}

var orderOne: Order = Order(stopNumber: 1,
                            orderNumber: "1",
                            orderDetails: "",
                            customerName: "Dye",
                            customerPhoneNumber: "1-904-334-5606",
                            customerAddress: "7660 Philips Highway, Jacksonville, FL 32217",
                            salesRep: ken,
                            orderCompleted: false)

var orderTwo: Order = Order(stopNumber: 2,
                            orderNumber: "2",
                            orderDetails: "",
                            customerName: "Dye",
                            customerPhoneNumber: "1-904-334-5606",
                            customerAddress: "11964 Elizabeth Ann Court, Jacksonville, FL, 32223",
                            salesRep: michael,
                            orderCompleted: false)

var orderThree: Order = Order(stopNumber: 3,
                              orderNumber: "3",
                              orderDetails: "",
                              customerName: "Dye",
                              customerPhoneNumber: "1-904-334-5606",
                              customerAddress: "228 Leese Drive, Saint Johns, FL 32259",
                              salesRep: greg,
                              orderCompleted: false)

var orderFour: Order = Order(stopNumber: 4,
                             orderNumber: "4",
                             orderDetails: "",
                             customerName: "Dye",
                             customerPhoneNumber: "1-904-334-5606",
                             customerAddress: "11453 Wandering Pines Lane, Jacksonville, FL 32258",
                             salesRep: blake,
                             orderCompleted: false)
