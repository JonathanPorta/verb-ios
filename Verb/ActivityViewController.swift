//
//  ActivityViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 8/28/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class ActivityViewController: UITableViewController, SwipeableCellDelegate {
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  var activityModelList: NSMutableArray = []
  var cellsCurrentlyEditing: NSMutableSet?

  @IBOutlet var logoutBtn: UIBarButtonItem!
  @IBOutlet var composeBtn: UIBarButtonItem!

  @IBAction func sendMessages(segue: UIStoryboardSegue) {
    let source = segue.sourceViewController as FriendViewController
    let recipients = source.selection
    let verb = source.verbModel!
    MessageFactory.New(recipients, verb: verb)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    self.title = ""
  }

  override func viewWillAppear(animated: Bool) {
    self.title = "\u{e600}"

    var font = UIFont(name: "icomoon-standard", size: 24.0)!

    logoutBtn.setTitleTextAttributes([ NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor() ], forState: UIControlState.Normal)
    logoutBtn.title = "\u{e8b8}"

    composeBtn.setTitleTextAttributes([ NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor() ], forState: UIControlState.Normal)
    composeBtn.title = "\u{e8dd}"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    cellsCurrentlyEditing = NSMutableSet()
    tableView.rowHeight = 60

    // TODO: Like fonts, we need a way to manager the colors and inject them as dependencies.
    self.navigationController?.navigationBar.backgroundColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)

    // Register for notifications
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadData", name: "reloadActivities", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "insertActivity:", name: "activity.new", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "activity.update", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData:", name: "onActivityAll", object: nil)

    var refresh = UIRefreshControl()
    refresh.addTarget(self, action:"loadData", forControlEvents:.ValueChanged)
    self.refreshControl = refresh
    self.refreshControl!.beginRefreshing()

    loadData()

    if tableView.respondsToSelector("setSeparatorInset:") {
      tableView.separatorInset = UIEdgeInsetsZero
    }
  }

  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if cell.respondsToSelector("setSeparatorInset:") {
      cell.separatorInset.left = CGFloat(0.0)
    }
    if tableView.respondsToSelector("setLayoutMargins:") {
      tableView.layoutMargins = UIEdgeInsetsZero
    }
    if cell.respondsToSelector("setLayoutMargins:") {
      cell.layoutMargins.left = CGFloat(0.0)
    }
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
        messageLabel.text = "Oh no! You haven't been active! \n\n Try doing something and maybe something will show up here..."
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

    // Configure our snowflake UILable
    var statusLabel = cell.foregroundStatusLabel as StatusLabel
    statusLabel.setActivityModel(activityModel)

    // Configure our snowflake UITableViewCell
    cell.swipeableModel = activityModel
    cell.delegate = self
    cell.foregroundLabel.text = activityModel.activityMessage
    cell.foregroundSubLabel.text = activityModel.lastActionTimeAgoInWords()
    cell.didSwipe = {
      activityModel.reciprocate()
    }

    if(cellsCurrentlyEditing!.containsObject(activityModel)) {
      cell.openCell()
    }

    // We have to reset these manually each time... Maybe I am doing this wrong.
    // TODO: LEARN!!!!1!!!eleven!
    tableView.layoutMargins = UIEdgeInsetsZero
    cell.separatorInset.left = CGFloat(0.0)
    cell.layoutMargins.left = CGFloat(0.0)

    return cell
  }

  func cellDidOpen(cell: SwipeableCell) {
    cellsCurrentlyEditing!.addObject(cell.swipeableModel as ActivityModel)
  }

  func cellDidClose(cell: SwipeableCell) {
    cellsCurrentlyEditing!.removeObject(cell.swipeableModel as ActivityModel)
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Deselect the row so it doesn't stay highlighted
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    var activity = activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    if activity.canAcknowledge() { // Might not need to check this here since we already check it in willSelectRowAtIndex.
      Async.background {
        activity.acknowledge()
      }
    }
  }

  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    var activity = self.activityModelList.objectAtIndex(indexPath.row) as ActivityModel
    if  activity.canAcknowledge() {
      return indexPath
    }
    return nil
  }

  func insertActivity(notification: NSNotification) {
    var userInfo = notification.userInfo! as NSDictionary
    var activity = userInfo.objectForKey("activity") as ActivityModel
    activityModelList.insertObject(activity, atIndex: 0)
    var firstRow = NSIndexPath(forRow: 0, inSection: 0)
    Async.main {
      self.tableView.insertRowsAtIndexPaths([firstRow], withRowAnimation: UITableViewRowAnimation.Bottom)
    }
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
