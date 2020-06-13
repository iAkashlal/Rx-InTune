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

class MusicListViewModel{
    var musicVM : [MusicViewModel]
    
    var disposeBag = DisposeBag()
    
    var toggleViewStatus = BehaviorRelay<Bool>.init(value: false)
    var errorLabelText = BehaviorRelay<String>.init(value: "")
    var loaderViewStatus = BehaviorRelay<Bool>.init(value: true)
    var tableViewReload = BehaviorRelay<Bool>.init(value: true)
    
    init(_ musicItems: [MusicItem]) {
        self.musicVM = musicItems.map{MusicViewModel($0)}
    }
}

//extension MusicListViewModel{
//    init(_ musicItems: [MusicItem]) {
//        self.musicVM = musicItems.map{MusicViewModel($0)}
//    }
//}

extension MusicListViewModel{
    func musicItem(at index: Int) -> MusicViewModel{
        return musicVM[index]
    }
    
    func search(for query: String){
        
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
                self.musicVM = $0.results.map{MusicViewModel($0)}
                self.tableViewReload.accept(true)
            }).disposed(by: disposeBag)
        
    }
}
