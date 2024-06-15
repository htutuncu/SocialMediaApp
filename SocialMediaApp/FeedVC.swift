//
//  FeedVC.swift
//  SocialMediaApp
//
//  Created by Hikmet Tütüncü on 14.06.2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userNameArray = [String]()
    var postDescArray = [String]()
    var likeArray = [Int]()
    var imageArray = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    func fetchData() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                print("Veri bulunamadı.")
                return
            }
            
            self.imageArray.removeAll(keepingCapacity: false)
            self.likeArray.removeAll(keepingCapacity: false)
            self.postDescArray.removeAll(keepingCapacity: false)
            self.userNameArray.removeAll(keepingCapacity: false)
            
            for doc in querySnapshot.documents {
                if let url = doc["imgUrl"] as? String {
                    self.imageArray.append(url)
                }
                if let postedBy = doc.get("postedBy") as? String {
                    self.userNameArray.append(postedBy)
                }
                if let postDesc = doc.get("postDescription") as? String {
                    self.postDescArray.append(postDesc)
                }
                if let likes = doc.get("likes") as? Int {
                    self.likeArray.append(likes)
                }
            }
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostCell
        cell.configure(userName: self.userNameArray[indexPath.row],
                       postImageUrl: self.imageArray[indexPath.row],
                       postDesc: self.postDescArray[indexPath.row],
                       likes: "Likes: \(self.likeArray[indexPath.row])")
        return cell
    }
    

}
