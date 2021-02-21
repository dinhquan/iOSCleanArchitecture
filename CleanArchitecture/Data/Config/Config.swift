//
//  Config.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import Foundation

protocol EnvConfiguration {
    var baseUrl: String { get }
    var apiKey: String { get }
    var mockEnabled: Bool { get }
}

struct Config {
    // TODO: automatically environment switch by Bundle Id
    static let current = Dev()

    struct Dev: EnvConfiguration {
        let baseUrl = "http://newsapi.org/v2"
        let apiKey = "ff5445a21c1d44c4928c1c3f0e7ed0f6"
        let mockEnabled = false
    }

    struct Prod: EnvConfiguration {
        let baseUrl = "http://newsapi.org/v2"
        let apiKey = "ff5445a21c1d44c4928c1c3f0e7ed0f6"
        let mockEnabled = false
    }
}
