class ConnectionFriendFactory: VerbAPIProtocol {

  class var instance: ConnectionFriendFactory {
    struct Static {
      static let instance: ConnectionFriendFactory = ConnectionFriendFactory()
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

    verbAPI.getConnectionFriends("facebook", delegate: self.instance)
  }

  func didReceiveResult(result: JSON) {
    var friends: NSMutableArray = []
    for (index: String, friend: JSON) in result {
      var friend = ConnectionFriendModel(user: friend)
      friends.addObject(friend)
    }

    self.friends = friends

    NSNotificationCenter.defaultCenter().postNotificationName("connection_friend.all", object: nil)
  }

  class func RequestFriendship(connectionFriend: ConnectionFriendModel) {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var verbAPI = appDelegate.getVerbAPI()

    verbAPI.requestFriendship(connectionFriend, delegate: self.instance)
  }

  class func AcceptFriendship(friendshipModel: FriendshipModel) {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var verbAPI = appDelegate.getVerbAPI()

    verbAPI.acceptFriendship(friendshipModel, delegate: self.instance)
  }
}
