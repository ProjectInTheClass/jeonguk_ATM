//
//  optionsController.swift
//  전국 ATM 찾기
//
//  Created by 홍재우, 이지호, 윤진 on 12/02/2019.
//  Copyright © 2019 CAUADC. All rights reserved.
//

import UIKit

let bankList = ["모든 ATM 보기", "IBK기업은행", "KB국민은행", "KDB산업은행", "KEB하나은행", "MG새마을금고", "SC제일은행", "경남은행", "광주은행", "농협", "대구은행", "부산은행", "수협", "신한은행", "우리은행", "전북은행", "제주은행", "카카오뱅크", "케이뱅크", "한국씨티은행"]

class optionsController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
	
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bankList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bankText.text = bankList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bankList[row]
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    var bankPicker = UIPickerView()
    
    @IBOutlet weak var bankText: UITextField!
    @IBOutlet weak var sliderLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!

    @IBAction func sliderAction(_ sender: UISlider) {
        slider.value = roundf(sender.value)
        if slider.value == Float(11) {
            sliderLabel.text = "상관 없음"
        } else {
            sliderLabel.text = String(Int((slider.value)*100)) + "원"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        bankText.text = UserDefaults.standard.string(forKey: "bankName")
        
        bankPicker.delegate = self
        bankPicker.dataSource = self
        bankText.inputView = bankPicker
        
        let toolBar = UIToolbar()
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        toolBar.barTintColor = UIColor.lightGray
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "확인", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneTapped) )
        
        toolBar.setItems([space,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optionsController.viewTapped(gestureRecognizer:)))

        view.addGestureRecognizer(tapGesture)

        bankText.delegate = self
        bankText.returnKeyType = .done
        bankText.inputAccessoryView = toolBar
        
        let defaults = UserDefaults.standard
        
        if let newBank = defaults.string(forKey: "bankText"){
            bankText.text = newBank
        }
        
        if let newSlider = defaults.string(forKey: "sliderLevel") {
            if newSlider == "0" {
                sliderLabel.text = "0원"
            } else if newSlider == "11" {
                sliderLabel.text = "상관 없음"
            }
            else {
                sliderLabel.text = newSlider + "00원"
            }
        }
        
        slider.value = UserDefaults.standard.float(forKey: "sliderLevel")

        
    }
    
    
    
    
    
    
    
    
    
	//MARK: - IBActions
	
	@IBAction func CloseAction() {
		self.dismiss(animated: true, completion: nil)
        if (bankText.text?.count)! > 0 {
            _ = UserDefaults.standard.set(bankText.text!, forKey: "bankText")
        }
        UserDefaults.standard.set(slider.value, forKey: "sliderLevel")
        UserDefaults.standard.synchronize()
    }
    
    //뷰를 탭했을 때 피커뷰 창을 끄는 함수
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    //done을 누르면 피커뷰 창을 끄는 함수
    @objc func doneTapped() {
        view.endEditing(true)
    }
    
}



