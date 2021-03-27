//
//  Protocols.swift
//  Social-Reality
//
//  Created by Nick Crews on 2/28/21.
//

import Foundation

protocol CoverToMainProtocolDelegate : AnyObject {
    func readyForSession()
}

protocol MainToCoverProtocolDelegate: AnyObject {
    func tappedComments()
}

protocol SearchUserDelegate: AnyObject {
    func selectUsers(models: [UserModel])
    func dismissSearchView()
}

protocol SearchLocationDelegate: AnyObject {
    func selectLocation(location: SearchLocation?)
    func dismissSearchLocationView()
}

protocol SearchMusicDelegate: AnyObject {
    func selectMusic()
    func dismissSearchMusicView()
}

protocol CreationCommentDelegate: AnyObject {
    func dismissCommentView()
}
