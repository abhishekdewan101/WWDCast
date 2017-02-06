//
//  ModuleFactory.swift
//  WWDCast
//
//  Created by Maksym Shcheglov on 06/07/16.
//  Copyright © 2016 Maksym Shcheglov. All rights reserved.
//

import UIKit

protocol WWDCastAssembly: class {
    // Creates UITabBarController with 2 controllers: SessionsSearchViewController & FavoriteSessionsViewController
    func tabBarController(delegate: SessionsSearchDelegate & FavoriteSessionsDelegate) -> UIViewController

    // Creates SessionDetailsViewController to show the details of the session with specified identifier
    func sessionDetailsController(_ sessionId: String) -> UIViewController

    // Creates FilterViewController to filter the search results
    func filterController(_ filter: Filter, completion: @escaping FilterModuleCompletion) -> UIViewController
}
