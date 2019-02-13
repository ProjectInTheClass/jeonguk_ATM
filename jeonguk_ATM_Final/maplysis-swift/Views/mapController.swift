//
//  mapController.swift
//  전국 ATM 찾기
//
//  Created by 홍재우, 이지호, 윤진 on 12/02/2019.
//  Copyright © 2019 CAUADC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let date = Date()
let calendar = Calendar.current
let components = calendar.dateComponents([.hour], from: date)

class mapController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
	
	@IBOutlet var locationButton: UIButton!
	@IBOutlet var mapView: MKMapView!
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
 
    
    var li: LocationInfo!
	var lc: LocationController!
    var locationManager = CLLocationManager()
    var bank: String?
    var fee: Float?
    
    // class Bank를 상속받은 값들을 요소로 갖는 배열 locations를 정의
    
    var locations = [Bank]()
    
    // 각 은행의 마커 정보를 담을 array를 각각 정의
    
    var marksKB국민은행:[MKPointAnnotation] = []
    var marks신한은행:[MKPointAnnotation] = []
    var marksIBK기업은행:[MKPointAnnotation] = []
    var marksKEB하나은행:[MKPointAnnotation] = []
    var marksSC제일은행:[MKPointAnnotation] = []
    var marks우리은행:[MKPointAnnotation] = []
    var marks농협:[MKPointAnnotation] = []
    var marks우체국:[MKPointAnnotation] = []
    var marks한국씨티은행:[MKPointAnnotation] = []
    var marksMG새마을금고:[MKPointAnnotation] = []
    var marks신협:[MKPointAnnotation] = []
    var marks수협:[MKPointAnnotation] = []
    var marksKDB산업은행:[MKPointAnnotation] = []
    var marks경남은행:[MKPointAnnotation] = []
    var marks광주은행:[MKPointAnnotation] = []
    var marks대구은행:[MKPointAnnotation] = []
    var marks부산은행:[MKPointAnnotation] = []
    var marks산림조합:[MKPointAnnotation] = []
    var marks전북은행:[MKPointAnnotation] = []
    var marks제주은행:[MKPointAnnotation] = []
    var marksCU:[MKPointAnnotation] = []
    var marksGS입출금:[MKPointAnnotation] = []
    var marksGS출금:[MKPointAnnotation] = []
    var markslotteATM입출금:[MKPointAnnotation] = []
    var markslotteATM출금:[MKPointAnnotation] = []
    var marksNICE:[MKPointAnnotation] = []
    
    var marksALL:[MKPointAnnotation] = []
    
    override func viewDidLoad() {
		
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DisplayLocation), name: Notification.Name("UpdateLocation"), object: nil)
		super.viewDidLoad()
        
        mapView.delegate = self as? MKMapViewDelegate
    
        
        li = LocationInfo.sharedInstance
        lc = LocationController.sharedInstance
        lc.senderVC = self
        lc.LocationPermissions()

        self.navigationController?.navigationBar.topItem?.title = "전국 ATM 찾기"
        
		locationButton.layer.cornerRadius = locationButton.bounds.size.width / 2
        
        setCurrentLocation()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        // json 파일에서 정보 추출
        
        let path = Bundle.main.path(forResource: "ATM_Info", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        do {
            let data = try Data(contentsOf: url)
            locations = try JSONDecoder().decode([Bank].self, from: data)
        } catch let err {
            print(err)
        }
        
        // locations라는 Bank의 값들을 갖는 모든 array들에 대해서 반복
        // anontation이라는 것은 마커의 성질을 갖는 MKPointAnnotation()으로 정의
        // 그 마커의 title과 subtitle을 json에서 불러온 값들로 할당
        
        for l in locations {
            let annotation = CustomMarker()
            let latitude = Double(l.lat)
            let longitude = Double(l.long)
            annotation.coordinate = CLLocationCoordinate2DMake(latitude ?? 0.0, longitude ?? 0.0)
            annotation.title = l.name
            annotation.subtitle = l.add
            marksALL.append(annotation)
        // annotation이라는 마커의 정보를 갖는 array들을 조건에 맞게 할당
        // json에서 bank의 이름이 각자 OO이면 위에서 생성된 마커들이 그에 맞는 array로 배열
            
            if l.bank == "산업은행" { annotation.image = UIImage(named: "산업"); marksKDB산업은행.append(annotation) }
            else if l.bank == "농협은행" { annotation.image = UIImage(named: "농협"); marks농협.append(annotation) }
            else if l.bank == "신한은행" { annotation.image = UIImage(named: "신한"); marks신한은행.append(annotation) }
            else if l.bank == "SC제일은행" { annotation.image = UIImage(named: "제일"); marksSC제일은행.append(annotation) }
            else if l.bank == "KEB하나은행" { annotation.image = UIImage(named: "하나"); marksKEB하나은행.append(annotation) }
            else if l.bank == "기업은행" { annotation.image = UIImage(named: "기업"); marksIBK기업은행.append(annotation)}
            else if l.bank == "한국씨티은행" { annotation.image = UIImage(named: "씨티"); marks한국씨티은행.append(annotation) }
            else if l.bank == "수협은행" { annotation.image = UIImage(named: "수협"); marks수협.append(annotation) }
            else if l.bank == "대구은행" { annotation.image = UIImage(named: "대구"); marks대구은행.append(annotation) }
            else if l.bank == "부산은행" { annotation.image = UIImage(named: "부산경남"); marks부산은행.append(annotation) }
            else if l.bank == "광주은행" { annotation.image = UIImage(named: "french-fries"); marks광주은행.append(annotation) }
            else if l.bank == "제주은행" { annotation.image = UIImage(named: "신한"); marks제주은행.append(annotation)}
            else if l.bank == "전북은행" { annotation.image = UIImage(named: "전북"); marks전북은행.append(annotation) }
            else if l.bank == "경남은행" { annotation.image = UIImage(named: "부산경남"); marks경남은행.append(annotation) }
            else if l.bank == "우리은행" { annotation.image = UIImage(named: "우리"); marks우리은행.append(annotation)}
            else if l.bank == "CU 출금" { annotation.image = UIImage(named: "cu"); marksCU.append(annotation)}
            else if l.bank == "GS출금" { annotation.image = UIImage(named: "gs"); marksGS출금.append(annotation) }
            else if l.bank == "GS입출금" { annotation.image = UIImage(named: "gs"); marksGS입출금.append(annotation)}
            else if l.bank == "lotteATM입출금" { annotation.image = UIImage(named: "lotte"); markslotteATM입출금.append(annotation)}
            else if l.bank == "lotteATM출금" { annotation.image = UIImage(named: "lotte"); markslotteATM출금.append(annotation) }
            else if l.bank == "NICE" { annotation.image = UIImage(named: "NICE"); marksNICE.append(annotation)}
        }
        
    }
    
        func mapView(_ mapView: MKMapView, viewFor anontation: MKAnnotation) -> MKAnnotationView? {
            guard !anontation.isKind(of: MKUserLocation.self) else { return nil }
            let anontationIdentifier = "AnontationIdentifier"
            var anontationView = mapView.dequeueReusableAnnotationView(withIdentifier: anontationIdentifier)
    
            if(anontationView == nil) {
                anontationView = MKAnnotationView(annotation: anontation, reuseIdentifier: anontationIdentifier)
                anontationView!.canShowCallout = true
            }
            else {
                anontationView!.annotation = anontation
            }
    
            let customPointAnontation = anontation as! CustomMarker
            anontationView!.image = customPointAnontation.image
            return anontationView
        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    func setCurrentLocation() {
        
        mapView.showsUserLocation = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined {
                
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print(" Please turn on your location services")
        }
    }
    
    // CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(locations[0].coordinate.latitude, locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(" Failed : Unable to access your current location.")
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(true)
        bank = UserDefaults.standard.string(forKey: "bankText")
        fee = UserDefaults.standard.float(forKey: "sliderLevel")
        if let bankType = bank {
            if let bankFee = fee {
                if let hour = components.hour {
                    if bankType == "모든 ATM 보기" {
                        mapView.addAnnotations(marksALL)
                    } else if bankType == "케이뱅크" {
                        if bankFee <= 6.0 {
                            mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                        } else {
                            mapView.addAnnotations(marksALL)
                        }
                    } else if bankType == "KB국민은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 6.0 : mapView.removeAnnotations(marksALL);mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금); mapView.addAnnotations(markslotteATM출금); mapView.addAnnotations(markslotteATM입출금)
                            case 7.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                        } else {
                            switch bankFee {
                            case 0.0 ... 4.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 5.0 ... 9.0 : mapView.removeAnnotations(marksALL);mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금); mapView.addAnnotations(markslotteATM출금); mapView.addAnnotations(markslotteATM입출금)
                            case 10.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    } else if bankType == "우리은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 6.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            case 7.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            default : mapView.addAnnotations(marksALL)
                            }

                        } else {
                            switch bankFee {
                            case 0.0 ... 4.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 5.0 ... 9.0 : mapView.removeAnnotations((mapView?.annotations)!); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            case 10.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    } else if bankType == "하나은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 6.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marksKEB하나은행)
                            case 7.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 4.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 5.0 ... 8.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marksKEB하나은행)
                            case 9.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    } else if bankType == "신한은행" || bankType == "제주은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 6.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            case 7.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            default : mapView.addAnnotations(marksALL)
                            }
                        } else {
                            switch bankFee {
                            case 0.0 ... 4.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 5.0 ... 8.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            case 9.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }
                    else if bankType == "경남은행" || bankType == "부산은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 7.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(markslotteATM입출금); mapView.addAnnotations(markslotteATM출금)
                            case 8.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(markslotteATM입출금); mapView.addAnnotations(markslotteATM출금)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 5.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 6.0 ... 9.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(markslotteATM입출금); mapView.addAnnotations(markslotteATM출금)
                            case 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(markslotteATM입출금); mapView.addAnnotations(markslotteATM출금)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }
                    else if bankType == "수협" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 7.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks수협)
                            case 8.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 5.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 6.0 ... 9.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks수협)
                            case 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }
                    else if bankType == "전북은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 7.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks전북은행)
                            case 8.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 5.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 6.0 ... 9.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks전북은행)
                            case 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }
                    else if bankType == "대구은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 7.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행)
                            case 8.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(markslotteATM입출금); mapView.addAnnotations(markslotteATM출금)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 4.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 5.0 ... 9.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행)
                            case 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }
                    else if bankType == "농협" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 7.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks농협)
                            case 8.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 4.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 5.0 ... 9.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks농협)
                            case 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }
                    else if bankType == "광주은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 8.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            case 9.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 5.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 6.0 ... 9.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            case 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(marksGS입출금); mapView.addAnnotations(marksGS출금)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }
                    else if bankType == "SC제일은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 8.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marksSC제일은행)
                            case 9.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 5.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 6.0 ... 9.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marksSC제일은행)
                            case 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }

                    else if bankType == "IBK기업은행" {
                        if hour <= 18 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 6.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marksIBK기업은행)
                            case 7.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 8.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marksIBK기업은행)
                            case 9.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }
                    else if bankType == "KDB산업은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 5.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marksKDB산업은행)
                            case 6.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 7.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marksKDB산업은행)
                            case 8.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }
                    else if bankType == "KEB하나은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 6.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marksKEB하나은행)
                            case 7.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 4.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 5.0 ... 8.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marksKEB하나은행)
                            case 9.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }
                    else if bankType == "한국씨티은행" {
                        if hour <= 16 && hour >= 9 {
                            switch bankFee {
                            case 0.0 ... 8.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(markslotteATM입출금); mapView.addAnnotations(markslotteATM출금)
                            case 9.0 ... 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(markslotteATM입출금); mapView.addAnnotations(markslotteATM출금)
                            default : mapView.addAnnotations(marksALL)
                            }
                            
                        } else {
                            switch bankFee {
                            case 0.0 ... 5.0 : mapView.removeAnnotations((mapView?.annotations)!)
                            case 6.0 ... 9.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(markslotteATM입출금); mapView.addAnnotations(markslotteATM출금)
                            case 10.0 : mapView.removeAnnotations(marksALL); mapView.addAnnotations(marks대구은행); mapView.addAnnotations(marks광주은행); mapView.addAnnotations(marks농협); mapView.addAnnotations(marks수협); mapView.addAnnotations(marks신협); mapView.addAnnotations(marks우체국); mapView.addAnnotations(marks경남은행); mapView.addAnnotations(marks부산은행); mapView.addAnnotations(marksIBK기업은행); mapView.addAnnotations(marksKEB하나은행); mapView.addAnnotations(marksSC제일은행); mapView.addAnnotations(marks우리은행); mapView.addAnnotations(marks한국씨티은행); mapView.addAnnotations(marksMG새마을금고); mapView.addAnnotations(marksKDB산업은행); mapView.addAnnotations(marksKB국민은행); mapView.addAnnotations(marks제주은행); mapView.addAnnotations(marks신한은행); mapView.addAnnotations(marks산림조합); mapView.addAnnotations(marks전북은행); mapView.addAnnotations(markslotteATM입출금); mapView.addAnnotations(markslotteATM출금)
                            default : mapView.addAnnotations(marksALL)
                            }
                        }
                    }
                }
            }
        }
    }
    
	override func viewWillDisappear(_ animated: Bool) {
		lc.StopLocationUpdates(sender: self)
		super.viewWillDisappear(true)
	}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
	
	@IBAction func GetCurrentLocation(_ sender: Any) {
		let _cLocationUpdates = UserDefaults.standard.bool(forKey: "ContiniousLocation")
		
		if !_cLocationUpdates {
			lc.GetCurrentLocation(sender: self)
		}
		else {
			if lc.isUpdating {
				lc.StopLocationUpdates(sender: self)
				locationButton?.tintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
			}
			else {
				lc.StartLocationUpdates(sender: self)
				locationButton?.tintColor = UIColor .green
			}
		}
	}
	

	//MARK: - Location Display

	@objc func DisplayLocation() {
		
		RegionManager.DisplayRegion(locationRegion: li.currentLocation!, sender: mapView!)
		
		let _cLocationUpdates = UserDefaults.standard.bool(forKey: "ContiniousLocation")
		
		if !_cLocationUpdates {
			Annotator.DisplayAnnotation(li.currentLocation!, userSelected: false, sender: mapView!)
		}
	}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion.init(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
}
