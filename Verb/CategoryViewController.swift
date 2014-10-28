//
//  CategoryViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 10/21/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import SwiftyJSON

class CategoryViewController : UITableViewController, VerbAPIProtocol {
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  var verbAPI: VerbAPI
  var categoryModelList: NSMutableArray = []

  required init(coder aDecoder: NSCoder) {
    self.verbAPI = appDelegate.getVerbAPI()
    super.init(coder: aDecoder)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var verbViewController: VerbViewController = segue.destinationViewController as VerbViewController
    var categoryIndex = self.tableView!.indexPathForSelectedRow()!.row
    var category = self.categoryModelList[categoryIndex] as CategoryModel
    verbViewController.categoryModel = category
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
      return self.categoryModelList.count
    }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
    var categoryModel: CategoryModel = self.categoryModelList.objectAtIndex(indexPath.row) as CategoryModel
    cell.textLabel.text = categoryModel.name
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("You selected cell #\(indexPath.row)")
  }

  func didReceiveResult(results: JSON){
    var categories: NSMutableArray = []
    for (category: String, subcategories: JSON) in results {
      var verbs: NSMutableArray = []
      for (index: String, verb: JSON) in subcategories {
        verbs.addObject(VerbModel(name: verb.string!))
      }
      categories.addObject(CategoryModel(name: category, verbs: verbs))
    }

    self.categoryModelList = categories

    dispatch_async(dispatch_get_main_queue(), { () -> Void in
      self.tableView.reloadData()
    })
  }

  func loadData() {
    verbAPI.getCategories(self)
  }
}
