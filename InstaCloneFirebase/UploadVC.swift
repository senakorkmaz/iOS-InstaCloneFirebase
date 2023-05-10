//
//  UploadVC.swift
//  InstaCloneFirebase
//
//  Created by Senanur Korkmaz on 30.04.2023.
//

import UIKit
import FirebaseStorage
import Firebase

class UploadVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choseImage))
        imageView.addGestureRecognizer(gestureRecognizer)

    }
    
    @objc func choseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okBtn)
        self.present(alert, animated: true)
    }
    
    @IBAction func uploadTapped(){
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { (metaData, error) in
                if error != nil{
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Upload Error")
                }else{
                    imageReference.downloadURL { url, error in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            //Database
                    
                            let db = Firestore.firestore()
                            var ref: DocumentReference? = nil
                            let data = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentTextField.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            ref = db.collection("posts").addDocument(data : data, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(title: "Database Error", message: error?.localizedDescription ?? "Database Error")
                                }else {
                                    print("Document added with ID: \(ref!.documentID)")
                                    
                                    self.imageView.image = UIImage(systemName: "photo")
                                    self.commentTextField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                        }
                    }
                }
            }
        }
        
    }
    
}
