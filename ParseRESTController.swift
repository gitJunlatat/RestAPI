

import UIKit
import Alamofire

class ParseRESTController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var feedPersonal:FeedDelegate = Fetch()
    var personalData = NSArray()
    @IBOutlet weak var personalTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedPersonal.feedParse()
        self.navigationController?.navigationBar.hidden = true
        let headerImage:UIImage = UIImage(named: "person_bg.png")!
        let dim = CGSizeMake(self.personalTable.frame.size.width, 300)
        let headerView = ParallaxHeaderView.parallaxHeaderViewWithImage(headerImage, forSize: dim)
        self.personalTable.tableHeaderView = headerView as? UIView
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData:", name: "updateRestData", object: nil)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        (self.personalTable.tableHeaderView as? ParallaxHeaderView)?.refreshBlurViewForNewImage()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.personalTable{
            (self.personalTable.tableHeaderView as? ParallaxHeaderView)?.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func updateData(notification:NSNotification){
        self.personalData = notification.userInfo!["restData"] as! NSArray
        self.personalTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personalData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let personalCell = tableView.dequeueReusableCellWithIdentifier("Personal") as! PersonalCell
        let imageURL = NSURL(string: self.personalData[indexPath.row]["picture"]!!["url"] as! String)
        personalCell.profileImage.setImageWithURL(imageURL!)
        personalCell.profileName.text = self.personalData[indexPath.row]["name"] as! String
        personalCell.profileDate.text = self.personalData[indexPath.row]["date"] as! String
        personalCell.profileAge.text = String(self.personalData[indexPath.row]["age"] as! NSNumber)
        personalCell.profileCareer.text = self.personalData[indexPath.row]["career"] as! String
        
        return personalCell
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}
