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
    for var i = 0; i < friendModelList.count; ++i {
      var friendModel = friendModelList.objectAtIndex(i) as UserModel
      if friendModel.selected {
        selection.addObject(friendModel)
      }
    }
    self.title = ""
  }

  override func viewWillAppear(animated: Bool) {
    self.title = "Friends"
    sendBtn.tintColor = UIColor.whiteColor()
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
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->
    Int {
      return friendModelList.count
    }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
    var friendModel = friendModelList.objectAtIndex(indexPath.row) as UserModel
    cell.textLabel.text = friendModel.firstName
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
