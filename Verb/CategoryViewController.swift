//
//  CategoryViewController.swift
//  Verb
//
//  Created by Jonathan Porta on 10/21/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class CategoryViewController : UITableViewController {
  var categoryModelList: NSMutableArray = []

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var verbViewController = segue.destinationViewController as VerbViewController
    var categoryIndex = tableView!.indexPathForSelectedRow()!.row
    var category = categoryModelList[categoryIndex] as CategoryModel
    verbViewController.categoryModel = category
    self.title = ""
  }

  override func viewWillAppear(animated: Bool) {
    self.title = "Categories"
  }

  override func viewDidLoad() {

    // Set the logo and custom font
    if let font = UIFont(name: "verb", size: 1.0) {
      NSLog("Custom Font Loaded")

      self.navigationController?.navigationBar.titleTextAttributes = [
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: UIColor.blackColor()
      ]
      self.navigationController?.navigationBar.topItem?.title = "sd"
      self.navigationController?.navigationBar.backItem?.title = "sdfd"
    }
    else {
      NSLog("CUSTOM FONT FAILED TO LOAD")
    }

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData", name: "category.all", object: nil)

    var refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:"loadData", forControlEvents:.ValueChanged)
    self.refreshControl = refreshControl

    // See if we already preloaded the data before firing a request.	
    if CategoryFactory.instance.categories.count > 0 {
      categoryModelList = CategoryFactory.instance.categories
      refresh()
    }
    else {
      self.refreshControl!.beginRefreshing()
      loadData()
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
      return categoryModelList.count
    }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell") as UITableViewCell
    var categoryModel = categoryModelList.objectAtIndex(indexPath.row) as CategoryModel
    cell.textLabel.text = categoryModel.name
    return cell
  }

  func refresh() {
    Async.main {
      self.tableView.reloadData()
    }
  }

  func updateData() {
    categoryModelList = CategoryFactory.instance.categories

    Async.main {
      self.refreshControl!.endRefreshing()
      self.refresh()
    }
  }

  func loadData() {
    Async.background {
      CategoryFactory.All()
    }
  }
}
