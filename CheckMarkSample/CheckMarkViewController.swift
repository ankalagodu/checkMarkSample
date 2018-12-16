//
//  CheckMarkViewController.swift
//  CheckMarkSample
//
//  Created by Koushik on 30/07/18.
//  Copyright © 2018 Wolken Software Pvt Ltd. All rights reserved.
//

import UIKit

class CheckMarkViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.allowsMultipleSelection = true
        }
    }
    
    var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }
    
    var selectedItems: [WatcherData] {
        get{
            //return UserDefaults.standard.object(forKey: "selectedItems") as? [ViewModelItem] ?? []
            return watcherUsersList.filter { return $0.isSelected }
        }
    }
    
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
    var watcherUsersList:[WatcherData] = []
    var filteredList:[WatcherData] = []
    var delegate:ViewDelegate?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "WatcherTableViewCell", bundle: nil), forCellReuseIdentifier: WatcherTableViewCell.ID)
        
        self.setUPNavigationBar()
        self.setUPSearchBar()
        
        if watcherUsersList.count == 0{
            getWatcherUsers()
        }else{
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUPSearchBar(){
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.placeholder = "Search Users Here"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self // as? UISearchBarDelegate
    }
    
    func setUPNavigationBar(){
        let  doneButton:UIButton = UIButton(type: .custom)
        doneButton.titleLabel?.font =  UIFont(name: "Helvetica Neue Medium", size: 12)
        // Get the first button's image
        doneButton.setTitle("DONE", for: .normal)
        //view2.backgroundColor = UIColor.white
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        doneButton.frame = CGRect(x: 0, y: 0, width: 30, height: 18)
        doneButton.setTitleColor(UIColor.blue, for: .normal)
        
        // Create two UIBarButtonItems
        let item1:UIBarButtonItem = UIBarButtonItem(customView: doneButton)
        
        self.navigationItem.rightBarButtonItems = [item1]
    }
    
    @objc func didTapDoneButton(sender: AnyObject){
      
        self.delegate?.setWatchersList(self.watcherUsersList)
        self.navigationController?.popViewController(animated: true)
        
    }
    

    func getWatcherUsers(){
        
        WebService.sharedInstance.onmobileGetWatcherUsers({
            (isCompleted,JSONResponse) -> Void in
            
            // check completion
            if (isCompleted) {
                /*got response in API:{
                 "watcherDetails" : [
                 {
                 "userPsNo" : "super_admin",
                 "userFullName" : "Super Admin",
                 "userLname" : "Admin",
                 "userFname" : "Super",
                 "userEmail" : "poornima@wolkensoftware.com",
                 "userId" : 1,
                 "activeUser" : true
                 },
                 {
                 "userPsNo" : "onm_admin",
                 "userFullName" : "admin Admin",
                 "userLname" : "Admin",
                 "userFname" : "admin",
                 "userEmail" : "poornima@wolkensoftware.com",
                 "userId" : 2,
                 "activeUser" : true
                 }
                 ],
                 "statusDesc" : "Success",
                 "userId" : null,
                 "sessionId" : null,
                 "companyId" : null
                 }*/
                
                self.watcherUsersList = JSONResponse["watcherDetails"].arrayValue.map { WatcherData(item:$0) }
                self.tableView.reloadData()
                //success(true,JSONResponse)
            }else{
                
            }
        }) {
            (error) -> Void in
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CheckMarkViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return filteredList.count
        }else{
            return watcherUsersList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell=tableView.dequeueReusableCell(withIdentifier: WatcherTableViewCell.ID, for: indexPath) as? WatcherTableViewCell {
            if searchActive && self.filteredList.count > 0{
                cell.cellData = filteredList[indexPath.row]
            }else{
                cell.cellData = watcherUsersList[indexPath.row]
            }
            
            
            // select/deselect the cell
            if (cell.cellData?.isSelected)! {
                if !cell.isSelected {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            } else {
                if cell.isSelected {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        if searchActive {
            filteredList[indexPath.row].isSelected = true
        }else{
            watcherUsersList[indexPath.row].isSelected = true
        }
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        if searchActive{
            filteredList[indexPath.row].isSelected = false
        }else{
            watcherUsersList[indexPath.row].isSelected = false
        }
    
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
}

extension CheckMarkViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        //searchController.searchBar.becomeFirstResponder()
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        //searchController.searchBar.resignFirstResponder()
        
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.filteredList = []
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        if let searchText = searchBar.text{
            let items = self.watcherUsersList.filter({ $0.item["userFullName"].stringValue.contains(searchText) })
            self.filteredList = items
            self.tableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    

}
