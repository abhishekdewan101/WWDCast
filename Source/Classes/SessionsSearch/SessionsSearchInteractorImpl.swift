//
//  SessionsSearchInteractorImpl.swift
//  WWDCast
//
//  Created by Maksym Shcheglov on 04/07/16.
//  Copyright © 2016 Maksym Shcheglov. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class SessionsSearchInteractorImpl {
    weak var presenter: SessionsSearchPresenter!
    private let serviceProvider: ServiceProvider

    init(presenter: SessionsSearchPresenter, serviceProvider: ServiceProvider) {
        self.presenter = presenter
        self.serviceProvider = serviceProvider
    }
}

extension SessionsSearchInteractorImpl: SessionsSearchInteractor {

    func loadSessions() -> Observable<[Session]> {
        return loadConfig().flatMapLatest(self.loadSessions)
            .subscribeOn(self.serviceProvider.scheduler.backgroundWorkScheduler)
            .observeOn(self.serviceProvider.scheduler.mainScheduler)
            .shareReplayLatestWhileConnected()
    }

    var playSession: AnyObserver<Session> {
        return self.serviceProvider.googleCast.playSession
    }

    // MARK: Private

    private func loadConfig() -> Observable<AppConfig> {
        return loadData(WWDCEnvironment.indexURL, builder: AppConfigBuilder.self)
    }

    private func loadSessions(config: AppConfig) -> Observable<[Session]> {
        return loadData(config.videosURL, builder: SessionsBuilder.self)
    }

    private func loadData<Builder: EntityBuilder>(url: NSURL, builder: Builder.Type) -> Observable<Builder.EntityType> {
        return self.serviceProvider.network.GET(url, parameters: [:]).map() { data in
            print(JSON(data: data))
            return builder.build(JSON(data: data))
        }
    }

}
