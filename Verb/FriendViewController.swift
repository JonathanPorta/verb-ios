//
//  FriendViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 10/21/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class FriendViewController : UITableViewController {

  @IBOutlet var sendBtn: UIBarButtonItem!

  var verbModel: VerbModel?
  var friendModelList: NSMutableArray = []
  var selection: NSMutableArray = []

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == "SendMessages" {
      for var i = 0; i < friendModelList.count; ++i {
        var friendModel = friendModelList.objectAtIndex(i) as UserModel
        if friendModel.selected {
          selection.addObject(friendModel)
        }
      }
    }
    self.title = ""
  }

  override func viewWillAppear(animated: Bool) {
    self.title = "Friends"
    var font = UIFont(name: "icomoon-standard", size: 24.0)!

    sendBtn.title = "\u{e848}"
    sendBtn.tintColor = UIColor.whiteColor()
    sendBtn.setTitleTextAttributes([ NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor() ], forState: UIControlState.Normal)
    sendBtn.setTitleTextAttributes([ NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.5) ], forState: UIControlState.Disabled)

    var findFriendsBtn = UIBarButtonItem(title: "\u{e852}", style: UIBarButtonItemStyle.Plain, target: self, action: "showConnectionFriendsView:")
    findFriendsBtn.setTitleTextAttributes([ NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor() ], forState: UIControlState.Normal)
    //var findFriendsBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: self, action: "showConnectionFriendsView:")
    var actionButtonItems = [sendBtn, findFriendsBtn]
    self.navigationItem.rightBarButtonItems = actionButtonItems
  }

  func showConnectionFriendsView(sender: UIButton!) {
    performSegueWithIdentifier("ShowConnectionFriends", sender: self)
  }

  func selectionExists() -> Bool {
    var somethingIsSelected = false
    for var i = 0; i < friendModelList.count; ++i {
      var friendModel = friendModelList.objectAtIndex(i) as UserModel
      if friendModel.selected {
        somethingIsSelected = true
      }
    }
    return somethingIsSelected
  }

  override func viewDidLoad() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData", name: "friend.all", object: nil)

    var refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:"loadData", forControlEvents:.ValueChanged)
    self.refreshControl = refreshControl

    // See if we already preloaded the data before firing a request.
    if FriendFactory.instance.friends.count > 0 {
      friendModelList = FriendFactory.instance.friends
      clearSelection() // Make sure old selections don't hang around.
      refresh()
    }
    else {
      self.refreshControl!.beginRefreshing()
      loadData()
    }
  }

  func clearSelection() {
    for var i = 0; i < friendModelList.count; ++i {
      var friendModel = friendModelList.objectAtIndex(i) as UserModel
      friendModel.selected = false
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if friendModelList.count > 0 {
      tableView.backgroundView = nil
      tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
      return 1
    }
    else {
      if !refreshControl!.refreshing {
        // Only show a message that there is no data if we couldn't find data.
        var messageLabel = UILabel(frame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height));
        messageLabel.text = "You don't have any friends, yet! \n\n Try finding some by tapping that icon up there."
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
      return friendModelList.count
    }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
    var friendModel = friendModelList.objectAtIndex(indexPath.row) as UserModel
    cell.textLabel!.text = friendModel.firstName
    cell.tintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)

    if friendModel.selected {
      cell.accessoryType = .Checkmark
    }
    else {
      cell.accessoryType = .None
    }

    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var friendModel = friendModelList.objectAtIndex(indexPath.row) as UserModel
    friendModel.select()
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    if selectionExists() {
      sendBtn.enabled = true
    }
    else {
      sendBtn.enabled = false
    }
  }

  func refresh() {
    Async.main {
      self.tableView.reloadData()
    }
  }

  func updateData() {
    friendModelList = FriendFactory.instance.friends

    Async.main {
      self.refreshControl!.endRefreshing()
      self.refresh()
    }
  }

  func loadData() {
    Async.background {
      FriendFactory.All()
    }
  }
}
