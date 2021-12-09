//
//  TopicChild1ViewController.swift
//  TotalTopic
//
//  Created by 陳庭楷 on 2021/11/26.
//

import UIKit

class TopicChild1ViewController: UIViewController {
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    @IBOutlet weak var nameTxt: UITextField!
    
    var topic1VC: Topic1ViewController?
    
    var myTime = TimeMenu()
    
    var index: Int?
    
    var nowDate: Date?
    
    var nowStr: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.nowDate = self.myTime.date
        
        self.nowStr = self.myTime.name
        
        self.nameTxt.text = self.myTime.name
        
        self.nameTxt.delegate = self
        
        self.myDatePicker.datePickerMode = .dateAndTime
        
        if #available(iOS 13.4, *) {
            
            self.myDatePicker.preferredDatePickerStyle = .wheels
            
        }
        
        self.myDatePicker.date = self.myTime.date!
        
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        self.myDatePicker.minimumDate = Date()

        let endDateTime = formatter.date(from: "2022-01-01 00:00")

        self.myDatePicker.maximumDate = endDateTime

        self.myDatePicker.locale = Locale(identifier: "zh_TW")
        
        self.myDatePicker.addTarget(self,action:#selector(TopicChild1ViewController.datePickerChanged),for: .valueChanged)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           
        self.view.endEditing(true)
           
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker) {
        
        self.nowDate = datePicker.date
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        self.myTime.date = self.nowDate
        
        self.myTime.name = self.nowStr
        
        self.topic1VC?.timer.invalidate()
        
        self.topic1VC?.testArray[self.index!] = self.myTime
        
        self.topic1VC?.myCollectionView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension TopicChild1ViewController : UITextFieldDelegate {
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.nowStr = textField.text
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
        
    }
    
}
