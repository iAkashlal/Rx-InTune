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
    
    var disposeBag = DisposeBag()
    private var viewModel : MusicListViewModel = MusicListViewModel([MusicItem]())
    private var selectedMusicModel: MusicViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "InTune Music"
        
        //Binding various views to values from ViewModel
        viewModel.toggleViewStatus.asDriver()
            .drive(self.guideView.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.loaderViewStatus.asDriver()
            .drive(self.loaderView.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.errorLabelText.asDriver()
            .drive(self.errorLabel.rx.text)
            .disposed(by: disposeBag)
        //To ensure table is reloaded every time the value changes
        viewModel.tableViewReload.asDriver().drive(onNext: { _ in
            self.tableView.reloadData()
        })
        
        //Observing the searchbar so that api is called whenever user searches for something
        self.searchBar.rx
            .searchButtonClicked    //To ensure that search doesnt happen on every keystroke
            .map{self.searchBar.text}
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (query) in
                self.searchBar.resignFirstResponder()
                if let query = query{
                    self.viewModel.search(for: query)
                }
            }).disposed(by: disposeBag)
        
    }
    
    private func toggleGuideView(hidden: Bool){
        DispatchQueue.main.async {
            self.guideView.isHidden = hidden
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue"{
            if let vc = segue.destination as? MusicDetailViewController{
                vc.musicViewModel = self.selectedMusicModel
            }
        }
    }

}


//MARK:- TableView Methods
extension MusicViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.musicVM.count
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
        
        return cell
    }
}

extension MusicViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedMusicModel = self.viewModel.musicItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetailSegue", sender: self)
    }
}

