//
//  AppDefaults.swift
//  전국 ATM 찾기
//
//  Created by 홍재우, 이지호, 윤진 on 12/02/2019.
//  Copyright © 2019 CAUADC. All rights reserved.
//

protocol MapProperties {
	var continiousLocation: Bool { get set }
}

class AppDefaults {

	class func setDefaults() {

		let defaults = UserDefaults.standard

		if defaults.object(forKey: "ContiniousLocation") == nil {
			defaults.set(false, forKey: "ContiniousLocation")
		}

	}
}
