

import UIKit
import MapleBacon
import XCDYouTubeKit
import SWXMLHash
import Alamofire
class XMLController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var xmlArray:[XMLIndexer] = []
    var backgroudView:DKLiveBlurView!
    var feedXML:FeedDelegate = Fetch()
 
    @IBOutlet weak var xmlTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        feedXML.feedXMLData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData:", name: "updateXMLData", object: nil)
        self.navigationController?.navigationBar.hidden = true
       // self.xmlArray = Fetch().feedXML()
        let headerView = UIView(frame: CGRectMake(50, 0, 320 , 300))
        self.xmlTableView.tableHeaderView = headerView
        self.backgroudView = DKLiveBlurView(frame: self.view.bounds)
        self.backgroudView.originalImage = UIImage(named: "xml_bg.gif")
        self.backgroudView.contentMode = UIViewContentMode.ScaleToFill
        self.xmlTableView.backgroundView = self.backgroudView;
        
    }
    
    func updateData(notification:NSNotification){
        let data = notification.userInfo! as [NSObject:AnyObject]
        let responses = data["xmlString"] as! String
        let xml = SWXMLHash.parse(responses)
        self.xmlArray = xml["youtubes_list"].children
        self.xmlTableView.reloadData()
        
        
    }

    
    
    
    
    override func viewDidDisappear(animated: Bool) {
        self.backgroudView.scrollView = nil
    }
    
    
    override func viewWillAppear(animated: Bool) {
     
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.backgroudView.scrollView = self.xmlTableView
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return self.xmlArray.count-1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellXML = tableView.dequeueReusableCellWithIdentifier("xml") as! XMLCell
        let item = self.xmlArray[indexPath.row]

        let youtubeID = item["youtubeID"].element?.text
        let imageYoutubeURL = NSURL(string:"http://img.youtube.com/vi/\(youtubeID!)/hqdefault.jpg")
        let imageURL = item["image_link"].element?.text!
        
        cellXML.title.text = item["title"].element?.text
        cellXML.subTitle.text = item["description"].element?.text
        cellXML.imageTitle.setImageWithURL(NSURL(string:imageURL!)!)
        cellXML.imageBody.setImageWithURL(imageYoutubeURL!)

        
        return cellXML
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.xmlArray[indexPath.row]
        let youtubeID = item["youtubeID"].element?.text!
        let playVC = XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeID)
        self.presentViewController(playVC, animated: true, completion: nil)
    }
    
    

}
