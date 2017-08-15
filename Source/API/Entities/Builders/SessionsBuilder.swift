//
//  SessionsBuilder.swift
//  WWDCast
//
//  Created by Maksym Shcheglov on 05/07/16.
//  Copyright © 2016 Maksym Shcheglov. All rights reserved.
//

import Foundation
import SwiftyJSON

class SessionsBuilder: EntityBuilderType {

    typealias EntityType = [Session]

    static func build(_ json: JSON) throws -> EntityType {
        return try json["contents"].arrayValue.filter({ json -> Bool in
            return json["type"] == "Session" || json["type"] == "Video"
        }).map { sessionJSON in
            return try SessionBuilder.build(sessionJSON)
        }
    }

}
