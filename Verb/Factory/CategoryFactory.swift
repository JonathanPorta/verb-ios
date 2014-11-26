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
    for (index: String, category: JSON) in result {
      var categoryModel = CategoryModel(category: category)
      categories.addObject(categoryModel)
    }
    self.categories = categories
    NSNotificationCenter.defaultCenter().postNotificationName("category.all", object: nil)
  }
}
