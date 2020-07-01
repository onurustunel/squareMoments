//
//  feedVC.swift
//  InstaCloneFirebase
//
//  Created by MEHMET ONUR ÜSTÜNEL on 14.03.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    var userNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getDatafromFirebase()
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellVC
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.commentLabel.text = userCommentArray[indexPath.row]
        
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.userNameLabel.text = "\(userNameArray[indexPath.row]):"
        
       
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 557.0
        
    }
   
    func getDatafromFirebase(){
       
        let fireStoreDatabase = Firestore.firestore()
    
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("error")
                
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents {
                        var name = ""
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                          
                            for i in postedBy {
                                if i != "@" {
                                    name += String(i)
                                   
                                } else {
                                   self.userNameArray.append(name)
                                    break
                                }
                               
                            }
                        }
                        
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                        
                        
                    }
                    
                    self.tableView.reloadData()
                   
                    
                }
                
                
            }
        }
        
 
    }
    


}
