//
//  ActivityViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 8/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class ActivityViewController: UITableViewController {

  var activityModelList: NSMutableArray = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    loadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) ->
    Int {
     return self.activityModelList.count
    }
  
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    let CellIndentifier: NSString = "ListPrototypeCell"
    var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIndentifier) as UITableViewCell
    var activityModel: ActivityModel = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    cell.textLabel.text = activityModel.body
    return cell
  }
  
  func loadData() {
    // Load some sample data.
    var activityModel1 = ActivityModel(userId: 0, messageId: 0, body: "You poked Austin!", acknowledgedAt: NSDate(), createdAt: NSDate(), updatedAt: NSDate())
    var activityModel2 = ActivityModel(userId: 0, messageId: 1, body: "You nudged Ricardo!", acknowledgedAt: NSDate(), createdAt: NSDate(), updatedAt: NSDate())
    var activityModel3 = ActivityModel(userId: 0, messageId: 2, body: "You hugged Jessica!", acknowledgedAt: NSDate(), createdAt: NSDate(), updatedAt: NSDate())
    var activityModel4 = ActivityModel(userId: 0, messageId: 3, body: "Jessica Hugged you!", acknowledgedAt: NSDate(), createdAt: NSDate(), updatedAt: NSDate())
    
    self.activityModelList.addObject(activityModel1)
    self.activityModelList.addObject(activityModel2)
    self.activityModelList.addObject(activityModel3)
    self.activityModelList.addObject(activityModel4)
    
  }
}