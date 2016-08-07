
import UIKit
import Alamofire
import MapleBacon
import XCDYouTubeKit

class JSONController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var dataArr:NSArray = NSArray()
    @IBOutlet weak var jsonTableView: UITableView!
    var feedJSON:FeedDelegate = Fetch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedJSON.feedJSONData()
    
        
        
        
        self.navigationController?.navigationBar.hidden = true
        let headerImage:UIImage = UIImage(named: "bg_frame.jpg")!
        let dim = CGSizeMake(self.jsonTableView.frame.size.width, 300)
        print(self.jsonTableView.frame.size.width)
        var headerView = ParallaxHeaderView.parallaxHeaderViewWithImage(headerImage, forSize: dim)
        self.jsonTableView.tableHeaderView = headerView as? UIView
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData:", name: "updateJSONData", object: nil)
        

    }
    
    func updateData(notification:NSNotification){
        dataArr = notification.userInfo!["jsonData"] as! NSArray
        self.jsonTableView.reloadData()
    }
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

    
    override func viewDidAppear(animated: Bool) {
       (self.jsonTableView.tableHeaderView as? ParallaxHeaderView)?.refreshBlurViewForNewImage()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.jsonTableView{
            (self.jsonTableView.tableHeaderView as? ParallaxHeaderView)?.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellJSON = tableView.dequeueReusableCellWithIdentifier("json") as! JSONCell
        
        let item = dataArr.objectAtIndex(indexPath.row) as! NSDictionary
        cellJSON.title.text = item.objectForKey("title") as? String
        cellJSON.subTitle.text = item.objectForKey("description") as? String
        let imageURL = item.objectForKey("image_link") as? String
        cellJSON.imageTitle.setImageWithURL(NSURL(string:imageURL!)!)
        let youtubeID = item.objectForKey("youtubeID") as? String
        let imageYoutubeURL = NSURL(string:"http://img.youtube.com/vi/\(youtubeID!)/hqdefault.jpg")
        cellJSON.imageBody.setImageWithURL(imageYoutubeURL!)

        return cellJSON
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let item = self.dataArr.objectAtIndex(indexPath.row) as? NSDictionary
        let youtubeID = item?.objectForKey("youtubeID") as? String
        let playerVC = XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeID)
        self.presentViewController(playerVC, animated: true, completion: nil)
    }
    
}
