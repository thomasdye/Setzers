//
//  OrderViewController.swift
//  Setzers
//
//  Created by Thomas Dye on 9/4/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation

class OrderViewController: UIViewController, MFMailComposeViewControllerDelegate {
  
  // Outlets
  @IBOutlet weak var orderNumberTextField: UITextField!
  @IBOutlet weak var customerLastNameTextField: UITextField!
  @IBOutlet weak var completedSwitch: UISwitch!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var issuesTextView: UITextView!
  @IBOutlet weak var describeIssuesLabel: UILabel!
  @IBOutlet weak var salesRepTextField: UITextField!
  @IBOutlet weak var customerAddressButton: UIButton!
  @IBOutlet weak var customerPhoneNumberButton: UIButton!
  
  // Custom Colors
  let blackCGColor: CGColor = CGColor(srgbRed: 0,
                                      green: 0,
                                      blue: 0,
                                      alpha: 1)
  
  let blackFadedCGColor: CGColor = CGColor(srgbRed: 0,
                                           green: 0,
                                           blue: 0,
                                           alpha: 0.1)
  
  let redTextColor: UIColor = UIColor(red: 0.77,
                                      green: 0.29,
                                      blue: 0.48,
                                      alpha: 1.00)
  
  var selectedOrder: Order = Order(stopNumber: 1,
                                   orderNumber: "",
                                   orderDetails: "",
                                   customerName: "",
                                   customerPhoneNumber: "",
                                   customerAddress: "",
                                   salesRep: SalesRep(name: "",
                                                      phoneNumber: "",
                                                      emailAddress: ""),
                                   orderCompleted: false)
  let defaults = UserDefaults.standard
  
  // Variables
  var selectedSalesRep = ""
  var salesRep: SalesRep = SalesRep(name: "", phoneNumber: "", emailAddress: "")
  var currentTime: String = ""
  
