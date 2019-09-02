//
//  AddEditProductsVC.swift
//  AretctAdmin
//
//  Created by yw on 2019/08/29.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {
    //Outlets
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescTxt: UITextView!
    @IBOutlet weak var productImgView: RoundImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: RoundedButton!
    
    
    //Variables
    var selectedCategory : Category!
    var productToEdit : Product?
    var name = ""
    var price = 0.0
    var productDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        productImgView.isUserInteractionEnabled = true
        productImgView.clipsToBounds = true
        productImgView.addGestureRecognizer(tap)
        
        if let product = productToEdit {
            productNameTxt.text = product.name
            productDescTxt.text = product.productDescription
            productPriceTxt.text = String(product.price)
            
            if let url = URL(string: product.imageUrl) {
                 productImgView.contentMode = .scaleToFill
                productImgView.kf.setImage(with: url)
            }
            
        }
    }
    
    @objc func imgTapped() {
        // Launch the image picker
        launchImgPicker()
    }

    @IBAction func addClicked(_ sender: Any) {
        uploadImageTheDocument()
    }
    
    func uploadImageTheDocument() {
        guard let image = productImgView.image,
        let name = productNameTxt.text, name.isNotEmpty,
        let description = productDescTxt.text, description.isNotEmpty,
        let priceString = productPriceTxt.text,
            let price = Double(priceString) else {
                simpleAlert(title: "Missing Field", msg: "Please fill out all required fields.")
                return
        }
        
        self.name = name
        self.productDescription = description
        self.price = price
        
        
        activityIndicator.stopAnimating()
        
        //Step1 Turn the image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        
        //Step2: Create an strage image referrence -> A location in Firestrage for it to be store
        let imageRef = Storage.storage().reference().child("/productImages/\(name).jpg")
        
        //Step3: Set the meta data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //Step4: Upload the data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image.")
            }
            
             //Step5 Once the image is uploaded, retrieve the download URL.
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to douwload url")
                    return
                }
                
                guard let url = url else {return}
                //print(url)
                
                
                //Step6 Upload new Category document to the Firestore categories collection
                self.uploadDocumnet(url: url.absoluteString)
            })
        }
    }
    
    func uploadDocumnet(url: String) {
        var docRef : DocumentReference!
        var product = Product.init(name: name,
                                   id: "",
                                   category: selectedCategory.id,
                                   price: price,
                                   productDescription: productDescription,
                                   imageUrl: url)
        
        if let productToEdit = productToEdit {
            // We are editting a product
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            //document()で自動付与Idがついたドキュメントを参照できる
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        //辞書型に変換する
        let data = Product.modalToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload Firestore document.")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func uploadDocumnet() {
        
    }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        simpleAlert(title: "Error", msg: msg)
        activityIndicator.stopAnimating()
    }
    
}


extension AddEditProductsVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        productImgView.contentMode = .scaleAspectFill
        productImgView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
