//
//  Default.swift
//  CleanArchitecture
//
//  Created by Quan on 2/22/21.
//

import Foundation

protocol DefaultSource {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

enum Default {}

extension Default {
    @propertyWrapper
    struct Wrapper<Source: DefaultSource> {
        typealias Value = Source.Value
        var wrappedValue = Source.defaultValue
    }
}

extension Default.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Value.self)
    }
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: Default.Wrapper<T>.Type,
                   forKey key: Key) throws -> Default.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

extension Default {
    typealias Source = DefaultSource
    typealias List = Decodable & ExpressibleByArrayLiteral
    typealias Map = Decodable & ExpressibleByDictionaryLiteral

    enum Sources {
        enum True: Source {
            static var defaultValue: Bool { true }
        }

        enum False: Source {
            static var defaultValue: Bool { false }
        }

        enum Zero: Source {
            static var defaultValue: Int { 0 }
        }
        
        enum ZeroDouble: Source {
            static var defaultValue: Double { 0.0 }
        }

        enum Empty: Source {
            static var defaultValue: String { "" }
        }

        enum EmptyList<T: List>: Source {
            static var defaultValue: T { [] }
        }

        enum EmptyMap<T: Map>: Source {
            static var defaultValue: T { [:] }
        }
    }
}

extension Default {
    typealias True = Wrapper<Sources.True>
    typealias False = Wrapper<Sources.False>
    typealias Zero = Wrapper<Sources.Zero>
    typealias ZeroDouble = Wrapper<Sources.ZeroDouble>
    typealias Empty = Wrapper<Sources.Empty>
    typealias EmptyList<T: List> = Wrapper<Sources.EmptyList<T>>
    typealias EmptyMap<T: Map> = Wrapper<Sources.EmptyMap<T>>
}

extension Default.Wrapper: Equatable where Value: Equatable {}
extension Default.Wrapper: Hashable where Value: Hashable {}

extension Default.Wrapper: Encodable where Value: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
