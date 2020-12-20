import UIKit

class Pizza: NSObject {
    
    var dough: Bool = false
    var isBaked: Bool = false
    
    var customerImage: UIImage = UIImage()
    var source: Int = 0
    var cheese: Int = 0
    var meat: Int = 0
    var baken: Int = 0
    var onion: Int = 0
    
    override init(){
        
    }
    
    init(level:Int) {
        customerImage = UIImage(named: "\(Int.random(in: 1...500000) % 9 + 1)") ?? UIImage()
        source = Int.random(in: 1...500000) % level
        cheese = Int.random(in: 1...500000) % level
        meat = Int.random(in: 1...500000) % level
        baken = Int.random(in: 1...500000) % level
        onion = Int.random(in: 1...500000) % level
    }
    
    func ingredientPlus(_ num: Int) {
        switch (num) {
        case 0: self.source += 1
        case 1: self.cheese += 1
        case 2: self.meat += 1
        case 3: self.baken += 1
        case 4: self.onion += 1
        default:
            break
        }
    }
    
}
