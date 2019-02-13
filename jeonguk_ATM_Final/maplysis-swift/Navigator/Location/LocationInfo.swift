//
//  LocationInfo.swift
//  전국 ATM 찾기
//
//  Created by 홍재우, 이지호, 윤진 on 12/02/2019.
//  Copyright © 2019 CAUADC. All rights reserved.
//

import UIKit
import MapKit

class LocationInfo: NSObject {
	
	static let sharedInstance = LocationInfo()
	var currentLocation: CLLocation?
	var address: String?
	
	func ConvertTouchesToLocation(touchPoint: CGPoint, sender: MKMapView) {
		let touchCoordinate = sender.convert(touchPoint, toCoordinateFrom: sender)
		currentLocation = CLLocation(latitude:touchCoordinate.latitude, longitude:touchCoordinate.longitude)
	}
}
