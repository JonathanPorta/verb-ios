//
//  ActivityViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 8/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class ActivityViewController: UITableViewController, VerbAPIProtocol {
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  var verbAPI: VerbAPI
  var activityModelList: NSMutableArray = []

  required init(coder aDecoder: NSCoder) {
    self.verbAPI = appDelegate.getVerbAPI()
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    var refresh = UIRefreshControl()
    refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refresh.addTarget(self, action:"loadData", forControlEvents:.ValueChanged)
    self.refreshControl = refresh

    loadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if self.activityModelList.count > 0 {
      self.tableView.backgroundView = nil
      self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
      return 1
    }
    else {
      var messageLabel = UILabel(frame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height));

      messageLabel.text = "No data is currently available. Please pull down to refresh."
      messageLabel.numberOfLines = 0
      messageLabel.textAlignment = NSTextAlignment.Center
      messageLabel.font = UIFont(name:"Palatino-Italic", size:20)
      messageLabel.sizeToFit()

      self.tableView.backgroundView = messageLabel
      self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
      return 0
    }
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->
    Int {
     return self.activityModelList.count
    }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
    var activityModel: ActivityModel = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    cell.textLabel.text = activityModel.activityMessage
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var activity: ActivityModel = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    verbAPI.acknowledgeMessage(activity.message, callback: { response in
      self.loadData()
    })
    println("You selected cell #\(indexPath.row): \(activity.activityMessage)!")
  }

  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }

  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      activityModelList.removeObjectAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }

  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {

    var activity: ActivityModel = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel

    var reciprocate = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "\(activity.message.verb) back!", handler:{action, indexpath in
      println("RECIPROCATE•ACTION");
      self.tableView.setEditing(false, animated: true)
      self.verbAPI.reciprocateMessage(activity.message, callback: { response in
        self.loadData()
      })
    })
    reciprocate.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);

    var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
      println("DELETE•ACTION");
    })

    if activity.type == "received" {
      return [reciprocate]
    }
    else {
      return []
    }
  }

  func didReceiveAPIResults(results: JSON){
    var activities: NSMutableArray = []
    for (index: String, activity: JSON) in results {
      // Wow, this sucks.
      var senderUserModel = UserModel(
        id: activity["message"]["sender"]["id"].intValue,
        email: activity["message"]["sender"]["email"].stringValue,
        firstName: activity["message"]["sender"]["first_name"].stringValue,
        lastName: activity["message"]["sender"]["last_name"].stringValue
      )

      var recipientUserModel = UserModel(
        id: activity["message"]["recipient"]["id"].intValue,
        email: activity["message"]["recipient"]["email"].stringValue,
        firstName: activity["message"]["recipient"]["first_name"].stringValue,
        lastName: activity["message"]["recipient"]["last_name"].stringValue
      )

      var messageModel = MessageModel(
        id: activity["message"]["id"].intValue,
        verb: activity["message"]["verb"].stringValue,
        acknowledgedAt: activity["message"]["acknowledged_at"].intValue,
        acknowlegedAtInWords: activity["message"]["acknowledged_at_in_words"].stringValue,
        createdAt: activity["message"]["created_at"].intValue,
        createdAtInWords: activity["message"]["created_at_in_words"].stringValue,
        sender: senderUserModel,
        recipient: recipientUserModel
      )

      var activityModel = ActivityModel(activity: activity, message: messageModel)
      activities.addObject(activityModel)
    }

    self.refreshControl!.endRefreshing()
    self.tableView.reloadData()
    self.activityModelList = activities
  }

  func loadData() {
    verbAPI.getActivities()
    verbAPI.delegate = self
  }
}
