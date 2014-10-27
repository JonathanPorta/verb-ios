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
    var friendViewController: FriendViewController = segue.destinationViewController as FriendViewController
    var verbIndex = self.tableView!.indexPathForSelectedRow()!.row
    var verb = self.verbModelList[verbIndex] as VerbModel
    friendViewController.verbModel = verb
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
      return self.verbModelList.count
    }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
    var verbModel: VerbModel = self.verbModelList.objectAtIndex(indexPath.row) as VerbModel
    cell.textLabel.text = verbModel.name
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("You selected cell #\(indexPath.row)")
  }

  func loadData() {
    self.verbModelList = self.categoryModel!.verbs
  }
}
