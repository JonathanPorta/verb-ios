class FriendFactory: VerbAPIProtocol {

  class var instance: FriendFactory {
    struct Static {
      static let instance: FriendFactory = FriendFactory()
    }
    return Static.instance
  }

  let endpoint: String = "friends.json"
  var friends: NSMutableArray = []

  class func New(properties: [String: AnyObject]) {

  }

  class func All() {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var verbAPI = appDelegate.getVerbAPI()

    verbAPI.getFriends(self.instance)
  }

  func didReceiveResult(result: JSON) {
    var friends: NSMutableArray = []
    for (index: String, friend: JSON) in result {
      var friend = UserModel(user: friend)
      friends.addObject(friend)
    }

    self.friends = friends

    NSNotificationCenter.defaultCenter().postNotificationName("friend.all", object: nil)
  }
}
