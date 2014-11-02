//
//  FriendViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 10/21/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class FriendViewController : UITableViewController, VerbAPIProtocol {
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

  @IBOutlet var sendBtn: UIBarButtonItem!

  var verbModel: VerbModel?
  var verbAPI: VerbAPI
  var userModelList: NSMutableArray = []
  var selection: NSMutableArray = []

  required init(coder aDecoder: NSCoder) {
    self.verbAPI = appDelegate.getVerbAPI()
    super.init(coder: aDecoder)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    for var i = 0; i < userModelList.count; ++i {
      var userModel: UserModel = self.userModelList.objectAtIndex(i) as UserModel
      if userModel.selected {
        selection.addObject(userModel)
      }
    }
  }

  func selectionExists() -> Bool {
    var somethingIsSelected = false
    for var i = 0; i < userModelList.count; ++i {
      var userModel: UserModel = self.userModelList.objectAtIndex(i) as UserModel
      if userModel.selected {
        somethingIsSelected = true
      }
    }
    return somethingIsSelected
  }

  override func viewDidLoad() {
    super.viewDidLoad()
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
      return self.userModelList.count
    }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
    var userModel: UserModel = self.userModelList.objectAtIndex(indexPath.row) as UserModel
    cell.textLabel.text = userModel.firstName

    if userModel.selected {
      cell.accessoryType = .Checkmark
    }
    else {
      cell.accessoryType = .None
    }

    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("You selected cell #\(indexPath.row)")
    var userModel: UserModel = self.userModelList.objectAtIndex(indexPath.row) as UserModel
    userModel.select()
    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    if selectionExists() {
      sendBtn.enabled = true
    }
    else {
      sendBtn.enabled = false
    }
  }

  func didReceiveResult(results: JSON){
    var friends: NSMutableArray = []
    for (index: String, friend: JSON) in results {
      var friend = UserModel(user: friend)
      friends.addObject(friend)
    }

    self.userModelList = friends

    Async.main {
      self.tableView.reloadData()
    }
  }

  func loadData() {
    verbAPI.getFriends(self)
  }
}
