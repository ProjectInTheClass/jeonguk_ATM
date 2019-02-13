//
//  Annotator.swift
//  전국 ATM 찾기
//
//  Created by 홍재우, 이지호, 윤진 on 12/02/2019.
//  Copyright © 2019 CAUADC. All rights reserved.
//

import MapKit


class Annotator: NSObject {
    
    class func DisplayAnnotation(_ locationCoord:CLLocation, userSelected: Bool, sender: MKMapView) {
        let locAnnotation = MKPointAnnotation()
        locAnnotation.coordinate = locationCoord.coordinate
        
        if !userSelected {
            locAnnotation.title = "Current Location";
        }
        else {
            locAnnotation.title = "Selected Location";
        }
    }
}
