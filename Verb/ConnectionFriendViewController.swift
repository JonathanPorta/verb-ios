//
//  ConnectionFriendViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 11/30/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class ConnectionFriendViewController : UITableViewController {

  var friendModelList: NSMutableArray = []

  override func viewWillAppear(animated: Bool) {
    self.title = "Facebook"
  }

  override func viewDidLoad() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData", name: "connection_friend.all", object: nil)

    var refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:"loadData", forControlEvents:.ValueChanged)
    self.refreshControl = refreshControl

    // See if we already preloaded the data before firing a request.
    if ConnectionFriendFactory.instance.friends.count > 0 {
      friendModelList = ConnectionFriendFactory.instance.friends
      refresh()
    }
    else {
      self.refreshControl!.beginRefreshing()
      loadData()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
        messageLabel.text = "Sadly, none of your friends use Verb. \n\n You should tell them about it!"
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
    var cell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as SocialCell
    var connectionFriendModel = friendModelList.objectAtIndex(indexPath.row) as ConnectionFriendModel

    cell.setModel(connectionFriendModel)

    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var connectionFriendModel = friendModelList.objectAtIndex(indexPath.row) as ConnectionFriendModel
    connectionFriendModel.requestFriendship()

    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
  }

  func refresh() {
    Async.main {
      self.tableView.reloadData()
    }
  }

  func updateData() {
    friendModelList = ConnectionFriendFactory.instance.friends

    Async.main {
      self.refreshControl!.endRefreshing()
      self.refresh()
    }
  }

  func loadData() {
    Async.background {
      ConnectionFriendFactory.All()
    }
  }
}
