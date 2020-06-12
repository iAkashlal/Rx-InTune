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
        
//         guard let trackName = musicItem.trackName,
//                    let trackCensoredName = musicItem.trackCensoredName,
//                    let artistName = musicItem.artistName,
//                    let genre = musicItem.primaryGenreName,
//                    let trackPrice = musicItem.trackPrice,
//                    let urlString = musicItem.artworkUrl100,
//                    let artworkURL = URL(string: urlString),
//                    let country = musicItem.country,
//                    let currency = musicItem.currency
//                    else {return}
//                // Do any additional setup after loading the view.
//                self.musicImage.sd_setImage(with: artworkURL, completed: nil)
//                self.songName.text = trackCensoredName
//        self.songDescription.text = "\nOriginally Titled: \(trackName)\n\nArtist: \(artistName)\n\nGenre: \(genre)\n\nDuration: \(musicItem.trackTimeString)\n\nReleased On: \(musicItem.releaseString)\n\nReleased in: \(country)\n\nPrice: \(currency) \(abs(trackPrice))"
    }
       

}
