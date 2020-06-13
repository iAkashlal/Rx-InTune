//
//  MusicViewController.swift
//  InTune
//
//  Created by Akashlal on 28/03/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class MusicViewController: UIViewController {
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var guideView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedIndex: Int = 0
    var disposeBag = DisposeBag()
    private var viewModel : MusicListViewModel!
    private var selectedMusicModel: MusicViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "InTune Music"
        
        viewModel = MusicListViewModel([MusicItem]())
        
        viewModel.toggleViewStatus.asDriver()
            .drive(self.guideView.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.loaderViewStatus.asDriver()
            .drive(self.loaderView.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.errorLabelText.asDriver()
            .drive(self.errorLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.tableViewReload.asDriver().drive(onNext: { _ in
            self.tableView.reloadData()
        })
        
        self.searchBar.rx.searchButtonClicked.map{self.searchBar.text}
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (query) in
                self.searchBar.resignFirstResponder()
                if let query = query{
                    self.viewModel.search(for: query)
                }
            }).disposed(by: disposeBag)
        
        //Bindings
//        viewModel.loaderVisible.bind{[weak self] shown in
//            DispatchQueue.main.async {
//                self?.loaderView.isHidden = !shown
//            }
//        }
//        viewModel.guideViewShown.bind{[weak self] shown in
//            DispatchQueue.main.async {
//                self?.guideView.isHidden = !shown
//            }
//        }
//        viewModel.errorLabelText.bind{[weak self] error in
//            DispatchQueue.main.async {
//                self?.errorLabel.text = error
//            }
//        }
//        viewModel.musicItems.bind{[weak self] items in
//            self?.musicItems = items
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
    }
    
    private func toggleGuideView(hidden: Bool){
        DispatchQueue.main.async {
            self.guideView.isHidden = hidden
        }
    }
    
//    private func search(for query: String){
//        let resource = Resource<SearchResultModel>(url: URL.with(query: query))
//        URLSession.load(resource: resource)
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext:{
//                if $0.results.isEmpty{
//                    self.toggleGuideView(hidden: false)
//                }
//                else{
//                    self.toggleGuideView(hidden: true)
//                }
//                self.viewModel = MusicListViewModel($0.results)
//                self.tableView.reloadData()
//            }).disposed(by: disposeBag)
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue"{
            if let vc = segue.destination as? MusicDetailViewController{
                vc.musicViewModel = self.selectedMusicModel
                //vc.musicItem = musicItems![selectedIndex]
            }
        }
    }

}


//MARK:- TableView Methods
extension MusicViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel == nil ? 0 : self.viewModel.musicVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath)
        
        let musicVM = self.viewModel.musicItem(at: indexPath.row)
        
        if let cell = cell as? MusicItemCell{
            musicVM.trackName.asDriver(onErrorJustReturn: "Error")
                .drive(cell.trackName.rx.text)
                .disposed(by: disposeBag)
            
            musicVM.trackSubtitle.asDriver(onErrorJustReturn: "Error")
                .drive(cell.trackSubtitle.rx.text)
            .disposed(by: disposeBag)
        
            musicVM.trackTimeString.asDriver(onErrorJustReturn: "Unknown")
                .drive(cell.trackDuration.rx.text)
            .disposed(by: disposeBag)
            
            musicVM.trackPrice.asDriver(onErrorJustReturn: "Unknown")
                .drive(cell.trackPrice.rx.text)
            .disposed(by: disposeBag)
            
            cell.trackImageLink = musicVM.trackImage
        }
        
        
//        guard let currentItem = musicItems?[indexPath.row],
//            let trackName = currentItem.trackCensoredName,
//            let genre = currentItem.primaryGenreName,
//            let artistName = currentItem.artistName,
//            let trackPrice = currentItem.trackPrice,
//            let trackImageString = currentItem.artworkUrl100,
//            let trackImageURL = URL(string: trackImageString)
//            else { return cell}
//        if let cell = cell as? MusicItemCell{
//            cell.trackName.text = trackName
//            cell.trackSubtitle.text = "\(genre) - \(artistName)"
//            cell.trackDuration.text = currentItem.trackTimeString
//            cell.trackPrice.text = "\(abs(trackPrice))"
//            cell.trackImageLink = trackImageURL
//        }
        return cell
    }
}

extension MusicViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.selectedMusicModel = self.viewModel.musicItem(at: selectedIndex)
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetailSegue", sender: self)
    }
}

extension MusicViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        return
        guard let txt = searchBar.text else {
                return
            }
        //viewModel.getSearchResultsFor(query: txt)
        searchBar.resignFirstResponder()
    }

}
