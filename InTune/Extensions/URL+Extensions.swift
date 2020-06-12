//
//  URL+Extensions.swift
//  InTune
//
//  Created by Akashlal on 12/06/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import Foundation

extension URL{
    static func with(query: String) -> URL{
        let formattedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        return URL(string: "https://itunes.apple.com/search?term=\(formattedQuery)")!
    }
}
