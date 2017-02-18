//
//  FavoriteSessionsViewModel.swift
//  WWDCast
//
//  Created by Maksym Shcheglov on 21/10/2016.
//  Copyright © 2016 Maksym Shcheglov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FavoriteSessionsViewModelProtocol: class {
    // INPUT

    // Item selection observer
    func didSelect(item: SessionItemViewModel)

    // OUTPUT

    // The view's title
    var title: Driver<String> { get }
    // The title to show when there are no favorite sessions
    var emptyFavorites: Driver<EmptyDataSetViewModel> { get }
    // The array of available WWDC sessions divided into sections
    var favoriteSessions: Driver<[SessionSectionViewModel]> { get }
}

protocol FavoriteSessionsViewModelDelegate: class {

    /// Tells the delegate that viewModel would like to show the favorite session details
    func favoriteSessionsViewModel(_ viewModel: FavoriteSessionsViewModelProtocol, wantsToShowSessionDetailsWith sessionId: String)
}