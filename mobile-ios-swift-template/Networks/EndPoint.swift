//
//  EndPoint.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation


typealias HeaderValues = [String: String]?

enum EndPoint {
    case getUser(id: String)
    case login
    case logout
    var url: String {
        switch self {
        case let .getUser(id):
            return "/v1/api/user/\(id)"
        case .login: return "/v1/api/login"
        case .logout: return "/v1/api/logout"
        }
    }
}
