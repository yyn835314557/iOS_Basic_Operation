/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import MapKit

class AddressTableView: UITableView {
  
  var mainViewController: ViewController!
  var addresses: [String]!
  var placemarkArray: [CLPlacemark]!
  var currentTextField: UITextField!
  var sender: UIButton!
  
  override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
    self.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AddressCell")
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

extension AddressTableView: UITableViewDelegate {

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 80
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.font = UIFont(name: "HoeflerText-Black", size: 18)
    label.textAlignment = .Center
    label.text = "Did you mean..."
    label.backgroundColor = UIColor(red: 240.0/255.0, green: 229.0/255.0, blue: 141.0/225.0, alpha: 1)
    
    return label
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // 2.x.1 when the row is less than the length of the address array
    if addresses.count > indexPath.row{
        // 2.x.2 update the current text field to contain the selected address
        currentTextField.text = addresses[indexPath.row]
        // 2.x.3
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: placemarkArray[indexPath.row].location!.coordinate, addressDictionary: placemarkArray[indexPath.row].addressDictionary as![String:AnyObject]? ))
        mainViewController.locationTuples[currentTextField.tag-1].mapItem = mapItem
        // 2.x.4 selected the current enter button
        sender.selected = true
    }
    removeFromSuperview()
  }
}

extension AddressTableView: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return addresses.count + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell") as UITableViewCell!
    cell.textLabel?.numberOfLines = 3
    cell.textLabel?.font = UIFont(name: "HoeflerText-Regular", size: 11)
    
    if addresses.count > indexPath.row {
      cell.textLabel?.text = addresses[indexPath.row]
    } else {
      cell.textLabel?.text = "None of the above"
    }
    return cell
  }
}