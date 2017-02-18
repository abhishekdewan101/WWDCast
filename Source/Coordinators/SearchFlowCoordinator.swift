//
//  SearchFlowCoordinator.swift
//  WWDCast
//
//  Created by Maksym Shcheglov on 18/02/2017.
//  Copyright © 2017 Maksym Shcheglov. All rights reserved.
//

import UIKit

/// The `SearchFlowCoordinator` takes control over the flows on the search screen
class SearchFlowCoordinator: FlowCoordinator {
    fileprivate let rootController: UINavigationController
    fileprivate let factory: ViewControllerFactoryProtocol

    init(rootController: UINavigationController, factory: ViewControllerFactoryProtocol) {
        self.rootController = rootController
        self.factory = factory
    }

    func start() {
        let searchController = self.factory.sessionsSearchController(delegate: self, previewProvider: self)
        self.rootController.setViewControllers([searchController], animated: false)
    }

}

extension SearchFlowCoordinator: TableViewControllerPreviewProvider {

    func previewController<Item>(forItem item: Item) -> UIViewController? {
        guard let item = item as? SessionItemViewModel else {
            return nil
        }
        return self.factory.sessionDetailsController(item.uniqueID)
    }

}

extension SearchFlowCoordinator: SessionsSearchViewModelDelegate {

    func sessionsSearchViewModel(_ viewModel: SessionsSearchViewModelProtocol, wantsToShow filter: Filter, completion: @escaping (Filter) -> Void) {
        let controller = self.factory.filterController(filter) {[unowned self] result in
            self.rootController.dismiss(animated: true, completion: {
                guard case .finished(let filter) = result else {
                    return
                }
                completion(filter)
            })
        }
        self.rootController.present(controller, animated: true, completion: nil)
    }

    func sessionsSearchViewModel(_ viewModel: SessionsSearchViewModelProtocol, wantsToShowSessionDetailsWith sessionId: String) {
        let controller = self.factory.sessionDetailsController(sessionId)
        self.rootController.pushViewController(controller, animated: true)
    }

}
