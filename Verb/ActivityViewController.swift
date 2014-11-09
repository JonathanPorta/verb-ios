//
//  ActivityViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 8/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import CoreData

class ActivityViewController: UITableViewController {
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  var managedContext: NSManagedObjectContext?
  var activities = [Activity]()

  @IBAction func sendMessages(segue: UIStoryboardSegue) {
    let source = segue.sourceViewController as FriendViewController
    let recipients = source.selection
    let verb = source.verbModel!
    MessageFactory.New(recipients, verb: verb)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    managedContext = appDelegate.coreDataStack.context

    // Get notified when we need to refresh
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadData", name: "reloadActivities", object: nil)

    // Get notified when new data arrives
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData:", name: "onActivityAll", object: nil)

    var refresh = UIRefreshControl()
    refresh.addTarget(self, action:"loadData", forControlEvents:.ValueChanged)
    self.refreshControl = refresh
    //self.refreshControl!.beginRefreshing()

    //loadData()
    let fetchRequest = NSFetchRequest(entityName: "Activity")
    var error: NSError?

    let fetchedResults = managedContext!.executeFetchRequest(fetchRequest, error: &error) as [Activity]?
    if let results = fetchedResults {
      activities = results
    }
    else {
      println("Could not fetch activities \(error), \(error!.userInfo)")
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if activities.count > 0 {
      self.tableView.backgroundView = nil
      self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
      return 1
    }
    else {
      if !self.refreshControl!.refreshing {
        // Only show a message that there is no data if we couldn't find data.
        var messageLabel = UILabel(frame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height));

        messageLabel.text = "No data is currently available. Please pull down to refresh."
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.font = UIFont(name:"Palatino-Italic", size:20)
        messageLabel.sizeToFit()

        self.tableView.backgroundView = messageLabel
      }

      self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
      return 0
    }
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->
    Int {
      return activities.count
    }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
    var activity = activities[indexPath.row]
    cell.textLabel.text = activity.activityMessage
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Deselect the row so it doesn't stay highlighted
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    //var activity: ActivityModel = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    //Async.background {
    //  activity.message.acknowledge()
    //}
  }

  //override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
    //var activity: ActivityModel = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    //if activity.type == "received" && activity.message.acknowledgedAt == 0 {
      // Only allow user to acknowledge a message that was sent to them.
      //return indexPath
    //} else {
      //return nil
    //}
  //}

  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }

  // override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
  //
  //   var activity: ActivityModel = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel
  //
  //   var reciprocate = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "\(activity.message.verb) back!", handler:{action, indexpath in
  //     self.tableView.setEditing(false, animated: true)
  //     Async.background {
  //       activity.message.reciprocate()
  //     }
  //   })
  //   reciprocate.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
  //
  //   if activity.type == "received" {
  //     return [reciprocate]
  //   }
  //   else {
  //     return []
  //   }
  // }

  func saveActivities(activityModelList: NSMutableArray) {
    let entity = NSEntityDescription.entityForName("Activity", inManagedObjectContext: managedContext!)

    for var i = 0; i < activityModelList.count; ++i {
      var activityModel: ActivityModel = activityModelList.objectAtIndex(i) as ActivityModel

      var activity = Activity(entity: entity!, insertIntoManagedObjectContext: managedContext!)
      activity.id = activityModel.id
      activity.activityMessage = activityModel.activityMessage

      var error: NSError?
      if !managedContext!.save(&error) {
        println("Could not save activity: \(error), \(error?.userInfo)")
      }

      activities.append(activity)
    }
  }

  func updateData(notification: NSNotification){
    var userInfo: NSDictionary = notification.userInfo!
    var activityModelList = userInfo.objectForKey("activities") as NSMutableArray

    saveActivities(activityModelList)

    Async.main {
      self.refreshControl!.endRefreshing()
      self.tableView.reloadData()
    }
  }

  func loadData() {
    Async.background {
      ActivityFactory.All()
    }
  }
}
