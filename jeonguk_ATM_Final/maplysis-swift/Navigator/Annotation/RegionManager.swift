//
//  RegionManager.swift
//  전국 ATM 찾기
//
//  Created by 홍재우, 이지호, 윤진 on 12/02/2019.
//  Copyright © 2019 CAUADC. All rights reserved.
//

import MapKit

class RegionManager: NSObject {
	
	class func DisplayRegion(locationRegion: CLLocation, sender: MKMapView) {
		let _zoomLevel = UserDefaults.standard.double(forKey: "MapZoomLevel")
		let region = MKCoordinateRegion.init(center: locationRegion.coordinate, latitudinalMeters: _zoomLevel, longitudinalMeters: _zoomLevel)
		
		sender.setRegion(sender.regionThatFits(region), animated: true)
	}
}
