//
//  ViewController.swift
//  Rapid
//
//  Created by Joseph Peter, Gabriel Benny Francis on 1/9/20.
//  Copyright © 2020 Gabby. All rights reserved.
//

import UIKit

struct RootViewControllerConstants {
    static let networkSegueIdentifier = "PushNetworkSequeIdentifier"
    static let concurrencySegueIdentifier = "RootViewConcurrencyCellIdentifier"
    static let rootViewCellIdentifier = "RootViewCellIdentifier"
}

//enum RootViewControllerIdentifiers: String {
//    case RootViewNetworkCellIdentifier = "RootViewNetworkCellIdentifier"
//    case RootViewCoreDataCellIdentifier = "RootViewCoreDataCellIdentifier"
//    case RootViewConcurrencyCellIdentifier = "RootViewConcurrencyCellIdentifier"
//}

class ViewController: UITableViewController {

    @IBOutlet weak var _tableView: UITableView!
    
    struct RootItem {
        var title: String
        var subTitle: String
    }
    
    var rootItemsList = [
        RootItem(title: "Network operations", subTitle: "Network"),
        RootItem(title: "Concurrency operations", subTitle: "Concurrency")
    ]
    
    let userProvider = UserProvider()

    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProvider.getUsers { (result) in
            switch result {
            case .success(let users):
                self.users = users
                self.tableView.reloadData()
                
            case .failure(let error):
                print("Error: \(error)")
                let alertController = UIAlertController(title: "Error", message: "User API service is failed", preferredStyle: .alert)
                let alertOKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(alertOKAction)
                alertController.addAction(alertCancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func pushOrPresentStoryboard(storyboardName: String, cellIndexPath: IndexPath) {
        let exampleStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let exampleViewController = exampleStoryboard.instantiateInitialViewController() {
            pushOrPresentViewController(viewController: exampleViewController, cellIndexPath: cellIndexPath)
        }
    }

    func pushOrPresentViewController(viewController: UIViewController, cellIndexPath: IndexPath) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: Table view Data source
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootItemsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RootViewControllerConstants.rootViewCellIdentifier, for: indexPath)
        let rootItem = rootItemsList[indexPath.row]
        cell.textLabel?.text = rootItem.title
        cell.detailTextLabel?.text = rootItem.subTitle
        return cell
    }
}

//MARK: Table view Delegate
extension ViewController {
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rootItem = rootItemsList[indexPath.row]
        pushOrPresentStoryboard(storyboardName: rootItem.subTitle, cellIndexPath: indexPath)
    }
}
