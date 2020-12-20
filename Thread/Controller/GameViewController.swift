import UIKit

class GameViewController: UIViewController {
    var level: Int = 3
    var imageName:String = ""
    var score: Int = 0
    var customer: [Pizza] = []
    var order: Pizza = Pizza()
    var make: Pizza = Pizza()
    var user: User = User(name: "", score: 0)
    var makeFinish: Bool = false
    var isBake: Bool = false
    var haveCustomer: Bool = false
    var finish: Bool = false
    var totalTime: Double = 90
    var customerTime: Double = 9
    var ovenTime: Double = 0.5
    var totalTimer: Timer = Timer()
    var customerTimer: Timer = Timer()
    var ovenTimer: Timer = Timer()
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var levelButton: UIButton!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameTabBarItem: UITabBarItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var timeLeftProgress: UIProgressView!
    @IBOutlet weak var ovenButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var customerTimeLeftProgress: UIProgressView!
    @IBOutlet weak var ovenTimeLeftProgress: UIProgressView!
    @IBOutlet weak var sourceButton: UIButton!
    @IBOutlet weak var cheeseButton: UIButton!
    @IBOutlet weak var meatButton: UIButton!
    @IBOutlet weak var bakenButton: UIButton!
    @IBOutlet weak var onionButton: UIButton!
    @IBOutlet weak var doughButton: UIButton!
    @IBOutlet weak var makeImageView: UIImageView!
    @IBOutlet weak var customerImageView: UIImageView!
    @IBOutlet weak var orderTextView: UITextView!
    
    @IBAction func doughButtonAction(_ sender: Any) {
        if !make.dough && !isBake && !makeFinish {
            make.dough = true
            makeImageView.image = UIImage(named: "d")!
            imageName = "d"
        }
    }
    @IBAction func sourceButtonAction(_ sender: Any) {
        if make.dough && !isBake && !makeFinish {
            if make.cheese == 0 && make.meat == 0 && make.baken == 0 && make.onion == 0{
                makeImageView.image = UIImage(named: "ds")!
                imageName = "ds"
            } else if make.cheese != 0 && make.meat == 0 && make.baken == 0 && make.onion == 0{
                makeImageView.image = UIImage(named: "dsp")!
                imageName = "dsp"
            } else {
                makeImageView.image = UIImage(named: "finish")!
                imageName = "finish"
            }
            make.source += 1
            makeLabel.text = "\(make.source) \(make.cheese) \(make.meat) \(make.baken) \(make.onion)"
        }
    }
    @IBAction func cheeseButtonAction(_ sender: Any) {
        if make.dough && !isBake && !makeFinish  {
            if make.meat == 0 && make.baken == 0 && make.onion == 0{
                makeImageView.image = UIImage(named: "dsp")!
                imageName = "dsp"
            } else {
                makeImageView.image = UIImage(named: "finish")!
                imageName = "finish"
            }
            make.cheese += 1
            makeLabel.text = "\(make.source) \(make.cheese) \(make.meat) \(make.baken) \(make.onion)"
        }
    }
    
    @IBAction func meatButtonAction(_ sender: Any) { ingredientButtonAction(2) }
    
    @IBAction func bakenButtonAction(_ sender: Any) { ingredientButtonAction(3) }
    
    @IBAction func onionButtonAction(_ sender: Any) { ingredientButtonAction(4) }
    
    @IBAction func bakeButtonAction(_ sender: Any) {
        if make.dough && !makeFinish {
            make.isBaked = true
            isBake = true
            ovenTimeLeftProgress.progress = 1
        }
    }
    
    @IBAction func finishButtonAction(_ sender: Any) {
        finish = true
        if compare(make, order) {
            score += (Int(customerTime) + 1) * 100
            scoreLabel.text = "점수: \(score)"
        } else {
            if make.dough == false {
                score -= 300
                scoreLabel.text = "점수: \(score)"
            } else {
                score -= 100
                scoreLabel.text = "점수: \(score)"
            }
        }
    }
    @IBAction func levelButtonAction(_ sender: Any) {
        
        var menuElement: [UIAction] = []
        for i in 1...3 {
            menuElement.append(UIAction(title: "level: \(i)", image: nil, handler: { _ in
                switch (i) {
                case 1: self.level = 3
                case 2: self.level = 5
                case 3: self.level = 7
                default: break
                }
            }))
        }
        levelButton.menu = UIMenu(title: "레벨 선택", image: nil,identifier: .application, options: .displayInline, children: menuElement)
    }
    
    @IBAction func playGameButtonAction(_ sender: Any) {
        playButton.isEnabled = false
        levelButton.isEnabled = false
        startGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        user = User(name: "", score: 0)
        levelButton.showsMenuAsPrimaryAction = true
        levelButton.isEnabled = true
        playButton.isEnabled = true
        timeLeftProgress.transform = timeLeftProgress.transform.scaledBy(x: 1, y: 1.8)
        customerTimeLeftProgress.transform = customerTimeLeftProgress.transform.scaledBy(x: 1, y: 1.5)
        ovenTimeLeftProgress.transform = ovenTimeLeftProgress.transform.scaledBy(x: 1, y: 1.3)
        changeButtonUI(btn: ovenButton)
        changeButtonUI(btn: finishButton)
        
        firstAlert()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        nameLabel.text?.removeAll()
        orderTextView.text.removeAll()
        customerImageView.image = UIImage()
        makeImageView.image = UIImage()
        scoreLabel.text = "점수: 0"
        totalTimer.invalidate()
        customerTimer.invalidate()
        ovenTimer.invalidate()
        score = 0
        customer = []
        haveCustomer = false
        finish = false
    }
    
