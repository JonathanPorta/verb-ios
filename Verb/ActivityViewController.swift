//
//  ActivityViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 8/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class ActivityViewController: UITableViewController {
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  var activityModelList: NSMutableArray = []

  @IBAction func sendMessages(segue: UIStoryboardSegue) {
    let source = segue.sourceViewController as FriendViewController
    let recipients = source.selection
    let verb = source.verbModel!
    MessageFactory.New(recipients, verb: verb)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 44

    // Get notified when we need to refresh
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadData", name: "reloadActivities", object: nil)

    // Insert a new activity
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "insertActivity:", name: "activity.new", object: nil)

    // An activity was updated
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "activity.update", object: nil)

    // Get notified when new data arrives
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData:", name: "onActivityAll", object: nil)

    var refresh = UIRefreshControl()
    refresh.addTarget(self, action:"loadData", forControlEvents:.ValueChanged)
    self.refreshControl = refresh
    self.refreshControl!.beginRefreshing()

    loadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if activityModelList.count > 0 {
      tableView.backgroundView = nil
      tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
      return 1
    }
    else {
      if !refreshControl!.refreshing {
        // Only show a message that there is no data if we couldn't find data.
        var messageLabel = UILabel(frame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height));

        messageLabel.text = "No data is currently available. Please pull down to refresh."
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.font = UIFont(name:"Palatino-Italic", size:20)
        messageLabel.sizeToFit()

        tableView.backgroundView = messageLabel
      }

      tableView.separatorStyle = UITableViewCellSeparatorStyle.None
      return 0
    }
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->
    Int {
      return activityModelList.count
    }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as SwipeableCell
    var activityModel = activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    cell.swipeableModel = activityModel
    cell.onCompletedSwipe = {
      activityModel.reciprocate()
    }
    cell.foregroundLabel.text = activityModel.activityMessage
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Deselect the row so it doesn't stay highlighted
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    var activity = activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    Async.background {
      activity.acknowledge()
    }
  }

  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
    var activity = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    if activity.type == "received" && activity.message!.acknowledgedAt == 0 {
      // Only allow user to acknowledge a message that was sent to them.
      return indexPath
    } else {
      return nil
    }
  }

  func insertActivity(notification: NSNotification) {
    var userInfo = notification.userInfo! as NSDictionary
    var activity = userInfo.objectForKey("activity") as ActivityModel
    activityModelList.insertObject(activity, atIndex: 0)
    refresh()
  }

  func refresh() {
    Async.main {
      self.tableView.reloadData()
    }
  }

  func updateData(notification: NSNotification) {
    var userInfo = notification.userInfo! as NSDictionary
    activityModelList = userInfo.objectForKey("activities") as NSMutableArray

    Async.main {
      self.refreshControl!.endRefreshing()
      self.refresh()
    }
  }

  func loadData() {
    Async.background {
      ActivityFactory.All()
    }
  }
}
