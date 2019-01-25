//
//  ProfileViewModel.swift
//  RxGithub
//
//  Created by Oron Ben Zvi on 2/21/17.
//  Copyright © 2017 Oron Ben Zvi. All rights reserved.
//

import RxSwift

protocol ProfileViewModeling {

    // MARK: - Input
    var showCommentsDidTap: PublishSubject<Void> { get }
    var profile: GitHubUser { get }

    // MARK: - Output
    var image: Observable<UIImage> { get }
    var username: String { get }
    var showComments: Observable<CommentsViewModeling> { get }
}

class ProfileViewModel: ProfileViewModeling {

    // MARK: - Input
    let showCommentsDidTap: PublishSubject<Void> = PublishSubject<Void>()
    var profile: GitHubUser

    // MARK: - Output
    var username: String
    var image: Observable<UIImage>
    var showComments: Observable<CommentsViewModeling>

    init(network: Networking, profile: GitHubUser, commentService: CommentServicing) {
        let placeholder = #imageLiteral(resourceName: "user2")

        self.profile = profile
        self.username = profile.username

        image = Observable.just(placeholder)
                .concat(network.image(url: self.profile.avatarUrl))
                .observeOn(MainScheduler.instance)
                .catchErrorJustReturn(placeholder)

        showComments = showCommentsDidTap.map {
            CommentsViewModel(
                    commentsService: commentService,
                    username: profile.username
            )
        }
    }
}