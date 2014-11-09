class CategoryFactory: VerbAPIProtocol {

  class var instance: CategoryFactory {
    struct Static {
      static let instance: CategoryFactory = CategoryFactory()
    }
    return Static.instance
  }

  let endpoint: String = "categories.json"
  var categories: NSMutableArray = []

  class func New(properties: [String: AnyObject]) {

  }

  class func All() {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var verbAPI = appDelegate.getVerbAPI()

    verbAPI.getCategories(self.instance)
  }

  func didReceiveResult(result: JSON) {
    var categories: NSMutableArray = []
    for (category: String, subcategories: JSON) in result {
      var verbs: NSMutableArray = []
      for (index: String, verb: JSON) in subcategories {
        verbs.addObject(VerbModel(name: verb.string!))
      }
      categories.addObject(CategoryModel(name: category, verbs: verbs))
    }

    self.categories = categories

    NSNotificationCenter.defaultCenter().postNotificationName("category.all", object: nil)
  }
}
