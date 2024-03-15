//
//  Comment.swift
//  BeReal
//
//  Created by Mina on 3/12/24.
//

import Foundation
import ParseSwift

struct Comment: ParseObject {
    
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    var username: String?
    var comment: String?
    var postObjectId: String?

}
