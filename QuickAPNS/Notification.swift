//
//  Notification.swift
//  QuickAPNS
//
//  Created by Xavier on 2024-07-15.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct Notification: Codable {
    var bundle: String
    var title: String
    var subtitle: String?
    var body: String

    enum CodingKeys: String, CodingKey {
        case aps
        case bundle = "Simulator Target Bundle"
    }

    enum ApsKeys: String, CodingKey {
        case alert
//        case badge
    }
    
    enum AlertKeys: String, CodingKey {
        case title
        case subtitle
        case body
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var apsContainer = container.nestedContainer(keyedBy: ApsKeys.self, forKey: .aps)
        var alertContainer = apsContainer.nestedContainer(keyedBy: AlertKeys.self, forKey: .alert)

        try container.encode(bundle, forKey: .bundle)
        try alertContainer.encode(title, forKey: .title)
        try alertContainer.encodeIfPresent(subtitle, forKey: .subtitle)
        try alertContainer.encode(body, forKey: .body)
//        try apsContainer.encode(5, forKey: .badge)
    }

    init(bundle: String, title: String, subtitle: String? = nil, body: String) {
        self.bundle = bundle
        self.title = title
        self.subtitle = subtitle
        self.body = body
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let apsContainer = try container.nestedContainer(keyedBy: ApsKeys.self, forKey: .aps)
        let alertContainer = try apsContainer.nestedContainer(keyedBy: AlertKeys.self, forKey: .alert)

        self.bundle = try container.decode(String.self, forKey: .bundle)
        self.title = try alertContainer.decode(String.self, forKey: .title)
        self.subtitle = try alertContainer.decodeIfPresent(String.self, forKey: .subtitle)
        self.body = try alertContainer.decode(String.self, forKey: .body)
    }
}

extension Notification: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .fileURL) { notification in
            let json = try! JSONEncoder().encode(notification)
            let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent("notification.apns")
            try json.write(to: tempUrl)
            return tempUrl.dataRepresentation
        }
    }
}
