 import UIKit

class User: NSObject {
    var date:Date = Date()
    var name: String
    var score: Int
    var id: Int = 0
    
    init(name:String, score:Int) {
        self.name = name
        self.score = score
    }
    
    init(name:String, score:Int, date:Date){
        self.name = name
        self.score = score
        self.date = date
    }
}
