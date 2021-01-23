//
//  OrdersTableViewController.swift
//  Setzers
//
//  Created by Thomas Dye on 10/14/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

class OrdersTableViewController: UITableViewController {
  
  var todaysOrders: [Order] = [orderOne, orderTwo, orderThree, orderFour, orderFive]
  var currentTime: String = ""
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getCurrentTime()
    setupTitle()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
    
  }
  
  func setupTitle() {
    title = "Today's Orders - \(currentTime)"
  }
  
  func getCurrentTime() {
    let currentDateTime = Date()
    let dateFomatter = DateFormatter()
    dateFomatter.dateFormat = "MM/dd/yyyy"
    let dateResult = dateFomatter.string(from: currentDateTime)
    currentTime = "\(dateResult)"
  }
  
  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    let allOrders = [orderOne, orderTwo, orderThree, orderFour]
    return allOrders.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath)
    
    var allOrders = [orderTwo, orderThree, orderFour, orderOne]
    allOrders.sort { $0.stopNumber < $1.stopNumber }
    
    let order = allOrders[indexPath.row]
    cell.textLabel?.text = order.customerName
    cell.detailTextLabel?.text = "Order Number: \(order.orderNumber)"
    
    let completedBool = defaults.bool(forKey: "\(order.orderNumber)")
    
    if completedBool == true {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "orderSegue" {
      
      guard let indexPath = tableView.indexPathForSelectedRow,
            let orderDetailVC = segue.destination as? OrderViewController else { return }
      
      let selectedOrder = todaysOrders[indexPath.row]
      orderDetailVC.selectedOrder = selectedOrder
    }
  }
}


