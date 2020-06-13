//
//  MusicViewModel.swift
//  InTune
//
//  Created by Akashlal on 12/06/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MusicViewModel{
    let musicItem: MusicItem
    
    init(_ musicItem: MusicItem) {
        self.musicItem = musicItem
    }
}

extension MusicViewModel{
    //To return various values used by the ViewControllers
    var trackName: Observable<String>{
        return Observable<String>.just(musicItem.trackName)
    }
    var trackSubtitle: Observable<String>{
        return Observable<String>.just("\(musicItem.primaryGenreName!) - \(musicItem.artistName!)")
    }
    
    var artistName: Observable<String>{
        return Observable<String>.just(musicItem.artistName)
    }
    var primaryGenreName: Observable<String>{
        return Observable<String>.just(musicItem.primaryGenreName)
    }
    var trackTimeString: Observable<String>{
        return Observable<String>.just(musicItem.trackTimeString)
    }
    var trackPrice: Observable<String>{
        return Observable<String>.just("\(abs(musicItem.trackPrice ?? 100.0))")
    }
    var artworkUrl100: Observable<String>{
        return Observable<String>.just(musicItem.artworkUrl100)
    }
    var trackImage: URL{
        return URL(string: musicItem.artworkUrl100) ?? URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music123/v4/39/50/b3/3950b304-580b-877c-c05b-1ba30a5a8239/source/100x100bb.jpg" )!
    }
    var kind: Observable<String>{
        return Observable<String>.just(musicItem.kind)
    }
    var trackDescription: Observable<String>{
        return Observable<String>.just("\nOriginally Titled: \(musicItem.trackCensoredName ?? "Name Unavailable")\n\nArtist: \(musicItem.artistName ?? "Unknown Artist")\n\nGenre: \(musicItem.primaryGenreName ?? "Unknown")\n\nDuration: \(musicItem.trackTimeString)\n\nReleased On: \(musicItem.releaseString)\n\nReleased in: \(musicItem.country ?? "Not Available")\n\nPrice: \(musicItem.country ?? "Not Available") \(abs(musicItem.trackPrice ?? 100.0))")
    }
}
