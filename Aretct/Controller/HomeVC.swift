//
//  ViewController.swift
//  Aretct
//
//  Created by yw on 2019/08/19.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class HomeVC: UIViewController {
    //Outlets
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Variables
    var categories = [Category]()
    var selectedCategory: Category!
    var db : Firestore!
    var listener : ListenerRegistration!
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //これでFirestoreのルート(Home)ディレクトリが取得できる
        db = Firestore.firestore()
        setupCollectionView()
        setupInitialAnonymousUser()
        //Storybordからもナビゲージョンのスタイルを変更可能
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        guard let font = UIFont(name: "futura", size: 26) else {return}
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font
        ]
    }
    
    func setupCollectionView() {
        //デリゲート
        collectionView.delegate = self
        collectionView.dataSource = self
        //XIBsで定義したCellを利用するため
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
    }
    
    func setupInitialAnonymousUser() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        //viewDidLoadはviewのインスタンス時に一度だけ呼ばれる
        //対照的にviewDidAppearはロードするたびに表示される
        
        setCategoriesListener()
        
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginOutBtn.title = "Logout"
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        } else {
            loginOutBtn.title = "Login"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //VCが破棄されると監視を削除する
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    func setCategoriesListener() {
        //categoriesはUtileで記述したクエリ参照
        listener = db.categories.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                
                //変更があったドキュメントのdata([string:Any]で送られる)を参照して新しくインスタンスを生成する
                let category = Category.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumnetAdded(change: change, category: category)
                case .modified:
                    self.onDocumnetModified(change: change, category: category)
                case .removed:
                    self.onDocumnetRemoveed(change: change)
                }
            })
        })
    }
    
    
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        //storyboardの初期viewcontrollerを初期化する
        let contoroller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(contoroller, animated: true, completion: nil)
    }

    //Action
    
    
    @IBAction func favoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToFavorites, sender: self)
    }
    
    @IBAction func loginOutClicked(_ sender: Any) {
        guard let user = Auth.auth().currentUser else {return}
        if user.isAnonymous {
            //匿名ログインの場合、実際にはFirebaseセッションからログアウトさせないため
            //匿名ログインはログインしたままにする
            presentLoginController()
        } else {
            //匿名ログイン以外でログアウトボタンを押した場合
            do{
                try Auth.auth().signOut()
                loginManager.logOut()
                //ログアウト後に、匿名ログイン状態に戻す必要があるから
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                        debugPrint(error)
                    }
                    self.presentLoginController()
                    
                }
            } catch{
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
            }
        }
    }
    
}


extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func onDocumnetAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        //コレクションビューの内部データ構造を更新し、再読み込みをさせる
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    func onDocumnetModified(change: DocumentChange, category: Category) {
        if change.newIndex == change.oldIndex {
            //Item chnaged , but remaind in the same posistion
            let index = Int(change.newIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            //Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
        
    }
    func onDocumnetRemoveed(change: DocumentChange ) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width - 30) / 2
        //横とのアスペクト比が1.5
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToProducts {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
            }
        } else if segue.identifier == Segues.ToFavorites {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
                destination.showFavorites = true
            }
        }
    }
}


//参考用

//    func fetchDocument() {
//        //単一ドキュメントの参照を作成する
//        let docRef = db.collection("categories").document("jJYI5f0YRQl2759CGJv1")
//        //スナップショットイベントの監視をする
//        //ドキュメントデータに変更があるたびにコードブロックを実行する
//        docRef.addSnapshotListener { (snap, error) in
//            //変更があると、初期化された時のインスタンスが入っているインスタンスにさらに追加されるの
//            //結果的に更新前と更新後のドキュメントのオブジェクトが表示されることになる
//            //よってremoveによって更新前のドキュメントを削除して、再度更新後のドキュメントでレンダリングする
//            self.categories.removeAll()
//            guard let data = snap?.data() else {return}
//            let newCategory = Category.init(data: data)
//            self.categories.append(newCategory)
//            self.collectionView.reloadData()
//        }
//
//    }

//    func fetchCollection() {
//        //コレクションを参照して、その中に含まれる複数のドキュメントを取得する
//        let collectionReference = db.collection("categories")
//
//        listener = collectionReference.addSnapshotListener { (snap, error) in
//            guard let documents = snap?.documents else {return}
//
//            //
//            print(snap?.documentChanges.count)
//
//            self.categories.removeAll()
//            for document in documents {
//                let data = document.data()
//                let newCategory = Category.init(data: data)
//                self.categories.append(newCategory)
//            }
//            self.collectionView.reloadData()
//        }

//クエリスナップショットを返す参照を取得する
//        collectionReference.getDocuments { (snap, error) in
//            guard let documents = snap?.documents else {return}
//            for document in documents {
//                let data = document.data()
//                let newCategory = Category.init(data: data)
//                self.categories.append(newCategory)
//            }
//            self.collectionView.reloadData()
//        }
//    }
