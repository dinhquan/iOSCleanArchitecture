//
//  MockLoader.swift
//  NewsAppTests
//
//  Created by Dinh Quan on 2/4/21.
//

import Foundation
import RxSwift

struct MockLoader {
    static func load<T: Decodable>(returnType: T.Type, file: String) -> Single<T> {
        return Single.create { single in
            if let path = Bundle.main.path(forResource: file, ofType: ""),
               let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let decoder = JSONDecoder()
                do {
                    let value = try decoder.decode(returnType, from: data)
                    single(.success(value))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
