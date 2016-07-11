//
//  ViewController.swift
//  WWDCast
//
//  Created by Maksym Shcheglov on 04/07/16.
//  Copyright © 2016 Maksym Shcheglov. All rights reserved.
//

import UIKit
import RxSwift

class SessionsSearchViewController: TableViewController<SessionViewModel, SessionTableViewCell> {
    var presenter: SessionsSearchPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        self.presenter.updateView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

//        self.navigationItem.rightBarButtonItems = UIBarButtonItem(customView: CastButton())
//        // Assign ourselves as delegate ONLY in viewWillAppear of a view controller.
//        CastDeviceController *controller = [CastDeviceController sharedInstance];
//        controller.delegate = self;
//
//        UIBarButtonItem *item = [controller queueItemForController:self];
//        self.navigationItem.rightBarButtonItems = @[item];

    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.presenter.selectItem(atIndex: indexPath.row)
    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

}

extension SessionsSearchViewController: SessionsSearchView {

    var showSessions: AnyObserver<[SessionViewModel]> {
        return AnyObserver {[unowned self] event in
            guard case .Next(let sessions) = event else {
                return
            }
            self.data = sessions
        }
    }

    func setTitle(title: String) {
        self.title = title
    }

}
