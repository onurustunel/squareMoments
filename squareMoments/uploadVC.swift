//
//  uploadVC.swift
//  InstaCloneFirebase
//
//  Created by MEHMET ONUR ÜSTÜNEL on 14.03.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit
import Firebase


class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
   
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.getSwipeAction(_:)))
        self.view.addGestureRecognizer(swipeGesture)
      
       let imagePickRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagePick))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imagePickRecognizer)
        commentText.isHidden = true
        saveButton.isHidden = true
   
    }
    @objc func getSwipeAction( _ recognizer : UISwipeGestureRecognizer){
        
        if recognizer.direction == .right{
            performSegue(withIdentifier: "photoUploaded", sender: nil)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if count == 0 {
            imagePick()
        }
       
    }
   
    
    @objc func imagePick(){
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        picker.delegate = self
        count += 1
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        //
        addPhotoLabel.isHidden = true
        commentText.isHidden = false
        saveButton.isHidden = false
      //  count += 1
        
    }

    @IBAction func saveClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
      
        let uuid = UUID().uuidString
       
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            
            
            imageReferance.putData(data, metadata: nil) { (metadata, error) in
                //code
                if error != nil {
                    print("error")
                  
                } else {
                    imageReferance.downloadURL { (url, error) in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                        let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0 ] as [String : Any]
                            
                        
                        
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                            if error != nil {
                                print("error")
                                
                            } else {
                                
                                self.imageView.image = UIImage(named: "")
                                self.commentText.text = ""
                                self.performSegue(withIdentifier: "photoUploaded", sender: nil)
                                
                            }
                          
                        })
                    
                    }
                  
                }
               
            }
   
        }
      }
    }
 
}
