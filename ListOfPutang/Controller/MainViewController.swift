//
//  MaubViewController.swift
//  ListOfPutang
//
//  Created by Kitja  on 25/8/2565 BE.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import RealmSwift
import Firebase

class MainViewController: UIViewController{
    let db = Firestore.firestore()
    var listOfAnimeJson = [Data]()
    var listOfAnimeToTableView = [DataToSetTableView]()
    var listOfAnimeToSearch = [DataToSetTableView]()
    var apiCall = ApiCall()
    let searchController = UISearchController()
    let firebaseModel = FireBaseModel()
    var dataFromFB:[DataFB2] = []
    var customCell = CustomCell()
    var detailOfAnime2 = DetailOfAnime2()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        setCurrentUser()
        filterDataFromFirebaseForUpdateFavorite()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        setupObserverForUnfavoriteFromDetail2()
        apiCall.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setUserDafaultForSearch()
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        hideSpinner()
    }
    
    private func showSpinner() {
        activityIndicator.startAnimating()
        loadingView.isHidden = false
    }
    
    private func hideSpinner() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }
    
    private func setCurrentUser(){
        UserName.sharedInstance.userName = Auth.auth().currentUser?.uid
    }
    
    private func setUserDafaultForSearch(){
        if UserDefaults.standard.string(forKey: "startApp") != nil{
            if let startApp = UserDefaults.standard.string(forKey: "startApp") {
                apiCall.fetchAnime(animeName: startApp)
            }
        }
    }
    
    func passDataToview(data: DataFromJson) {
        listOfAnimeJson = data.data
        listOfAnimeToTableView = DataToSetTableView.createDataToSetTableView(datas: listOfAnimeJson)
        filterDataFromFirebaseForUpdateFavorite()
        listOfAnimeToSearch = listOfAnimeToTableView
        tableView.reloadData()
    }

    func filterDataFromFirebaseForUpdateFavorite() {
        guard let currentUser = UserName.sharedInstance.userName else{
            return
        }
        showSpinner()
        db.collection(currentUser).getDocuments { querySnapshot, error in
            if error != nil{
                print("can not load data from firestore")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let titleForFilterToSetFavoriteFromFirebase = doc.documentID
                        for i in self.listOfAnimeToTableView.indices {
                            if self.listOfAnimeToTableView[i].title == titleForFilterToSetFavoriteFromFirebase  {
                                self.listOfAnimeToTableView[i].favorite = true
                            }
                        }
                    }
                    self.listOfAnimeToSearch = self.listOfAnimeToTableView
                    if self.searchController.searchBar.text == ""{
                        self.tableView.reloadData()
                    } 
                    self.hideSpinner()
                }
            }
        }
    }
    
    @IBAction func favoriteMovie(_ sender: UIButton){
        performSegue(withIdentifier: "goToFavarite", sender: self)
    }
    
    @IBAction func inputMovieNameButton(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Movies name", message: "Please enter movie name", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.apiCall.fetchAnime(animeName: textField.text!)
            SearchTextForFetchData.sharedInstance.searchText = textField.text!
            UserDefaults.standard.set(textField.text!, forKey: "startApp")
            UserDefaults.standard.synchronize()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default)
        { (action) in
        }
        alert.addAction(action)
        alert.addAction(action2)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Movie name"
        }
        present(alert, animated: true)
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            performSegue(withIdentifier: "goToLogin", sender: self)
            UserDefaults.standard.set("", forKey: "startApp")
            UserDefaults.standard.synchronize()
            
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
}

extension MainViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfAnimeToSearch.count < 1 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        return listOfAnimeToSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        let imgUrl = listOfAnimeToSearch[indexPath.row].images
        cell.delegateUnFavorite = self
        cell.delegateFavorite = self
        cell.nameLabel.text = String(listOfAnimeToSearch[indexPath.row].title)
        cell.titleLabel.text = listOfAnimeToSearch[indexPath.row].synopsis
        cell.scoreLabel.text = "Score\(listOfAnimeToSearch[indexPath.row].score ?? 00 )/10"
        cell.malID = Int(listOfAnimeToSearch[indexPath.row].mal_id)
        cell.url = listOfAnimeToSearch[indexPath.row].url
        cell.score = Int(listOfAnimeToSearch[indexPath.row].score ?? 0)
        cell.imgURL = imgUrl
        cell.mainImage.downloaded(from: imgUrl )
        cell.mainImage.layer.cornerRadius  = CGFloat(20)
        switch listOfAnimeToSearch[indexPath.row].favorite {
        case false:
            cell.star.setImage(UIImage(systemName: "star"), for: .normal)
        case true:
            cell.star.setImage(UIImage(systemName: "star.fill"), for: .normal)
        default:
            print("error swap star")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailOfAnime") as! DetailOfAnime
        vc.delegate = self
        vc.listOfAnime2 = listOfAnimeToSearch[tableView.indexPathForSelectedRow?.row ?? 0]
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - delegate,ObserverNotification
extension MainViewController:PassDataToViewDelegate,PassActionToStarBackToMainViewFavorite,PassActionToStarBackToMainViewUnFavorite,PassUnfavoriteToMainControllerForSetStarToNormal{
    
    func passActionBackToMainFavorite(name: String) {
        for i in listOfAnimeToTableView.indices{
            if listOfAnimeToTableView[i].title == name {
                listOfAnimeToTableView[i].favorite = true
            }
        }
        for i in listOfAnimeToSearch.indices{
            if listOfAnimeToSearch[i].title == name {
                listOfAnimeToSearch[i].favorite = true
            }
        }
    }
    
    func passActionBackToMainUnFavorite(name: String) {
        for i in listOfAnimeToTableView.indices{
            if listOfAnimeToTableView[i].title == name {
                listOfAnimeToTableView[i].favorite = false
            }
        }
        for i in listOfAnimeToSearch.indices{
            if listOfAnimeToSearch[i].title == name {
                listOfAnimeToSearch[i].favorite = false
            }
        }
    }
    
    func unFavorite(name: String) {
        for i in listOfAnimeToTableView.indices{
            if listOfAnimeToTableView[i].title == name {
                listOfAnimeToTableView[i].favorite = false
            }
        }
        listOfAnimeToSearch = listOfAnimeToTableView
    }
    
    func setupObserverForUnfavoriteFromDetail2(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNoti(_:)), name: .myNotification, object: nil)
    }
    
    @objc func handleNoti(_ sender: Notification){
        let name = (sender.userInfo?["title"] as? String)!
        for i in listOfAnimeToTableView.indices{
            if listOfAnimeToTableView[i].title == name {
                listOfAnimeToTableView[i].favorite = false
            }
        }
        listOfAnimeToSearch = listOfAnimeToTableView
    }
}

extension MainViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        listOfAnimeToSearch = []
        if let  searchText = searchController.searchBar.text{
            if searchText == ""{
                listOfAnimeToSearch = listOfAnimeToTableView
            }else{
                for anime in listOfAnimeToTableView {
                    if anime.title.lowercased().contains(searchText.lowercased()){
                        listOfAnimeToSearch.append(anime)
                    }
                }
            }
        }
        tableView.reloadData()
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension NSNotification.Name{
    static let myNotification = NSNotification.Name("title")
}