    func ingredientButtonAction(_ num: Int){
        if make.dough && !isBake && !makeFinish  {
            make.ingredientPlus(num)
            makeImageView.image = UIImage(named: "finish")!
            imageName = "finish"
            makeLabel.text = "\(make.source) \(make.cheese) \(make.meat) \(make.baken) \(make.onion)"
        }
    }
    
    func changeButtonUI(btn:UIButton) {
        btn.layer.borderColor = UIColor.systemGray.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 10
    }

    func firstAlert() {
        let alert = UIAlertController(title: "게임을 진행하시겠습니까?", message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "네", style: .default, handler: { _ in
            
            let textAlert = UIAlertController(title: "이름을 설정해주세요", message: nil, preferredStyle: .alert)
            textAlert.addTextField()
            let ok = UIAlertAction(title: "네", style: .default, handler: { _ in
                if let text = textAlert.textFields?[0].text {
                    if text.trimmingCharacters(in: .whitespaces) != "" {
                        self.user.name = text
                        self.nameLabel.text = self.user.name
                    } else {
                        self.present(textAlert, animated: true, completion: nil)
                    }
                }
            })
            let no = UIAlertAction(title: "아니요", style: .destructive, handler: { _ in
                self.present(alert, animated: true, completion: nil)
            })
            textAlert.addAction(ok)
            textAlert.addAction(no)
            self.present(textAlert, animated: true, completion: nil)
        })
        let no = UIAlertAction(title: "아니요", style: .destructive, handler: { _ in
            self.user = User(name: "", score: 0)
            self.performSegue(withIdentifier: "BackSegue", sender: nil)
        })
        alert.addAction(ok)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
    }
    
    func compare(_ left: Pizza,_ right: Pizza) -> Bool {
        if left.dough  && left.source == right.source && left.cheese == right.cheese && left.meat == right.meat && left.baken==right.baken && left.onion == right.onion && left.isBaked {
            return true
        } else {
            return false
        }
    }
    
    func makeString(_ pizza:Pizza) -> String {
        return "소스: \(pizza.source)회\n치즈: \(pizza.cheese)회\n고기: \(pizza.meat)회\n베이컨: \(pizza.baken)회\n양파: \(pizza.onion)회"
    }
    
    func startGame() {
        timeLeftLabel.text = "01:30"
        totalTime = 90
        DispatchQueue.global().sync() {
            totalTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTotalLeftTime), userInfo: nil, repeats: true)
        }
        DispatchQueue.global().sync() {
            customerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(customerWait), userInfo: nil, repeats: true)
            
        }
        DispatchQueue.global().sync {
            ovenTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ovenBaking), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTotalLeftTime() {
        if totalTime >= 0{
            if Int(totalTime) % 2 == 0 {
                customer.append(Pizza(level: self.level))
            }
            totalTime -= 0.1
            timeLeftLabel.text = "\(Int(totalTime)/60):\(Int(totalTime) % 60 < 10 ? "0": "")\(Int(totalTime)%60)"
            timeLeftProgress.progress = Float(totalTime) / 90.0
        } else {
            totalTimer.invalidate()
            customerTimer.invalidate()
            ovenTimer.invalidate()
            totalTime = 90.000
            timeLeftLabel.text = "01:30"
            timeLeftProgress.progress = 1.0
            user = User(name: nameLabel.text!, score: score)
            performSegue(withIdentifier: "BackSegue", sender: nil)
        }
    }
    
    @objc func customerWait() {
        if !haveCustomer {
            make = Pizza()
            if customer.capacity > 0 {
                make = Pizza()
                customerTime = 9
                customerTimeLeftProgress.progress = 1
                haveCustomer = true
                finish = false
                order = customer[0]
                customer.remove(at: 0)
                customerImageView.image = order.customerImage
                orderTextView.text = makeString(order)
            }
        } else {
            if !finish {
                if customerTime >= 0 {
                    customerTimeLeftProgress.progress = Float(customerTime / 9)
                    customerTime -= 0.1
                } else {
                    ovenTimeLeftProgress.progress = 0
                    make = Pizza()
                    customerTime = 9
                    customerTimeLeftProgress.progress = 0
                    score -= 150
                    scoreLabel.text = "점수: \(score)"
                    finish = true
                }
            } else {
                ovenTimeLeftProgress.progress = 0
                makeLabel.text = "0 0 0 0 0"
                makeImageView.image = UIImage()
                haveCustomer = false
                isBake = false
                makeFinish = false
            }
        }
    }
    
    @objc func ovenBaking() {
        if isBake {
            if ovenTime >= 0{
                ovenTime -= 0.1
                ovenTimeLeftProgress.progress = Float(ovenTime / 0.5)
                if ovenTime >= 0.3 && ovenTime <= 0.5{ makeImageView.image = UIImage(named: "\(imageName)1")! }
                else { makeImageView.image = UIImage(named: "\(imageName)2")! }
                finishButton.isEnabled = false
            } else {
                ovenTime = 0.5
                ovenTimeLeftProgress.progress = 0
                finishButton.isEnabled = true
                isBake = false
                makeFinish = true
            }
        }
    }
    
}
