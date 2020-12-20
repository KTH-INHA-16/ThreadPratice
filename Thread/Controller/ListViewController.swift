import UIKit

class ListViewController: UIViewController {

    let cellName: String = "TableViewCell"
    let headerName: String = "TableViewHeader"
    let searchController = UISearchController(searchResultsController: nil)
    var users: [User] = []
    var saveUsers: [User] = []
    
    @IBOutlet weak var listScrollView: UIScrollView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var listSearchBar: UISearchBar!
    
    @IBAction func unwindToList(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! GameViewController
        let user = sourceViewController.user
        if user.name != "" {
            saveNewUser(Int32(users.count+1), name: user.name, score: Int32(user.score),date: Date())
        }
        sourceViewController.user = User(name: "", score: 0)
        getAllUsers()
        listTableView.reloadData()
        saveUsers = users
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib: UINib = UINib(nibName: cellName, bundle: nil)
        listTableView.register(cellNib, forCellReuseIdentifier: cellName)
        
        let headerNib: UINib = UINib(nibName: headerName, bundle: nil)
        listTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerName)
        
        listTableView.dataSource = self
        listTableView.delegate = self
        
        listScrollView.contentSize = CGSize(width: 414, height: listTableView.frame.height + listSearchBar.frame.height)
        
        listSearchBar.delegate = self
        
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor(red: 0.935, green: 0.521, blue: 0.491, alpha: 1),
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
        ]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        
        getAllUsers()
        saveUsers = users
    }
    
    override func viewDidAppear(_ animated: Bool) {
        listScrollView.contentOffset = CGPoint(x: 0, y: listSearchBar.frame.height)
        listTableView.reloadData()
        listTableView.tableFooterView = UIView()
    }
    
    
    
    fileprivate func getAllUsers() {
        let coreUsers: [Users] = CoreDataManager.shared.getUsers()
        var temp: [User] = []
        for user in coreUsers {
            
            temp.append(User(name: user.name!, score: Int(user.score),date: user.date!))
        }
        users = temp
        users = users.sorted(by: { $0.score > $1.score })
    }
    
    fileprivate func saveNewUser(_ id: Int32, name: String, score: Int32, date:Date) {
        
        CoreDataManager.shared.saveUser(id: id, name: name, score: score, date:date, onSuccess: { onSuccess in
            print("saved =\(onSuccess)")
        })
    }

}

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.indexLabel.text = "\(indexPath.row + 1)"
        cell.userNameLabel.text = users[indexPath.row].name
        cell.userScoreLabel.text = "\(users[indexPath.row].score)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailViewController else {
            return
        }
        let index = sender as! Int
        vc.user = users[index]
    }
    
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerName) as? TableViewHeader else {
            return UITableViewHeaderFooterView()
        }
        header.tintColor = #colorLiteral(red: 0.9971589446, green: 0.916033566, blue: 0.8466821313, alpha: 1)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailSegue", sender: indexPath.row)
    }
}

extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        users = searchText.isEmpty ? saveUsers : saveUsers.filter( {(data:User) -> Bool in
            return data.name.range(of: searchText, options: .caseInsensitive) != nil
        })
        listTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.listSearchBar.showsCancelButton = false
        self.listSearchBar.text = ""
        self.listSearchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.listSearchBar.showsCancelButton = true
    }
}
