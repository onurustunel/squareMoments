//
//  logoutVC.swift
//  InstaCloneFirebase
//
//  Created by MEHMET ONUR ÜSTÜNEL on 14.03.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage


class logoutVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var profileTableView: UITableView!
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var userImageArray = [String]()
    var userNameArray = [String]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        getDatafromFirebase()
        
    }
    
    @IBAction func addClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toUploadVC", sender: nil)
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "tofirstVC", sender: nil)
                
            } catch {
                print("error")
            }
            
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! profileTableViewCell
        cell.userEmaiLabel.text = userEmailArray[indexPath.row]
        cell.commentLabel.text = userCommentArray[indexPath.row]
    
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
         cell.userNameLabel.text = "\(userNameArray[indexPath.row]):"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 557.0
        
    }
   
    func getDatafromFirebase(){
        
        
        let fireStoreDatabase = Firestore.firestore()
        
        let profilName = Auth.auth().currentUser?.email
        
        fireStoreDatabase.collection("Posts").whereField("postedBy", isEqualTo: profilName).order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("error")
                
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents {
                    var name = ""
                        let documentID = document.documentID
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                            for i in postedBy {
                                if i != "@" {
                                    name += String(i)
                                    
                                    
                                } else {
                                    self.userNameArray.append(name)
                                    break
                                }
                                
                                print("////////////////////////////GELİYOOOOOOOO")
                                print(self.userNameArray)
                                
                            }
                            
                        }
                        
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        
                      
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                        
                    }
                    
                    self.profileTableView.reloadData()
                    
                }
               
            }
        }
       
    }
     
}
