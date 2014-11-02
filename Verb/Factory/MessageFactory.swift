class MessageFactory: VerbAPIProtocol {

  class var instance: MessageFactory {
    struct Static {
      static let instance: MessageFactory = MessageFactory()
    }
    return Static.instance
  }

  let endpoint: String = "messages.json"

  class func New(recipient: UserModel, verb: VerbModel) {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var verbAPI = appDelegate.getVerbAPI()

    verbAPI.sendMessage(recipient, verb: verb, delegate: self.instance)
  }

  class func New(recipients: NSMutableArray, verb: VerbModel) {
    for var i = 0; i < recipients.count; ++i {
      var recipient: UserModel = recipients.objectAtIndex(i) as UserModel
      MessageFactory.New(recipient, verb: verb)
    }
  }

  class func All() {

  }

  class func Reciprocate(message: MessageModel) {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var verbAPI = appDelegate.getVerbAPI()

    verbAPI.reciprocateMessage(message, delegate: self.instance)
  }

  class func Acknowledge(message: MessageModel) {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var verbAPI = appDelegate.getVerbAPI()

    verbAPI.acknowledgeMessage(message, delegate: self.instance)
  }

  func didReceiveResult(result: JSON) {
    NSNotificationCenter.defaultCenter().postNotificationName("reloadActivities", object: nil)
  }
}
