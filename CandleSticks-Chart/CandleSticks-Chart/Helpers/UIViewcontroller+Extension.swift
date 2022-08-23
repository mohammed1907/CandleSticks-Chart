//
//  UIViewcontroller+Extension.swift
//  CandleSticks-Chart
//
//  Created by Omar Hassanein on 21/08/2022.
//

import UIKit
import FirebaseAnalytics
extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

extension Encodable {

    var dict : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
}
func LogEventByFBAnalytics(name: String, contentType: String){  //Log to Firebase analytics
    Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
        AnalyticsParameterItemName: name,
        AnalyticsParameterContentType: contentType])
}
