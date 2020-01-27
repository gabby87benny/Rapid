//
//  ViewController.swift
//  Rapid
//
//  Created by Joseph Peter, Gabriel Benny Francis on 1/9/20.
//  Copyright © 2020 Gabby. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    @IBOutlet weak var _tableView: UITableView!
    //@IBOutlet weak var _lbl1: UILabel!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userProvider = UserProvider()
        userProvider.getUsers { [unowned self] (users, error) in
            if !error.isEmpty {
                let alertController = UIAlertController(title: "Error", message: "User service is failed", preferredStyle: .alert)
                let alertOKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(alertOKAction)
                alertController.addAction(alertCancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else if let users = users {
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
}


extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RapidRootStaticCellIdentifier", for: indexPath)
        let user: User = self.users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
}

/*
extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}*/
