//
//  NetworkViewController.swift
//  Rapid
//
//  Created by Joseph Peter, Gabriel Benny Francis on 3/26/20.
//  Copyright © 2020 Gabby. All rights reserved.
//

import UIKit

struct NetworkViewControllerConstants {
    static let Cellidentifier = "NetworkViewCellIdentifier"
    static let NetworkErrorTitle = "Error"
    static let NetworkErrorMessage = "User API service is failed"
}

class NetworkViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    
    let userProvider = UserProvider()

    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NetworkViewControllerConstants.Cellidentifier)
        userProvider.getUsers { (result) in
            switch result {
            case .success(let users):
                self.users = users
                self.tableView.reloadData()
                
            case .failure(let error):
                print("Error: \(error)")
                let alertController = UIAlertController(title: NetworkViewControllerConstants.NetworkErrorTitle, message: NetworkViewControllerConstants.NetworkErrorMessage, preferredStyle: .alert)
                let alertOKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(alertOKAction)
                alertController.addAction(alertCancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension NetworkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NetworkViewControllerConstants.Cellidentifier, for: indexPath)
        let user: User = self.users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
}

