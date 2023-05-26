/**
 * CedCommerce
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the End User License Agreement (EULA)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://cedcommerce.com/license-agreement.txt
 *
 * @category  Ced
 * @package   MageNative
 * @author    CedCommerce Core Team <connect@cedcommerce.com >
 * @copyright Copyright CEDCOMMERCE (http://cedcommerce.com/)
 * @license      http://cedcommerce.com/license-agreement.txt
 */


import UIKit
import FSPagerView

protocol bannerClicked {
  func bannerDidSelect(banner:[String:String]?,sender:Any)
}

class HomeBannerCell: UITableViewCell {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackWidht: NSLayoutConstraint!
    @IBOutlet weak var bannerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerView: FSPagerView!{
    didSet {
      self.bannerView.automaticSlidingInterval = 4
      
      self.bannerView.dataSource = self
      self.bannerView.delegate = self
       
      self.bannerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.bannerView.register(UINib(nibName: "VideoCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell2")
        
    }
  }
    
  var banners : [[String:String]]?
  var delegate:bannerClicked?
    
  var singleTopImage: UIImageView?
    var cornerRadius: CGFloat = 0.0
    var parentView: UIViewController?
    
    @IBOutlet weak var pagetopSpace: NSLayoutConstraint!
    @IBOutlet weak var pageControl: FSPageControl!
  
    @IBOutlet weak var pageBottomSpace: NSLayoutConstraint!
    
    override func awakeFromNib() {
    super.awakeFromNib()
  }
    

  func configureFrom(from model:HomeBannerSliderViewModel){
    self.banners = model.items
//    var videoLink: [String: String] = ["image_url": "https://www.youtube.com/watch?v=MttlgYpIOXc"]
//    self.banners?.append(videoLink)
    
    setupLayout(model: model)
    bannerView.reloadData()
  }
  
  func configure(from model:HomeTopBarViewModel){
    self.banners = model.items
    self.bannerView.dataSource = self
    self.bannerView.delegate = self
     
    bannerView.reloadData()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

extension HomeBannerCell:FSPagerViewDataSource{
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    return banners?.count ?? 0
  }
  
  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
      if let imageUrl = banners![index]["image_url"]{
          
          if imageUrl.contains("youtube.com") || imageUrl.contains("www.youtube.com") || imageUrl.contains("http://www.youtube.com") {
              
              let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell2", at: index) as? VideoCell
              
              let videoUrl = imageUrl
                if let id = videoUrl.components(separatedBy: "=").last {
                   
                  cell?.youtubePlayerView.load(withVideoId: id, playerVars: [  "autoplay"     : 0,
                                                                        "playsinline"  : 0,
                                                                        "controls"     : "1",
                                                                        "showinfo"     : "0",
                                                                        "origin"       : "http://www.youtube.com"])
                    cell?.youtubePlayerView.clipsToBounds = true
                    cell?.youtubePlayerView.layer.cornerRadius = self.cornerRadius * UIScreen.main.scale
                }
              return cell!
              
          } else {
              let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)

          
              let url = URL(string: imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
              
              cell.contentView.layer.shadowRadius  = 0
              cell.contentView.layer.shadowOpacity = 0
              
              cell.imageView?.setRoundedImageFrom(url, radius: self.cornerRadius * UIScreen.main.scale)
              cell.imageView?.layer.masksToBounds = true
              cell.imageView?.contentMode = .scaleAspectFit
             
        
//
              return cell
          }

        }
      
      return FSPagerViewCell()
      
//      cell.layer.shadowColor = UIColor.white.cgColor
//      cell.imageView?.layer.shadowColor = UIColor.white.cgColor


  }
  
}
extension HomeBannerCell:FSPagerViewDelegate{
  // MARK:- FSPagerView Delegate
  
  func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    pagerView.deselectItem(at: index, animated: true)
      if let imageUrl = banners![index]["image_url"]{
          if imageUrl.contains("youtube.com") || imageUrl.contains("www.youtube.com") || imageUrl.contains("http://www.youtube.com") {
              if let cell = self.bannerView.cellForItem(at: index) as? VideoCell {
                  cell.youtubePlayerView.playVideo()
              }
          }
      }
    self.delegate?.bannerDidSelect(banner: banners?[index], sender: self)
  }
  
