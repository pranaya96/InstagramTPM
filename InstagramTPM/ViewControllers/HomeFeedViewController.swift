//
//  HomeFeedViewController.swift
//  InstagramTPM
//
//  Created by Pranaya Adhikari on 8/19/18.
//  Copyright © 2018 Pranaya Adhikari. All rights reserved.
//

import UIKit
import Parse

class HomeFeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
     var instaPosts: [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        //tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.rowHeight = 350
        tableView.dataSource = self
        tableView.delegate = self
        self.loadQueries()
        //tableView.reloadData()
        
        // Initialize a UIRefreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCompose(_ sender: Any) {
    
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
    
      NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! PostViewCell
        cell.instagramPost = self.instaPosts[indexPath.row]
        print(instaPosts)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.instaPosts.count != 0{
            return self.instaPosts.count
        }else{
            print("no posts found")
            return 0
        }
        
    }
    
    func loadQueries(){
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.includeKey("createdAt")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                // do something with the array of object returned by the call
                self.instaPosts = posts as! [Post]
                //print(posts)
            } else {
                print(error?.localizedDescription)
            }
            self.tableView.reloadData()
        }
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        loadQueries()
        // Tell the refreshControl to stop spinning
        //self.tableView.reloadData()
        refreshControl.endRefreshing()
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
