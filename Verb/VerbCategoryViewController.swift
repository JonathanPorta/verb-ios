//
//  VerbCategoryViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 10/21/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import UIKit

class VerbCategoryViewController : UITableViewController {

  var categoryList: NSMutableArray = []

  override func viewDidLoad() {

    super.viewDidLoad()

    // get the initial data
    loadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->
    Int {
      return self.categoryList.count
    }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
    //var activityModel: ActivityModel = self.categoryList.objectAtIndex(indexPath.row) as ActivityModel
    cell.textLabel.text = "hi"//activityModel.activityMessage
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("You selected cell #\(indexPath.row)")
  }

  func loadData() {
    self.tableView.reloadData()
  }
}