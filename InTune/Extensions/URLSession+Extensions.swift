//
//  URLSession+Extensions.swift
//  InTune
//
//  Created by Akashlal on 12/06/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable>{
    let url: URL
}

extension URLSession{
    static func load<T> (resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap { (url) -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
        }.map { (data) -> T in
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}