  func pagerViewDidScroll(_ pagerView: FSPagerView) {
    self.pageControl.currentPage = pagerView.currentIndex
    if let imageUrl = banners![pagerView.currentIndex]["image_url"]{
      let url = URL(string: imageUrl)
      singleTopImage?.setImageFrom(url)
    }
  }
}

extension HomeBannerCell{
  
  func setupLayout(model: HomeBannerSliderViewModel){
      self.bannerView.isInfinite = true
      self.pageControl.numberOfPages = self.banners?.count ?? 0;
      self.pageControl.contentHorizontalAlignment = .center
      self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
      self.pageControl.hidesForSinglePage = true
      self.stackView.layer.cornerRadius = 6
      self.stackView.clipsToBounds = true
      let width = Double((self.banners?.count ?? 0) * 20)
      self.stackWidht.constant = width
      
      
      DispatchQueue.main.async {
          let bannerShape = model.banner_shape?.split(separator: "-")[1]
          var padding: CGFloat = 0.0
          if let paddingValue = Double(model.containerPadding ?? "0.0") {
              padding = paddingValue
          }
          if bannerShape == "l1" {
              self.bannerView.transformer = .none
              self.bannerView.itemSize = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height)
              calculateSpacing(padding: padding)
          } else if bannerShape == "l2" {
//              self.bannerView.transformer = FSPagerViewTransformer(type: .linear)
              self.bannerView.transformer = .none
              self.bannerView.itemSize = CGSize(width: self.contentView.frame.width - 70, height: self.contentView.frame.height)
              calculateSpacing(padding: 0)
              self.bannerView.interitemSpacing = 15
          } else if bannerShape == "l3" {
              self.bannerView.transformer = FSPagerViewTransformer(type: .linear)
              self.bannerView.interitemSpacing = 15
              self.bannerView.itemSize = CGSize(width: self.contentView.frame.width - 70, height: self.contentView.frame.height)
              calculateSpacing(padding: 0)
          }else{
              self.bannerView.transformer = .none
              self.bannerView.itemSize = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height)
          }
      }
      
      func calculateSpacing(padding: CGFloat) {
          switch padding{
          case 0:
              self.bannerViewLeadingConstraint.constant = 0
              self.bannerViewTrailingConstraint.constant = 0
              
          case 2:
              self.bannerViewLeadingConstraint.constant = padding + 1.5
              self.bannerViewTrailingConstraint.constant = padding + 1.5
              
          case 4:
              self.bannerViewLeadingConstraint.constant = padding + 4
              self.bannerViewTrailingConstraint.constant = padding + 4
              
          case 6:
              self.bannerViewLeadingConstraint.constant = padding + 6
              self.bannerViewTrailingConstraint.constant = padding + 6
              
          case 8:
              self.bannerViewLeadingConstraint.constant = padding + 8
              self.bannerViewTrailingConstraint.constant = padding + 8
              
          case 10:
              self.bannerViewLeadingConstraint.constant = padding + 10
              self.bannerViewTrailingConstraint.constant = padding + 10
          default:
              self.bannerViewLeadingConstraint.constant = padding + 12
              self.bannerViewTrailingConstraint.constant = padding + 12
          }
      }

//      self.pageControl.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
      self.pageControl.backgroundColor = UIColor.clear
    if(model.item_dots != "1")
    {
      pageControl.isHidden = true;
        pagetopSpace.constant = 0
        self.stackView.isHidden = true
        pageBottomSpace.constant = 0
        stackHeight.constant = 0
    }
    else{
      pageControl.isHidden = false;
        pagetopSpace.constant = 10
        self.stackView.isHidden = false
        pageBottomSpace.constant = 10
        stackHeight.constant = 15
    }
    self.pageControl.setFillColor(model.active_dot_color, for: .selected)
    self.pageControl.setFillColor(model.inactive_dot_color, for: .normal)
    self.bannerView.dataSource = self
    self.bannerView.delegate = self
  }
}
