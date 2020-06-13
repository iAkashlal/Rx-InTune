//
//  MusicDetailViewController.swift
//  InTune
//
//  Created by Akashlal on 29/03/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class MusicDetailViewController: UITableViewController {
    
    var musicItem : MusicItem!
    var musicViewModel: MusicViewModel!
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        
        self.musicImage.sd_setImage(with: musicViewModel.trackImage, completed: nil)
        self.musicViewModel.trackName.asDriver(onErrorJustReturn: "Unknown")
            .drive(self.songName.rx.text)
            .disposed(by: disposeBag)
        self.musicViewModel.trackDescription.asDriver(onErrorJustReturn: "Description not found")
            .drive(self.songDescription.rx.text)
            .disposed(by: disposeBag)
        
    }
       

}
