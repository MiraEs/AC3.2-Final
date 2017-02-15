//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Ilmira Estil on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    var databaseRef: FIRDatabaseReference!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var commentField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        self.databaseRef = FIRDatabase.database().reference().child("posts")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(tapGestureRecognizer)
        
        //nav bar
        self.navigationItem.title = "Unit6-Final"
    
    }
    
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("tapped image")
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: - Set up picker funcitons
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.uploadImageView.contentMode = .scaleAspectFit
            self.uploadImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Upload pic to firebase
    
    func addToFB() {
        //stored to storage
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let comment = commentField.text else { return }
        let linkRef = self.databaseRef.childByAutoId()
        let storageRef = FIRStorage.storage().reference().child("images").child(linkRef.key)
        
        if let uploadData = UIImageJPEGRepresentation(self.uploadImageView.image!, 0.5) {

            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                //stored to database
                let values = ["userId": uid, "comment": comment]
              
                linkRef.setValue(values) { (error, reference) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print(reference)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            })
        }
    }
  
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        addToFB()
    }

    
    
    
    
}
