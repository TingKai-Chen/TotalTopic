//
//  ViewController.swift
//  TotalTopic
//
//  Created by 陳庭楷 on 2021/11/26.
//

import UIKit

struct TimeMenu {
    
    var name: String?
    
    var date: Date?
    
}

class Topic1ViewController: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var testArray = [TimeMenu]()
    
    var starTime = TimeMenu()
    
    var timer = Timer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var time = TimeMenu()
        
        time.name = "項目一"
        
        time.date = self.string2Date(date2String(Date.tomorrow), dateFormat: "yyyy-MM-dd")
        
        self.starTime = time
        
        self.testArray.append(self.starTime)
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        layout.minimumLineSpacing = 5
        
        layout.scrollDirection = .vertical
        
        layout.itemSize.height = 150
        
        layout.itemSize.width = 200
        
        self.myCollectionView.collectionViewLayout = layout
        
        let nib = UINib(nibName: "Topic1Cell", bundle: nil)
        
        self.myCollectionView.register(nib,forCellWithReuseIdentifier:"Topic1Cell")
        
        self.myCollectionView.delegate = self
        
        self.myCollectionView.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Topic1Segue" {
            
            let backItem = UIBarButtonItem()
            
            backItem.title = ""
            
            backItem.tintColor = .black
            
            navigationItem.backBarButtonItem = backItem
           
            if let UINC = segue.destination as? UINavigationController {
                
                let topicChild1VC = UINC.topViewController as? TopicChild1ViewController
                
                topicChild1VC?.topic1VC = self
                
                let buttonTag = sender as! Int
                
                topicChild1VC!.myTime = self.testArray[buttonTag]
                
                topicChild1VC?.index = buttonTag
            
            }
            
        }
        
    }
    
    func string2Date(_ string:String, dateFormat:String = "yyyy-MM-dd") -> Date {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale.init(identifier: "zh_CN")
        
        formatter.dateFormat = dateFormat
        
        let date = formatter.date(from: string)
        
        return date!
        
    }
    
    func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd") -> String {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale.init(identifier: "zh_CN")
        
        formatter.dateFormat = dateFormat
        
        let date = formatter.string(from: date)
        
        return date
        
    }
    
    func changeTime(date:Date,label:UILabel) {
        
        self.timer.fire()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            //秒
            let s = (Int(date.timeIntervalSince1970) - Int(Date().timeIntervalSince1970)) % 60
            //分
            let m = ((Int(date.timeIntervalSince1970) - Int(Date().timeIntervalSince1970)) / 60) % 60
            //時
            let h = ((Int(date.timeIntervalSince1970) - Int(Date().timeIntervalSince1970)) / 3600) % 24
            //日
            let d = (Int(date.timeIntervalSince1970) - Int(Date().timeIntervalSince1970)) / 86400
            
            label.text = "\(d)日\(h)小時\(m)分\(s)秒"
            
        })
        
    }
    
    @IBAction func add(_ sender: Any) {
        
        self.testArray.append(self.starTime)
        
        self.myCollectionView.reloadData()
        
    }

}

extension Topic1ViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.testArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Topic1Cell", for: indexPath) as! Topic1Cell
       
        self.changeTime(date: self.testArray[indexPath.row].date!,label: collectionViewCell.dateLabel)
        
        collectionViewCell.numberLabel.text = self.testArray[indexPath.row].name
        
        return collectionViewCell
        
    }
    
}

extension Topic1ViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "Topic1Segue", sender: indexPath.row)
        
    }
    
}

extension Date {
    
    static var yesterday: Date { return Date().dayBefore }
    
    static var tomorrow:  Date { return Date().dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
}
