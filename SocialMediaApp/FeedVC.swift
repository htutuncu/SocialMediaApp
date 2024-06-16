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
    var posts = [Post]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    func fetchData() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                print("Veri bulunamadı.")
                return
            }
            
            self.posts.removeAll(keepingCapacity: false)
            
            for doc in querySnapshot.documents {
                var post = Post()
                let documentID = doc.documentID
                post.documentId = documentID
                if let url = doc["imgUrl"] as? String {
                    post.imageUrl = url
                }
                if let postedBy = doc.get("postedBy") as? String {
                    post.userName = postedBy
                }
                if let postDesc = doc.get("postDescription") as? String {
                    post.postDescription = postDesc
                }
                if let likes = doc.get("likes") as? Int {
                    post.likes = likes
                }
                self.posts.append(post)
            }
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostCell
        cell.configure(post: posts[indexPath.row])
        return cell
    }
    

}
