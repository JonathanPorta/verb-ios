//
//  VerbViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 10/21/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class VerbViewController : UITableViewController {
  var categoryModel: CategoryModel?
  var verbModelList: NSMutableArray = []

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var friendViewController = segue.destinationViewController as FriendViewController
    var verbIndex = tableView!.indexPathForSelectedRow()!.row
    var verb = verbModelList[verbIndex] as VerbModel
    friendViewController.verbModel = verb
    self.title = ""
  }

  override func viewWillAppear(animated: Bool) {
    self.title = categoryModel!.name
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
      return verbModelList.count
    }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
    var verbModel = verbModelList.objectAtIndex(indexPath.row) as VerbModel
    cell.textLabel.text = verbModel.name
    return cell
  }

  func loadData() {
    verbModelList = categoryModel!.verbs
  }
}
