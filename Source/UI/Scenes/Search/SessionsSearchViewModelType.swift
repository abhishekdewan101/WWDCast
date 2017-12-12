//
//  SessionsSearchViewModel.swift
//  WWDCast
//
//  Created by Maksym Shcheglov on 04/07/16.
//  Copyright © 2016 Maksym Shcheglov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SessionsSearchViewModelType: class {

    // INPUT
    // Item selection observer
    func didSelect(item: SessionItemViewModel)
    // Filter button tap observer
    func didTapFilter()
    // Search string observer
    func didStartSearch(withQuery query: String)

    // OUTPUT
    // Defines whether or not there are any ongoing network operation
    var isLoading: Driver<Bool> { get }
    // The array of available WWDC sessions divided into sections
    var sessionSections: Driver<[SessionSectionViewModel]> { get }
}

protocol SessionsSearchViewModelDelegate: class {
    func sessionsSearchViewModel(_ viewModel: SessionsSearchViewModelType, wantsToShow filter: Filter, completion: @escaping (Filter) -> Void)
    func sessionsSearchViewModel(_ viewModel: SessionsSearchViewModelType, wantsToShowSessionDetailsWith sessionId: String)
}
