//
//  RxExtensions.swift
//  WWDCast
//
//  Created by Maksym Shcheglov on 05/07/16.
//  Copyright © 2016 Maksym Shcheglov. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SDWebImage

// One way binding operator

infix operator <~ {
}

func <~ <T>(property: AnyObserver<T>, variable: Variable<T>) -> Disposable {
    return variable.asObservable()
        .bindTo(property)
}

infix operator ~> {
}

func ~> <T>(variable: Variable<T>, property: AnyObserver<T>) -> Disposable {
    return variable.asObservable()
        .bindTo(property)
}

func rx_request(method: Alamofire.Method, _ URLString: URLStringConvertible) -> Observable<AnyObject> {
    return Observable<AnyObject>.create({ (observer) -> Disposable in
        let request = Alamofire.request(method, URLString)
            .responseJSON(completionHandler: { (firedResponse) -> Void in
                if let value = firedResponse.result.value {
                    observer.onNext(value)
                    observer.onCompleted()
                } else if let error = firedResponse.result.error {
                    observer.onError(error)
                }
            })
        return AnonymousDisposable {
            request.cancel()
        }
    })
}


extension UIImageView {
    var rx_imageURL: AnyObserver<NSURL> {
        return AnyObserver { [weak self] event in
            switch event {
            case .Next(let value):
                self?.image = nil
                self?.sd_setImageWithURL(value, completed: { [weak self] _ in
                    let transition = CATransition()
                    transition.duration = 0.3
                    transition.timingFunction =
                        CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    self?.layer.addAnimation(transition, forKey: kCATransition)
                    })
            default:
                break
            }
            
        }
    }
}

extension UIAlertController {
    enum Selection {
        case Action(UInt), Cancel
    }
    
    static func promptFor<Action : CustomStringConvertible>(title: String?, message: String?, style: UIAlertControllerStyle, cancelAction: Action, actions: [Action]) -> UIViewController -> Observable<Action> {
        return { viewController in
            return Observable.create { observer in
                let alertView = UIAlertController(title: title, message: message, preferredStyle: style)
                alertView.addAction(UIAlertAction(title: cancelAction.description, style: .Cancel) { _ in
                    observer.onNext(cancelAction)
                })
                
                for action in actions {
                    alertView.addAction(UIAlertAction(title: action.description, style: .Default) { _ in
                        observer.onNext(action)
                    })
                }
                
                viewController.presentViewController(alertView, animated: true, completion: nil)
                
                return AnonymousDisposable {
                    alertView.dismissViewControllerAnimated(false, completion: nil)
                }
            }
        }
    }
}

//extension ObservableType where E: SequenceType {
//    /**
//     Projects each element of an observable sequence into a new form.
//
//     - seealso: [map operator on reactivex.io](http://reactivex.io/documentation/operators/map.html)
//
//     - parameter selector: A transform function to apply to each source element.
//     - returns: An observable sequence whose elements are the result of invoking the transform function on each element of source.
//
//     */
//    @warn_unused_result(message="http://git.io/rxs.uo")
//    public func mapSequence<R: SequenceType where R.Generator.Element == AnyObject>(selector: Self.E.Generator.Element throws -> R.Generator.Element) -> RxSwift.Observable<R> {
//        return self.map({ sequence in
//            return try selector(sequence.generate().next()!) //sequence.map() { element in
//            //                return try selector(element)
//            //            }
//        })
//    }
//}
