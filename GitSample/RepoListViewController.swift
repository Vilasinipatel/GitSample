//
//  RepoListViewController.swift
//  GitSample
//
//  Created by Villasini Patel on 09/09/19.
//  Copyright © 2019 vils. All rights reserved.
//

import UIKit
struct gitUser : Decodable {
    var name : String
    var repos_url : String
    var id: Double
}
struct repoDetails : Decodable {
    var name : String
    var html_url : String
    var created_at : String
}
class RepoListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    let repoArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.gitUserDetail()
    }
    func gitUserDetail() -> Void {
        Services.getGitUser(onSuccess: { (data) in
            do{
                let gitUserInfo = try JSONDecoder().decode(gitUser.self, from: data)
                DispatchQueue.main.async {
                    self.userName.text = gitUserInfo.name
                    let repoUrlString = gitUserInfo.repos_url
                    self.gitRepoDetail(repoUrl: repoUrlString)
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }) { (error) in
            print("Error in gitUserDetail\(error.localizedDescription)")
        }
    }
    
    func gitRepoDetail(repoUrl:String) -> Void {
        Services.getUserRepos(repoUrl: repoUrl, onSuccess: { (data) in
            do{
                let repos = try JSONDecoder().decode([repoDetails].self, from: data) as Array
                self.repoArray.addObjects(from: repos)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch{
                print(error.localizedDescription)
            }

        }) { (error) in
            print("Repo Detail Error\(error.localizedDescription)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.repoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = UIColor.white
        let repoD = self.repoArray[indexPath.row] as! repoDetails
        cell.textLabel?.text = repoD.name
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
