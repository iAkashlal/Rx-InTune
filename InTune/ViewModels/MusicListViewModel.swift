//
//  MusicListViewModel.swift
//  InTune
//
//  Created by Akashlal on 13/06/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//The main View Model for table list view
class MusicListViewModel{
    //To store the music items
    var musicVM : [MusicViewModel]
    
    var disposeBag = DisposeBag()
    
    //Variables to control state/value of views in viewController
    var toggleViewStatus = BehaviorRelay<Bool>.init(value: false)
    var errorLabelText = BehaviorRelay<String>.init(value: "")
    var loaderViewStatus = BehaviorRelay<Bool>.init(value: true)
    var tableViewReload = BehaviorRelay<Bool>.init(value: true)
    
    init(_ musicItems: [MusicItem]) {
        self.musicVM = musicItems.map{MusicViewModel($0)}
    }
}

extension MusicListViewModel{
    //Returns MusicViewModel at a particular index
    func musicItem(at index: Int) -> MusicViewModel{
        return musicVM[index]
    }
    
    //Used to query and get array of MusicViewModel for a particular query
    func search(for query: String){
        
        //If user search query is empty
        if query.isEmpty{
            self.errorLabelText.accept("")
            self.toggleViewStatus.accept(false)
            return
        }
        
        self.loaderViewStatus.accept(false)
        let resource = Resource<SearchResultModel>(url: URL.with(query: query))
        URLSession.load(resource: resource)
            .subscribe(onNext:{
                self.loaderViewStatus.accept(true)
                if $0.results.isEmpty{
                    self.errorLabelText.accept("No songs by that name :( Please rephrase?")
                    self.toggleViewStatus.accept(false)
                }
                else{
                    self.errorLabelText.accept("")
                    self.toggleViewStatus.accept(true)
                }
                //Get array of MusicViewModel
                self.musicVM = $0.results.map{MusicViewModel($0)}
                //Once we have new musicViewModel array, ask the viewcontroller to reload the table
                self.tableViewReload.accept(true)
            }).disposed(by: disposeBag)
        
    }
}