  // View Did Load
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUserInterface()
    loadFromDefaults()
    print("selected order complete: \(selectedOrder.orderCompleted)")
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if orderNumberTextField.text != "" && customerLastNameTextField.text != "" {
      if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0 {
          self.view.frame.origin.y -= keyboardSize.height
        }
      }
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
      self.view.frame.origin.y = 0
    }
  }
  
  // Set Up User Interface
  func setUpUserInterface() {
    // Order Number Text Field
    orderNumberTextField.textAlignment = .center
    orderNumberTextField.placeholder = "254232"
    orderNumberTextField.keyboardType = .numberPad
    orderNumberTextField.layer.borderColor = blackCGColor
    orderNumberTextField.layer.borderWidth = 1
    orderNumberTextField.layer.borderWidth = 1
    orderNumberTextField.layer.cornerRadius = 5
    orderNumberTextField.textColor = redTextColor
    orderNumberTextField.text = selectedOrder.orderNumber
    self.orderNumberTextField.addDoneButton(title: "Done",
                                            target: self,
                                            selector: #selector(tapDone(sender:)))
    
    // Customer Last Name Text Field
    customerLastNameTextField.textAlignment = .center
    customerLastNameTextField.placeholder = "Johnson"
    customerLastNameTextField.layer.borderColor = blackCGColor
    customerLastNameTextField.layer.borderWidth = 1
    customerLastNameTextField.layer.cornerRadius = 5
    customerLastNameTextField.textColor = redTextColor
    customerLastNameTextField.text = selectedOrder.customerName
    self.customerLastNameTextField.addDoneButton(title: "Done",
                                                 target: self,
                                                 selector: #selector(tapDone(sender:)))
    
    // Sales Rep Text Field
    salesRepTextField.textAlignment = .center
    salesRepTextField.placeholder = "Michael"
    salesRepTextField.layer.borderColor = blackCGColor
    salesRepTextField.layer.borderWidth = 1
    salesRepTextField.layer.borderWidth = 1
    salesRepTextField.layer.cornerRadius = 5
    salesRepTextField.textColor = redTextColor
    salesRepTextField.text = selectedOrder.salesRep.name
    self.orderNumberTextField.addDoneButton(title: "Done",
                                            target: self,
                                            selector: #selector(tapDone(sender:)))
    
    // Issues Text View
    issuesTextView.isSelectable = true
    issuesTextView.text = ""
    issuesTextView.layer.borderWidth = 1
    issuesTextView.layer.cornerRadius = 5
    issuesTextView.layer.borderColor = blackCGColor
    issuesTextView.tintColor = redTextColor
    issuesTextView.textColor = redTextColor
    issuesTextView.textAlignment = .center
    self.issuesTextView.addDoneButton(title: "Done",
                                      target: self,
                                      selector: #selector(tapDone(sender:)))
    
    // Customer Address Button
    customerAddressButton.setTitle(selectedOrder.customerAddress, for: .normal)
    
    // Customer Phone Number Button
    customerPhoneNumberButton.setTitle(selectedOrder.customerPhoneNumber, for: .normal)
    
    // Submit Button
    submitButton.layer.cornerRadius = 5
    submitButton.layer.backgroundColor = CGColor(red: 0.77, green: 0.29, blue: 0.48, alpha: 1.00)
    
    // Completed Switch
    completedSwitch.isOn = false
    completedSwitch.onTintColor = redTextColor
    
  }
  
  // Check Inputs For Issues
  func checkForCompletedField() {
    // Missing Order Number
    if orderNumberTextField.text == "" {
      let alert = UIAlertController(title: "Order Number Empty",
                                    message: "You did not enter an order number.",
                                    preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "OK",
                                    style: .destructive,
                                    handler: nil))
      self.present(alert, animated: true)
      return
    }
    
    // Missing Customer Last Name
    if customerLastNameTextField.text == "" {
      let alert = UIAlertController(title: "Custmer Last Name Empty",
                                    message: "You did not enter the customer's last name.",
                                    preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "OK",
                                    style: .destructive,
                                    handler: nil))
      self.present(alert, animated: true)
      return
    }
    
    // Sales Rep Not Selected
    
    // Issues Text Not Filled Out
    if issuesTextView.text == "" && completedSwitch.isOn == false {
      let alert = UIAlertController(title: "Issues Missing",
                                    message: "You did not fill out the issues.",
                                    preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "OK",
                                    style: .destructive,
                                    handler: nil))
      self.present(alert, animated: true)
      return
    }
    submitOrderDetails()
  }
  
  // Capitalize Last Name
  func capitalizeLastName(lastName: String) -> String {
    return lastName.capitalizingFirstLetter()
  }
  
  // Call Phone Number
  private func callNumber(phoneNumber:String) {
    let phoneNumberToCall = phoneNumber.replacingOccurrences(of: "-", with: "")
    if let phoneCallURL = URL(string: "tel://\(phoneNumberToCall)") {
      let application:UIApplication = UIApplication.shared
      if (application.canOpenURL(phoneCallURL)) {
        application.open(phoneCallURL, options: [:], completionHandler: nil)
      }
    }
  }
  
  // Switch Function For Mail Results
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    switch result {
    case .cancelled:
      print("Mail cancelled")
      self.dismiss(animated: true, completion: messageCancelledAlert)
    case .saved:
      print("Mail saved")
      self.dismiss(animated: true, completion: messageSavedAlert)
    case .sent:
      print("Mail sent")
      self.dismiss(animated: true, completion: messageSentAlert)
    case .failed:
      print("Mail failed to send")
      self.dismiss(animated: true, completion: messageFailedAlert)
    default:
      break
    }
  }
  
  // Get Current Time
  func getCurrentTime() {
    let currentDateTime = Date()
    let dateFomatter = DateFormatter()
    dateFomatter.amSymbol = "AM"
    dateFomatter.pmSymbol = "PM"
    dateFomatter.dateFormat = "h:mma 'on' MM/dd/yyyy"
    let dateResult = dateFomatter.string(from: currentDateTime)
    currentTime = "\(dateResult)"
  }
  
  // Create Alert To Show After Mail Has Been Cancelled
  func messageCancelledAlert() {
    let alertController = UIAlertController(title: "Message Cancelled",
                                            message: "Your message was cancelled.",
                                            preferredStyle: .actionSheet)
    
    let OKAction = UIAlertAction(title: "OK",
                                 style: .default) { (action:UIAlertAction!) in print("Message cancelled")
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion:nil)
    deleteFromDefaults()
  }
  
  // Create Alert To Show After Mail Has Been Successfully Sent
  func messageSentAlert() {
    let alertController = UIAlertController(title: "Message Sent",
                                            message: "Your message was successfully sent!",
                                            preferredStyle: .actionSheet)
    
    let OKAction = UIAlertAction(title: "OK",
                                 style: .default) { (action:UIAlertAction!) in print("Message sent")
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion:nil)
    
  }
  
  // Create Alert To Show After Mail Has Been Saved
  func messageSavedAlert() {
    let alertController = UIAlertController(title: "Message Saved",
                                            message: "Your message was successfully saved.",
                                            preferredStyle: .actionSheet)
    
    let OKAction = UIAlertAction(title: "OK",
                                 style: .default) { (action:UIAlertAction!) in print("Message saved")
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion:nil)
    
  }
  
  // Create Alert To show After Mail Has Failed To Send
  func messageFailedAlert() {
    let alertController = UIAlertController(title: "Message Sending Failed",
                                            message: "Your message failed to send. Please check your connection and try again.",
                                            preferredStyle: .actionSheet)
    
    let OKAction = UIAlertAction(title: "OK",
                                 style: .default) { (action:UIAlertAction!) in print("Message failed to send.")
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion:nil)
    
  }
  
  // Save To Defaults
  func saveToDefaults() {
    defaults.set(true, forKey: "\(selectedOrder.orderNumber)")
  }
  
  func deleteFromDefaults() {
    defaults.removeObject(forKey: "\(selectedOrder.orderNumber)")
  }
  
  // Load From Defaults
  func loadFromDefaults() {
    let completedBool = UserDefaults.standard.bool(forKey: "\(selectedOrder.orderNumber)")
    print("loaded order number: \(selectedOrder.orderNumber) with completion: \(completedBool)")
    selectedOrder.orderCompleted = completedBool
    
    if completedBool == true {
      submitButton.isEnabled = false
      completedSwitch.isOn = true
    }
  }
  
  // Submit Order Details
  func submitOrderDetails() {
    // Unwrap Text
    guard let orderNumber = orderNumberTextField.text,
          let customerLastName = customerLastNameTextField.text,
          let issues = issuesTextView.text else { return }
    
    let lastName = capitalizeLastName(lastName: customerLastName)
    getCurrentTime()
    
    // If There Are No Issues When Submitting Order
    if completedSwitch.isOn == true {
      
      let newOrderToSubmit = OrderDetails(orderNumber: orderNumber,
                                          customerLastName: lastName,
                                          salesRepresentative: selectedSalesRep,
                                          completed: true,
                                          issuesDetails: issues)
      
      let emailTitle = "Order \(newOrderToSubmit.orderNumber) - \(newOrderToSubmit.customerLastName)"
      let messageBody = "Order was successfully completed at \(currentTime)."
      let toRecipents = [selectedOrder.salesRep.emailAddress, "tdye@setzers.net"]
      let mc: MFMailComposeViewController = MFMailComposeViewController()
      mc.mailComposeDelegate = self
      mc.setSubject(emailTitle)
      mc.setMessageBody(messageBody, isHTML: false)
      mc.setToRecipients(toRecipents)
      self.present(mc, animated: true, completion: nil)
      selectedOrder.orderCompleted = true
      saveToDefaults()
      print("selected order complete: \(selectedOrder.orderCompleted)")
      return
    }
    
    // If There Are Issues When Submitting Order
    if completedSwitch.isOn == false {
      let newOrderToSubmit = OrderDetails(orderNumber: orderNumber,
                                          customerLastName: lastName,
                                          salesRepresentative: selectedSalesRep,
                                          completed: true,
                                          issuesDetails: issues)
      
      let emailTitle = "Order \(newOrderToSubmit.orderNumber) - \(newOrderToSubmit.customerLastName) - Issues"
      let messageBody = "There were issues completing this install at \(currentTime).\n\nIssues: \(newOrderToSubmit.issuesDetails)"
      let toRecipents = [selectedOrder.salesRep.emailAddress, "tdye@setzers.net"]
      let mc: MFMailComposeViewController = MFMailComposeViewController()
      
      mc.mailComposeDelegate = self
      mc.setSubject(emailTitle)
      mc.setMessageBody(messageBody, isHTML: false)
      mc.setToRecipients(toRecipents)
      self.present(mc, animated: true, completion: nil)
      selectedOrder.orderCompleted = true
      saveToDefaults()
      return
    }
  }
  
  @IBAction func customerAddressButtonTapped(_ sender: UIButton) {
    
    let myAddress = selectedOrder.customerAddress
    let geoCoder = CLGeocoder()
    geoCoder.geocodeAddressString(myAddress) { (placemarks, error) in
      guard let placemarks = placemarks?.first else { return }
      let location = placemarks.location?.coordinate ?? CLLocationCoordinate2D()
      guard let url = URL(string:"http://maps.apple.com/?daddr=\(location.latitude),\(location.longitude)") else { return }
      UIApplication.shared.open(url)
    }
    print(selectedOrder.customerAddress)
    
  }
  @IBAction func customerPhoneNumberButtonTapped(_ sender: UIButton) {
    
    callNumber(phoneNumber: selectedOrder.customerPhoneNumber)
  }
  
  // Completed Switch Changed
  @IBAction func completedSwitchTapped(_ sender: UISwitch) {
    if completedSwitch.isOn == true {
      issuesTextView.isEditable = false
      issuesTextView.text = ""
      issuesTextView.layer.borderColor = blackFadedCGColor
      describeIssuesLabel.textColor = UIColor(cgColor: blackFadedCGColor)
    } else if completedSwitch.isOn == false {
      issuesTextView.isEditable = true
      issuesTextView.text = ""
      issuesTextView.layer.borderColor = blackCGColor
      describeIssuesLabel.textColor = UIColor(cgColor: blackCGColor)
    }
  }
  
  // Submit Button Tapped
  @IBAction func submitButtonTapped(_ sender: Any) {
    checkForCompletedField()
  }
  
  // Tap Done On Keyboard Tapped
  @objc func tapDone(sender: Any) {
    self.view.endEditing(true)
  }
}

// Add Done Button To Text Field Keyboard Extension
extension UITextField {
  func addDoneButton(title: String, target: Any, selector: Selector) {
    let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                          y: 0.0,
                                          width: UIScreen.main.bounds.size.width,
                                          height: 44.0))
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                   target: nil, action: nil)
    let barButton = UIBarButtonItem(title: title,
                                    style: .plain,
                                    target: target,
                                    action: selector)
    toolBar.setItems([flexible, barButton], animated: false)
    self.inputAccessoryView = toolBar
  }
}

// Add Done Button To Text View Keyboard Extension
extension UITextView {
  func addDoneButton(title: String, target: Any, selector: Selector) {
    let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                          y: 0.0,
                                          width: UIScreen.main.bounds.size.width,
                                          height: 44.0))
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                   target: nil,
                                   action: nil)
    let barButton = UIBarButtonItem(title: title,
                                    style: .plain,
                                    target: target,
                                    action: selector)
    toolBar.setItems([flexible, barButton], animated: false)
    self.inputAccessoryView = toolBar
  }
}

// Extension To Capitalize First Letter
extension String {
  func capitalizingFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}
