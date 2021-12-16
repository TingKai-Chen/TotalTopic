import UIKit

class RessParserDelegate: NSObject,XMLParserDelegate {
    
    var currentInfo: NewInfo?
   
    var currentElementValue: String?
    
    var resultArray = [NewInfo]()
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "Info" {
            
            self.currentInfo = NewInfo()
        
        }
        
        else if elementName == "Name" {
            
            self.currentElementValue = nil
            
        }
        
        else if elementName == "Src" {
            
            self.currentElementValue = nil
            
        }
        
        else if elementName == "Subject" {
            
            self.currentElementValue = nil
            
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "Info" {
            
            if self.currentInfo != nil {
                self.resultArray.append(currentInfo!)
                self.currentInfo = nil
                
            }
        }
        
        else if elementName == "Name" {
            
            self.currentInfo?.name = self.currentElementValue
            
        }
        
        else if elementName == "Src" {
            
            self.currentInfo?.urlStr.append(self.currentElementValue!)
            
        }
        
        else if elementName == "Subject" {
            
            self.currentInfo?.urlName.append(self.currentElementValue!)
            
        }
       
        self.currentElementValue = nil
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if self.currentElementValue == nil {
            
            self.currentElementValue = string
            
        }
        
        else {
            
            self.currentElementValue = currentElementValue! + string
            
        }
        
    }
    
    func getResult() -> [NewInfo] {
        
        return self.resultArray
        
    }
    
}

struct NewInfo {
    
    var urlStr = [String]()
   
    var urlName = [String]()
    
    var name: String?
    
}


class Topic2ViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var myScorllView: UIScrollView!
    
    var refreshControl: UIRefreshControl!
    
    var news = [NewInfo]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.myTableView.delegate = self
        
        self.myTableView.dataSource = self
        
        self.dowmloadXML(withXMLAddress: "https://travel.tycg.gov.tw/open-api/zh-tw/Media/Album?page=1")
        
        self.refreshControl = UIRefreshControl()
        
        self.myScorllView.addSubview(self.refreshControl)
        
        self.refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        
        print("Test1")
        
    }
    
    func dowmloadXML(withXMLAddress xmlAddress:String){
        if let url = URL(string: xmlAddress){
            URLSession.shared.dataTask(with: url) { (data, Response, error) in
                if error != nil{
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009{
                        DispatchQueue.main.async {
                            self.showAlert(title: "目前沒有連結網路")
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showAlert(title: "發生錯誤！！！")
                        }
                    }
                    return
                }
                if let loadData = data{
                    let parser = XMLParser(data: loadData)
                    let rssParserDelegate = RessParserDelegate()
                    parser.delegate = rssParserDelegate
                    if parser.parse() == true{
                        self.news = rssParserDelegate.getResult()
                        DispatchQueue.main.async {
                            
                            self.refreshControl.endRefreshing()
                            
                            self.myTableView.reloadData()
                            
                        }
                        
                    }else {
                        DispatchQueue.main.async {
                            
                            self.showAlert(title: "XML 解析失敗！！！")
                            
                        }
                        
                    }
                    
                }
                
            }.resume()
        }
    }
    
    func showAlert(title:String){
        
        let alert = UIAlertController(title: title, message: "請稍後再試！", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func loadData(){
        
        self.dowmloadXML(withXMLAddress: "https://travel.tycg.gov.tw/open-api/zh-tw/Media/Album?page=1")
        
    }
    
}

extension Topic2ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.news.count
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.news[section].name
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.news[section].urlStr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Topic2Cell", for: indexPath) as! Topic2Cell
        
        cell.nameLabel.text = self.news[indexPath.section].urlName[indexPath.row]
        
        let url = URL(string: self.news[indexPath.section].urlStr[indexPath.row])!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data, let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    
                    cell.photoImage.image = image
                    
                }
                
            }
            
        }
        
        task.resume()
        
        return cell
        
    }
    
}


extension Topic2ViewController: UITableViewDelegate {
    
    
    
}
