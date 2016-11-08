//
//  SessionsSearchViewModelImpl.swift
//  WWDCast
//
//  Created by Maksym Shcheglov on 04/07/16.
//  Copyright © 2016 Maksym Shcheglov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SessionsSearchViewModelImpl: SessionsSearchViewModel {
    private let api: WWDCastAPI
    private let router: SessionsSearchRouter
    private let filter = Variable(Filter())
    private let disposeBag = DisposeBag()
    private let activityIndicator = ActivityIndicator()

    init(api: WWDCastAPI, router: SessionsSearchRouter) {
        self.api = api
        self.router = router
    }
    
    private func applyFilter(_ sessions: [Session], filter: Filter) -> [Session] {
        return sessions.apply(filter)
    }
    
    // MARK: SessionsSearchViewModel
    
    lazy var sessionSections: Driver<[SessionSectionViewModel]> = {
        let sessionsObservable = self.api.sessions //.trackActivity(self.activityIndicator)
        return Observable.combineLatest(sessionsObservable, self.filter.asObservable(), resultSelector: self.applyFilter)
            .map(SessionItemViewModelBuilder.build)
            .asDriver(onErrorJustReturn: [])
    }()
    
    var isLoading: Driver<Bool> {
        return self.activityIndicator.asDriver()
    }
    
    let title = Driver.just(NSLocalizedString("WWDCast", comment: "Session search view title"))

    func itemSelectionObserver(_ viewModel: SessionItemViewModel) {
        self.router.showSessionDetails(viewModel.uniqueID)
    }
    
    func filterObserver() {
        self.router.showFilterController(withFilter: self.filter.value) {[unowned self] filter in
            self.filter.value = filter
        }
    }
    
    func searchStringObserver(_ query: String) {
        var filter = self.filter.value
        filter.query = query
        self.filter.value = filter
    }
    
}
