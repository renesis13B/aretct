//
//  AddEditCategoryVC.swift
//  AretctAdmin
//
//  Created by yw on 2019/08/26.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: RoundImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: UIButton!
    
    var categoryToEdit : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
        
        // If we are editing, categoryToEdit will != nil
        if let category = categoryToEdit {
            nameTxt.text = category.name
            addBtn.setTitle("変更を保存する", for: .normal)
            
            if let url = URL(string: category.imgUrl) {
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
            }
        }
        
       
    }
    
    @objc func imgTapped(_ tap: UITapGestureRecognizer) {
        launchImgPicker()
    }
    
    @IBAction func addCategoryClicked(_ sender: Any) {
       
        
        uploadImageTheDocument()
    }
    
    func uploadImageTheDocument() {
        //画像をイメージピッカーから取得できなくても送れるので修正する
        guard let image = categoryImg.image,
            let categoryName = nameTxt.text, categoryName.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Must add category image and name")
                return
        }
        
        activityIndicator.startAnimating()
        
        //Step1: Turn the image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        
        //Step2: Create an strage image referrence -> A location in Firestrage for it to be store
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        
        //Step3: Set the meta data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //Step4: Upload the data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image")
                return
            }
            //Step5 Once the image is uploaded, retrieve the download URL.
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to retrieve image url")
                    return
                }
                guard let url = url else {return}
                
                //Step6 Upload new Category document to the Firestore categories collection
                self.uploadDocument(url: url.absoluteString)
            })
        }
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var category = Category.init(name: nameTxt.text!,
                                     id: "",
                                     imgUrl: url,
                                     timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            //We are editting
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        } else {
            docRef = Firestore.firestore().collection("categories").document()
            //docRef.documentIDは自動で生成されるのか？
            category.id = docRef.documentID
        }
        
        
        
        let data = Category.modelTodata(category: category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload new category to Firestore")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
    }
    
}

extension AddEditCategoryVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //メディアの選択を完了したこと、その情報ディクショナリが返され、その中に画像ピッカー情報がる、そこから選択した画像を取得できる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
