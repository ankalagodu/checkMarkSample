//
//  ViewController.swift
//  CheckMarkSample
//
//  Created by Koushik on 30/07/18.
//  Copyright © 2018 Wolken Software Pvt Ltd. All rights reserved.
//

import UIKit

protocol  ViewDelegate {
    func setWatchersList(_ items:[WatcherData])
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
    
    var watcherUsersList:[WatcherData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue"{
            let VC = segue.destination as! CheckMarkViewController
            if self.watcherUsersList.count != 0{
                VC.watcherUsersList = watcherUsersList
            }
            VC.delegate = self
            
        }
    }


}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Watchers"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetailSegue", sender: nil)
    }
    
}

extension ViewController:ViewDelegate{
    
    func setWatchersList(_ items:[WatcherData]){
        self.watcherUsersList = items
    }
}

