class ActivityFactory: VerbAPIProtocol {

  class var instance: ActivityFactory {
    struct Static {
      static let instance: ActivityFactory = ActivityFactory()
    }
    return Static.instance
  }

  let endpoint: String = "activities.json"

  class func New(properties: [String: AnyObject]) {

  }

  class func All() {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var verbAPI = appDelegate.getVerbAPI()

    verbAPI.getActivities(self.instance)
  }

  func didReceiveResult(result: JSON) {
    var activities: NSMutableArray = []

    for (index: String, activity: JSON) in result {
      var activityModel = ActivityModel(activity: activity)
      // Maybe I should rethink how relationships are handled since I can't pass self to the message constructor in the activity ctor.'
      activityModel.actionable?.activity = activityModel

      activities.addObject(activityModel)
    }

    var userInfo: NSDictionary = ["activities": activities]
    NSNotificationCenter.defaultCenter().postNotificationName("onActivityAll", object: nil, userInfo: userInfo)
  }
}
