//
//  CommentModel.swift
//  Social-Reality
//
//  Created by Nick Crews on 3/18/21.
//

import Foundation
import Firebase
import CodableFirebase

struct CommentModel: Codable {
    
    public let id: String
    public var content: String
    public var status: String?
    public var creationID: String?
    public var userID: String?
    public var userImage: String?
    public var userName: String?
    
}