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
import RxSwift

class HomeViewController: BaseViewController {
    
    let middleLogoImage = UIImageView()
    
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var appheaderMainstackLeadingConstraintToHamp: NSLayoutConstraint!
    
    @IBOutlet weak var centralView: UIView!
    @IBOutlet weak var appHeaderMainstack: UIStackView!
    
    @IBOutlet weak var logoSpacerView: UIView!
    @IBOutlet weak var topShadowImageView: UIImageView!
    @IBOutlet weak var topImageShadowView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topImageSingleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    
    var homeData : HomeModel?
    var cellHeight = [Int:CGFloat]()
    var refreshViewControl: UIRefreshControl?
    var sortOrder:sort_order?
    var dataSource:[String:Any]?
    var layoutHeight = [String:CGFloat]()
    var imageHeight = [String: CGSize]()
    var navigationViewModel :HomeTopBarViewModel?
    
    @IBOutlet weak var navigation: UIView!
    @IBOutlet weak var hampMenu: UIButton!
    @IBOutlet weak var appHeaderLogo: UIImageView!
    
    @IBOutlet weak var headerLogoStackView: UIStackView!
    
    @IBOutlet weak var serachBox: UITextField!
    @IBOutlet weak var searchNavButton: UIButton!
    @IBOutlet weak var wishListIcon: BadgeButton!
    @IBOutlet weak var cartIcon: BadgeButton!
    @IBOutlet weak var searchBar2: UITextField!
    @IBOutlet weak var topImageSingle: UIImageView!
    
    //    @IBOutlet weak var voiceView: UIView!
    //
    //    @IBOutlet weak var voiceButton: UIButton!
    
    var bestSellingProducts: Array<ProductViewModel>?
    var trendingProducts: Array<ProductViewModel>?
    var product : ProductViewModel!
    var selectedVariant:VariantViewModel!
    var personalisedProductsHide = false;
    var productId:String?
    
    var productsArray = [Int:Any]()
    var floatingButton : UIButton!
    var leftFloatingButton : UIButton!
    var disposeBag = DisposeBag()
    let shimmer = customShimmerView(cellsArray: [categoryShimmerTC.reuseId,bannerShimmerTC.reuseID,productListingShimmerTC.reuseID,bannerShimmerTC.reuseID,productListingShimmerTC.reuseID,bannerShimmerTC.reuseID])
    
    var instaFeedCounts = 0
    var feedsData = [InstagramMedia]()
    var scrolled = 0
    var instaFeedData : Feed?
    var floatingThemeButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeConfigure()
        // ----------------------------------
        //  MARK: - three themes removing for now
        //
      /*  if Client.merchantID == "18" {
            self.setupThemeSwitchBtn()
        } */
        self.topImageSingle.backgroundColor = UIColor(light: .white,dark: .black)
        checkForAppUpdate()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Check if the user switched to dark mode
        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            searchBar2.makeBorder(width: 0.5, color: UIColor(light: /*navigationViewModel?.search_border_color ??*/ .darkGray,dark: DarkColor.darkBorderColor) , radius: 5)
            serachBox.makeBorder(width: 0.5, color: UIColor(light: /*navigationViewModel?.search_border_color ?? */.darkGray,dark: DarkColor.darkBorderColor) , radius: 5)
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavBarCount()
        redirectPushNotifications()
        //        DispatchQueue.main.asyncAfter(deadline: .now()+6.0){
        //            self.setupTabbarCount()
        //            self.tabBarController?.tabBar.tabsVisiblty()
        ////            customAppSettings.sharedInstance.tab.subscribe( onNext: {_ in
        ////                self.tabBarController?.tabBar.tabsVisiblty()
        ////            })
        //
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navConfigure()
        self.tabBarController?.tabBar.tabsVisiblty()
        // START--InstaFeeds
        // Get Instagram Feeds if required Instagram Feeds Option
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.setupTabbarCount()
            //            customAppSettings.sharedInstance.tab.subscribe( onNext: {_ in
            //                self.tabBarController?.tabBar.tabsVisiblty()
            //            })
            
        }
        if customAppSettings.sharedInstance.isInstaFeed{
            InstagramAPI.shared.getMediaData(completion: {
                (data) in
                // print(data)
                self.instaFeedData = data
                if(customAppSettings.sharedInstance.instaViewType == .scroll){
                    self.scrolled = 1
                }
                else{
                    self.scrolled = 0
                }
                self.feedsData = data.data
                self.instaFeedCounts = customAppSettings.sharedInstance.instaFeedCount
                print("Counts===>",self.instaFeedCounts)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        // End--InstaFeeds
        // JS
        
        // END
        // ----------------------------------
        //  MARK: - three themes removing for now
        //
      /*  DispatchQueue.main.async {
            self.checkForStaticThemeOption()
        }  */
        
        self.navigationController?.navigationBar.isHidden = true;
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    fileprivate func checkForAppUpdate() {
        do {
            _ = try? self.isUpdateAvailable { [self] (update, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error)
                    } else if update ?? false {
                        // show alert
                        self.showAppUpdatePopup()
                        return
                    }
                }
            }
        }
    }
    
    func tabCountMgmt() {
       DispatchQueue.main.asyncAfter(deadline: .now()){
           self.setupTabbarCount()
           customAppSettings.sharedInstance.tab.subscribe( onNext: {_ in
               self.tabBarController?.tabBar.tabsVisiblty()
           }).disposed(by: self.disposeBag)
       }
   }
    
    func setUpWhatsappFloatingButton() {
        floatingButton = UIButton()
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.setTitleColor(UIColor.white, for: .normal)
        floatingButton.setImage(UIImage(named: "wapp"), for: .normal)
        floatingButton.addTarget(self, action: #selector(redirectToWhatsapp(_:)), for: .touchUpInside)
        self.view.addSubview(floatingButton)
        floatingButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        floatingButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        floatingButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func redirectToWhatsapp(_ sender : UIButton) {
        let txt = Client.whatsappMsg
        guard let whatsappURL =  "https://api.whatsapp.com/send?phone=\(Client.whatsappNumber)&text=\(txt)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.getURL() else {return}
        if UIApplication.shared.canOpenURL(whatsappURL) {
            UIApplication.shared.open(whatsappURL)
        } else {
        }
    }
    
    func setUpFBFloatingButton() {
        leftFloatingButton = UIButton()
        leftFloatingButton.translatesAutoresizingMaskIntoConstraints = false
        leftFloatingButton.setTitleColor(UIColor.white, for: .normal)
        leftFloatingButton.setImage(UIImage(named: "messenger-fb"), for: .normal)
        leftFloatingButton.addTarget(self, action: #selector(redirectToFb(_:)), for: .touchUpInside)
        self.view.addSubview(leftFloatingButton)
        leftFloatingButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        leftFloatingButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        leftFloatingButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        leftFloatingButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func redirectToFb(_ sender : UIButton) {
        let url = URL(string: "\(Client.fbURL)")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        }
        else {}
    }
}


// ----------------------------------
//  MARK: - UITableviewdelegate -
//
extension HomeViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section < sortOrder?.fields?.count ?? 0){
            switch  getComponentOnIndex(index: indexPath.section)
            {
            case  let x where x?.contains("spacer") ?? false:
                if let data = dataSource?[x!] as? [String:Any]{
                    let model = HomeSpacerViewModel(from:data)
                    return CGFloat(model.spacerHeight ?? 0)
                }
               return 0
            case let x where x?.contains("banner-slider") ?? false:
                //return 4/7*self.view.frame.width
                if let data = self.dataSource?[x!] as? [String:Any] {
                    let viewModel = HomeBannerSliderViewModel(from: data)
                    var spaceConstant: CGFloat = 0
                    if(viewModel.item_dots == "1"){
                        spaceConstant = 30
                    }
                    else{
                        spaceConstant = 0
                    }
                    let bannerSize = viewModel.banner_shape?.split(separator: "-")[0]
                    let layoutType = viewModel.banner_shape?.split(separator: "-")[1]
                    
                    switch bannerSize{
                    case "bs1":
                        let paddingToIncludeIfNotL1 = CGFloat(15)
                        let height = self.view.frame.width/3 + spaceConstant
                        if layoutType != "l1"{
                            return height-paddingToIncludeIfNotL1
                        }
                        return height
                    case "bs2":
                        let paddingToIncludeIfNotL1 = CGFloat(28)
                        let height = ((9*self.view.frame.width)/16)+spaceConstant
                        if layoutType != "l1"{
                            return height-paddingToIncludeIfNotL1
                        }
                        return height+spaceConstant
                    case "bs3":
                        let paddingToIncludeIfNotL1 = CGFloat(50)
                        let height = (self.view.frame.width)+spaceConstant
                        if layoutType != "l1"{
                            return height-paddingToIncludeIfNotL1
                        }
                        return height
                    case "bs4":
                        let paddingToIncludeIfNotL1 = CGFloat(40)
                        let height = (self.view.frame.width/1.4)+spaceConstant
                        if layoutType != "l1"{
                            return height-paddingToIncludeIfNotL1
                        }
                        return height
                    case "bs5":
                        let paddingToIncludeIfNotL1 = CGFloat(125)
                        let height = ((2*self.view.frame.width)/1.5)+spaceConstant
                        if layoutType != "l1"{
                            return height+spaceConstant-paddingToIncludeIfNotL1
                        }
                        return height+spaceConstant
                    default:
                        let paddingToIncludeIfNotL1 = CGFloat(0)
                        let height = ((9*self.view.frame.width)/16)+spaceConstant
                        if layoutType != "l1"{
                            return height-paddingToIncludeIfNotL1
                        }
                        return height+spaceConstant
//                        return (394/700*self.view.frame.width)+spaceConstant
                    }
                }
                return (4/7*self.view.frame.width)+20
                
            case let x where x?.contains("collection-grid-layout") ?? false:
                return layoutHeight[x!] ?? 0
            case let x where x?.contains("announcement-bar") ?? false:
                return 38
            case "bannersAdditional":
                return 101*3 + 65
            case let x where x?.contains("fixed-customisable-layout") ?? false:
                return layoutHeight[x!] ?? UITableView.automaticDimension
            case  let x where x?.contains("three-product-hv-layout") ?? false:
                let ar = 5.0/7.0
                let width = self.view.bounds.width / 1.6
                var cellHeight = width/ar
                if let data = dataSource?[x!] as? [String:Any]{
                    let model = Home3hvLayoutViewModel(from:data)
                    if(model.header == "1"){
                        cellHeight += 30
                        if(model.header_subtitle == "1"){
                            cellHeight += 20
                        }
                        if(model.header_deal == "1"){
                            cellHeight += 95
                        }
                    }
                }
                return CGFloat(cellHeight)
            case let x where x?.contains("category-circle") ?? false:
                if let data = dataSource?[x!] as? [String:Any]{
                    let model = HomeCollectionSliderViewModel(from:data)
                    if(model.show_item_title){
                        return 137
                    }
                }
                return 100
            case let x where x?.contains("category-slider") ?? false:
                if let data = dataSource?[x!] as? [String:Any]{
                    let model = HomeCollectionSliderViewModel(from:data)
                    if(model.show_item_title){
                        return 122
                    }
                }
                return 85
            case let x where x?.contains("category-square") ?? false:
                if let data = dataSource?[x!] as? [String:Any]{
                    let model = HomeCollectionSliderViewModel(from:data)
                    if(model.show_item_title){
                        return 120
                    }
                }
                return 80
            case let x where x?.contains("category-card") ?? false:
                if let data = dataSource?[x!] as? [String:Any]{
                    let model = HomeCollectionSliderViewModel(from:data)
                    switch model.item_shape{
                    case "rectangle":
                        return model.show_item_title ? 100 : 70
                    default:
                        return model.show_item_title ? 120 : 85
                    }}
            case let x where x?.contains("standalone-banner") ?? false:
                if let data = self.dataSource?[x!] as? [String:Any] {
                    let viewModel = HomeStandAloneBannerViewModel(from: data)
                    switch viewModel.item_image_size{
                    case "half":
                        let ar = 700.0/120.0
                        let cellHeight = (self.view.frame.width)/ar
                        return cellHeight + 20
                    case "original":
                        return (3/7*(self.view.frame.width))
                    case "2x":
                        return (281/375*(self.view.frame.width))
                    case "3x":
                        return (498/375*(self.view.frame.width))
                    default: return (3/7*(self.view.frame.width))
                    }
                }
                return (3/7*(self.view.frame.width-30))+20
                
            case let x where x?.contains("collection-list-slider") ?? false:
                return self.layoutHeight[x!] ?? 0
            case let x where x?.contains("product-list-slider") ?? false:
                return self.layoutHeight[x!] ?? 0
                //
            case let x where x?.contains("insta-feed") ?? false:
                if instaFeedCounts > 0{
                    if(scrolled==0){
                        if(feedsData.count<instaFeedCounts){
                            let rows = ceil(Double(feedsData.count)/3.0)
                            return (rows * ((UIScreen.main.bounds.width-40)/3)) + 35
                        }
                        else{
                            let rows = ceil(Double(instaFeedCounts)/3.0)
                            return (rows * ((UIScreen.main.bounds.width-40)/3)) + 35
                        }
                    }
                    else{
                        return (((UIScreen.main.bounds.width-40)/3)) + 15
                    }
//                    if instaFeedCounts < 7{
//
//                        scrolled = 1
//                        if  instaFeedCounts % 2 == 0{
//                            print("less than 7 but 2, 4 ,6",instaFeedCounts)
//                            return CGFloat(instaFeedCounts * 120) + 20
//                        }p
//                        else{
//                            print("less than 7 but 1, 3 ,5",instaFeedCounts)
//                            return CGFloat((instaFeedCounts + 1) * 120) + 20
//                        }
//                    }
//                    else{
//
//                        scrolled = 1
//                        print("greater than 7 but show only 6",instaFeedCounts)
//                        instaFeedCounts = 7
//
//                        return CGFloat((instaFeedCounts - 1) * 120)
//                    }
                }
                else{
                    return 0
                }
                //return 720
                //
            default:
                return 0
            }
        }
        else if(indexPath.section == sortOrder?.fields?.count){
            if trendingProducts?.count ?? 0 > 0 {
                return layoutHeight["trending"] ?? 0
            }
            return 0
        }
        else if(indexPath.section == (sortOrder?.fields?.count ?? 0) + 1){
            if bestSellingProducts?.count ?? 0 > 0 {
                return layoutHeight["bestSelling"] ?? 0
            }
            return 0
        }
        return 0
    }
    
    func getImageFromUrl(url:URL,index:IndexPath){
        let task =  URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    let width = image.size.width
                    let height = image.size.height
                    let scaleFactor =  height / width
                    let cellHeight = scaleFactor*self.view.frame.width
                    self.cellHeight[index.section] = cellHeight
                    self.tableView.beginUpdates()
                    self.tableView.reloadSections(NSIndexSet(index: index.section) as IndexSet, with: .fade)
                    self.tableView.endUpdates()
                }
            }
        }
        task.resume()
    }
}
// ----------------------------------
//  MARK: - UITableviewdatasource -
//
extension HomeViewController:UITableViewDataSource
{
    // ----------------------------------
    //  MARK: - three themes removing for now
    //
  /*  func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let floatingThemeButton = floatingThemeButton {
            if scrollView.contentOffset.y > 50 {
                
                for item in floatingThemeButton.constraints {
                    floatingThemeButton.removeConstraint(item)
                }
                floatingThemeButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 15, paddingRight: 15, width: 60, height: 60)
                floatingThemeButton.layer.cornerRadius = 30
                floatingThemeButton.setTitle("", for: .normal)
            }
            else {
                for item in floatingThemeButton.constraints {
                    floatingThemeButton.removeConstraint(item)
                }
                floatingThemeButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 15, paddingRight: 15, width: 150, height: 60)
                floatingThemeButton.layer.cornerRadius = 25
                floatingThemeButton.setTitle("Themes".localized, for: .normal)
            }
        }
    }  */
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if(indexPath.section == 0){
//            if(navigationViewModel?.item_banner == "1"){
//                self.topImageSingle.isHidden = false;
//                topImageShadowView.isHidden = false
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if(indexPath.section == 0){
//            if(navigationViewModel?.item_banner == "1"){
//                self.topImageSingle.isHidden = true;
//                topImageShadowView.isHidden = true
//            }
//        }
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Insta Condition
        if instaFeedCounts>0{
            return (self.sortOrder?.fields?.count ?? 0)+2//manually +3 at bottom cell but if dynamic no need to condition
        }
        else{
            return (self.sortOrder?.fields?.count ?? 0)+2
        }
    }
    
    func getComponentOnIndex(index:Int)->String?{
        
        guard let sortValue = self.sortOrder?.fields else {
            return  nil
        }
        print(sortValue)
        return sortValue.filter{"\($0.value)" == "\(index)"}.first?.key
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let _ = self.sortOrder?.fields else {
            return 0
        }
        
        if(section == self.sortOrder?.fields?.count){
            guard let count = trendingProducts?.count else {
                return 0
            }
            if(count == 0){
                return 0;
            }
        }
        
        if(section == (self.sortOrder?.fields!.count)! + 1){
            guard let count = bestSellingProducts?.count else {
                return 0
            }
            if(count == 0){
                return 0;
            }
        }
        //      if(section == (self.sortOrder?.fields!.count)! + 2){
        //         return 1
        //     }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section < sortOrder?.fields?.count ?? 0){
            switch  getComponentOnIndex(index: indexPath.section)
            {
            case let x where x?.contains("spacer") ?? false:
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeSpacerCell.className) as! HomeSpacerCell
                if let data  = self.dataSource?[x!] as? [String:Any]
                {
                    let viewModel = HomeSpacerViewModel(from: data)
                    
                    cell.backgroundColor = viewModel.spacerColor
                }
                return cell
            case let x where x?.contains("banner-slider") ?? false:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeBannerCell.className) as! HomeBannerCell
                
                if let data  = self.dataSource?[x!] as? [String:Any]
                {
                    print("Bannnnner Datatatt")
                    let viewModel = HomeBannerSliderViewModel(from: data)
                    if let doubleValue = Double(viewModel.cornerRadius ?? "0.0") {
                        cell.cornerRadius = CGFloat(doubleValue)
                    }
                    cell.configureFrom(from: viewModel)
                }
                cell.parentView  = self
                cell.delegate = self
                return cell
                
            case let x where x?.contains("collection-grid-layout") ?? false:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeCollectionGridLayout.className) as! HomeCollectionGridLayout
                cell.parent=self
                if let data  = self.dataSource?[x!] as? [String:Any]{
                    let viewModel = HomeCollectionGridLayoutViewModel(from: data)
                    cell.delegateLayout = self
                    cell.indexPath = indexPath
                    if let size = imageHeight[x!]{
                        cell.imageSize = size
                    }
                    cell.configure(from:  viewModel)
                }
                cell.delegate = self;
                return cell
                
            case "bannersAdditional":
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeCollectionCell.className) as! HomeCollectionCell
                let collection = self.homeData?.collections?[1]
                cell.ViewAll.tag=1
                cell.ViewAll.addTarget(self, action: #selector(viewAllPressed(_:)), for: .touchUpInside)
                cell.configureFrom(collection)
                cell.delegate = self
                cell.parentView = self
                return cell
                //      case "recentlyViewed":
                //        let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecentlyViewedCell.className) as! HomeRecentlyViewedCell
                //        cell.delegate = self
                //        cell.titleLabel.text = "Recently Viewed".localized
                //        cell.parentView = self
                //        cell.products = recentlyViewedManager.shared.recentlyViewedProduct
                //        return cell
            case let x where x?.contains("three-product-hv-layout") ?? false:
                let cell = tableView.dequeueReusableCell(withIdentifier: Home3hvlayoutCell.className) as! Home3hvlayoutCell
                cell.parent=self
                cell.heightDelegate = self;
                cell.componentName = x!
                if let data = dataSource?[x!] as? [String:Any]{
                    let model = Home3hvLayoutViewModel(from:data)
                    cell.configure(from: model)
                }
                cell.delegate = self;
                return cell
                
            case let x where x?.contains("category-circle") ?? false:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: NewHomeCategorySliderCell.className) as! NewHomeCategorySliderCell
                cell.parent = self
                
                if let data = dataSource?[x!] as? [String:Any]{
                    let model = HomeCollectionSliderViewModel(from:data)
                    cell.loadData(from: model)
                }
                
                cell.delegate = self;
                return cell
                
            case let x where x?.contains("category-slider") ?? false:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: NewHomeCategorySliderCell.className) as! NewHomeCategorySliderCell
                cell.parent = self
                
                if let data = dataSource?[x!] as? [String:Any]{
                    let model = HomeCollectionSliderViewModel(from:data)
                    cell.loadData(from: model)
                }
                
                cell.delegate = self;
                return cell
                
            case let x where x?.contains("category-square") ?? false:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeCategorySliderCell.className) as! HomeCategorySliderCell
                cell.parent=self
                if let data = dataSource?[x!] as? [String:Any]{
                    let model = HomeCollectionSliderViewModel(from:data)
                    cell.loadData(from: model)
                }
                
                cell.delegate = self;
                return cell
                
            case let x where x?.contains("category-card") ?? false:
                let cell = tableView.dequeueReusableCell(withIdentifier: NewHomeCategorySliderCell.className) as! NewHomeCategorySliderCell
                cell.parent   = self
                if let data   = dataSource?[x!] as? [String:Any]{
                    let model = HomeCollectionSliderViewModel(from:data)
                    cell.loadData(from: model)
                }
                cell.delegate = self;
                return cell
    
            case let x where x?.contains("standalone-banner") ?? false:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeSingleBannerCell.className) as! HomeSingleBannerCell
                
                cell.parent=self
                cell.setupUI()
                
                if let data = self.dataSource?[x!] as? [String:Any] {
                    let viewModel = HomeStandAloneBannerViewModel(from: data)
                    cell.configure(from: viewModel)
                }
                cell.delegate = self;
                return cell
                
            case let x where x?.contains("fixed-customisable-layout") ?? false:
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeSliderCell.className) as! HomeSliderCell
                if let data = self.dataSource?[x!] as? [String:Any] {
                    let viewModel = HomeFixedCustomisableLayoutViewModel(from: data)
                    cell.indexPaths = indexPath
                    cell.delegate = self
                    cell.bannerdelegate = self;
                    cell.parentView = self;
                    cell.delegateLayout = self
                    if let prod = productsArray[indexPath.section]{
                        if let prod = prod as? PageableArray<ProductListViewModel>{
                            cell.products = prod
                            if let size = imageHeight[x!]{
                                cell.imageSize = size
                            }
                        }
                    }
                    cell.configureFrom(viewModel)
                    if cell.timer != nil {
                        cell.timer.invalidate()
                    }
                    cell.runTimer()
                }
                return cell
                
            case let x where x?.contains("collection-list-slider") ?? false:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeCollectionListSliderCell.className) as! HomeCollectionListSliderCell
                cell.parent = self
                cell.index = indexPath.section
                cell.delegate = self;
                if let data = self.dataSource?[x!] as? [String:Any] {
                    cell.componentName = x!;
                    let viewModel = HomeCollectionListSliderViewModel(from: data)
                    cell.collectionData = viewModel
                    cell.sliderDelegate = self;
                    cell.loadData(from: viewModel)
                    cell.actionButton.tag = indexPath.section;
                    cell.actionButton.addTarget(self, action: #selector(viewAllPressed(_:)), for: .touchUpInside)
                }
                return cell
                
            case let x where x?.contains("product-list-slider") ?? false:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeGridCell.className, for: indexPath) as! HomeGridCell
                if let data = self.dataSource?[x!] as? [String:Any] {
                    let viewModel = HomeProductListSliderViewModel(from: data)
                    cell.delegate = self
                    cell.bannerDelegate = self
                    cell.parentView = self;
                    cell.componentName = x;
                    cell.gridDelegate = self;
                    cell.index = indexPath.section
               
                    if let prod = productsArray[indexPath.section]{
                        if let prod = prod as? Array<ProductViewModel>{
                            print("viewModel==",viewModel.header_title_text)
                            print("See==",prod.first?.title,"index==",indexPath.section)
                            cell.products = prod
                        }
                    }
                    cell.configureFrom(viewModel)
                    if cell.timer != nil {
                        cell.timer.invalidate()
                    }
                    cell.runTimer()
                }
                return cell
                //
            case let x where x?.contains("insta-feed") ?? false:
                let cell = tableView.dequeueReusableCell(withIdentifier: InstaFeedTableCell.className) as! InstaFeedTableCell
                //          print("Scrolled >>",scrolled)
                //          print("Feeds_DATA >>",self.feedsData, self.feedsData.count)
                //          print("Intsa_DATA Count>>",self.instaFeedCounts)
                //          print("sortData Count>>",(sortOrder?.fields!.count)! - 1)
                //          print("Intsa_Position>>",customAppSettings.sharedInstance.instaFeedPosition)
                /*if scrolled == 0 {
                 cell.configure(model: self.feedsData)
                 }
                 else if let val = sortOrder?.fields?.count {
                 if val == customAppSettings.sharedInstance.instaFeedPosition{
                 cell.configure(model: self.feedsData)
                 }
                 }*/
                
                if let data = self.instaFeedData{
                    let viewModel = InstaViewModel(from: data)
                    cell.configureNew(from: viewModel, count: self.instaFeedCounts, scroll: self.scrolled)
                }
                //  cell.configure(model: self.feedsData)
                //cell.backgroundColor = UIColor(hexString: "#EFF8F7")
                return cell
                //
            case let x where x?.contains("announcement-bar") ?? false:
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeAnnouncementBarCell.className, for: indexPath) as! HomeAnnouncementBarCell
                if let data = self.dataSource?[x!] as? [String:Any] {
                  //  cell.componentName = x!;
                    cell.delegate = self;
                    let viewModel = HomeAnnouncementBarViewModel(from: data)
                    cell.model = viewModel
                    cell.parent = self
                    cell.configure(model: viewModel)
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeBannerCell.className) as! HomeBannerCell
                cell.delegate = self
                return cell
            }
        }
        else if(indexPath.section == sortOrder?.fields?.count){
            let cell       = tableView.dequeueReusableCell(withIdentifier: "TrendingProductsCell", for: indexPath) as! SimilarProductsCell
            cell.products = trendingProducts;
            cell.parent=self
            cell.recommendedName = "trending"
            cell.headingLabel.text = "Trending Products".localized
            cell.delegate = self
            cell.layoutDelegate = self
            cell.configure()
            cell.headingLabel.textColor = UIColor.darkGray
            cell.productsCollectionView.backgroundColor = UIColor.white
            //cell.backgroundColor = UIColor.white
            return cell
            
        }
        //else if(indexPath.section == sortOrder?.fields?.count ?? 0 + 1){
        let cell       = tableView.dequeueReusableCell(withIdentifier: "BestSellingProductsCell", for: indexPath) as! SimilarProductsCell
        cell.products = bestSellingProducts;
        cell.parent=self
        cell.recommendedName = "bestSelling"
        cell.delegate = self
        cell.headingLabel.text = "Top Selling Products".localized
        cell.layoutDelegate = self
        cell.configure()
        cell.headingLabel.textColor = UIColor.darkGray
        cell.productsCollectionView.backgroundColor = UIColor.white
        //cell.backgroundColor = UIColor.white
        return cell
        //}
        // Insta Condition
        //      let cell = tableView.dequeueReusableCell(withIdentifier: InstaFeedTableCell.className) as! InstaFeedTableCell
        //      cell.configure(model: self.feedsData)
        //      cell.backgroundColor = UIColor(hexString: "#EFF8F7")
        //      return cell
        // Insta Condition
    }
    
    @objc func viewAllPressed(_ sender:UIButton){
        /*   let getCollection = self.homeData?.collections?[sender.tag]-
         let coll = collection(id: getCollection?.id, title: getCollection?.title)
         let viewControl:ProductListViewController = self.storyboard!.instantiateViewController()
         viewControl.isfromHome = true
         viewControl.collect = coll
         viewControl.title = coll.title
         
         //viewControl.title = String(htmlEncodedString: coll.title!)
         self.navigationController?.pushViewController(viewControl, animated: true)  */
        let getCollection = self.homeData?.collections?[sender.tag]
        let coll = collection(id: getCollection?.id, title: getCollection?.title)
        let vc = ProductListVC()
        vc.isfromHome = true
        vc.collect = coll
        vc.title = coll.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset) <= 40 {
            if let cell = tableView.visibleCells.last as? HomeSliderCell {
                cell.loadMoreproducts()
            }
        }
    }
}

extension HomeViewController: ThreeLayoutHeightProtocol{
    func getLayoutHeight(height: CGFloat,componentName: String){
        layoutHeight[componentName] = height
    }
}

extension HomeViewController:HomeCustomisableFixedLayoutUpdate{
    func updateLayoutAccording(viewModel:HomeFixedCustomisableLayoutViewModel?,collection:UICollectionView?,index:IndexPath,prodCount:Int,hasNewproduct:Bool, products: PageableArray<ProductListViewModel>!, imageSize: CGSize?,reload: Bool,dealEnd: Bool) {
        self.productsArray[index.section] = products
        print(dealEnd)
        
        let componentName = getComponentOnIndex(index: index.section)!
        self.imageHeight[componentName] = imageSize
        

        if layoutHeight[componentName] == nil || hasNewproduct || reload{
            if(viewModel?.item_layout_type == "grid")
            {
                switch viewModel?.item_row {
                case "1","2","3","infinite":
                    var count = prodCount
                    if (prodCount%(Int(viewModel?.item_in_a_row ?? "1")  ?? 1) != 0) {
                        
                        if (viewModel?.item_row ==  "2" && viewModel?.item_in_a_row == "3"){
                            //height issue fixed with item count 1 & 4
                            if prodCount%(Int(viewModel?.item_in_a_row ?? "1")  ?? 1) == 1{
                                count += 2
                            }else{count += 1}
                        }else{
                            count += 1
                        }
                    }
//                    var height = ((collection?.calculateCellSize(numberOfColumns: Int(viewModel?.item_in_a_row ?? "0") ?? 3,of: 80, imagesize: imageSize ?? CGSize(width: 0, height: 0)).height ?? 0)) * CGFloat(count/(Int(viewModel?.item_in_a_row ?? "1")  ?? 1))//(numberOfColumns: 2.2, imagesize: imageSize ?? CGSize(width: 0, height: 0))
                    
                    var height: CGFloat = (collection?.calculateCellSizeOld(numberOfColumns: Int(viewModel?.item_in_a_row ?? "0") ?? 3).height ?? 0) * CGFloat(count/(Int(viewModel?.item_in_a_row ?? "1")  ?? 1))
                    
                    if viewModel?.item_row == "3" || viewModel?.item_row == "infinite"{
                        height += 10
                    }

                    if(viewModel?.item_title == "1"){
                        height +=  25 * CGFloat(count/(Int(viewModel?.item_in_a_row ?? "1")  ?? 1))
                    }
                    if(viewModel?.item_price == "1"){
                        height +=  15 * CGFloat(count/(Int(viewModel?.item_in_a_row ?? "1")  ?? 1))
                    }
                    if (viewModel?.item_row == "2"){
                       height += 14
                    }
                    if (viewModel?.item_row == "1") {
                       height += 12
                    }

                    if(viewModel?.header == "1"){
                        height += 40
                        if(viewModel?.header_subtitle == "1"){
                            height += 20
                        }
                        if(viewModel?.header_deal == "1" && dealEnd==false){
                            height += 85
                        }
                    }
                    layoutHeight[componentName] = height
                default:
                    layoutHeight["trending"]=0.0;
                    layoutHeight["bestSelling"]=0.0;
                    var count = prodCount
                    if (prodCount%(Int(viewModel?.item_in_a_row ?? "1")  ?? 1) != 0) {
                        count += 1
                    }
                    //var height: CGFloat = (collection?.calculateCellSize(numberOfColumns: Int(viewModel?.item_in_a_row ?? "0") ?? 3).height ?? 0) * CGFloat(count/(Int(viewModel?.item_in_a_row ?? "1")  ?? 1))
//                    var height = (collection?.calculateCellSize(numberOfColumns: Int(viewModel?.item_in_a_row ?? "0") ?? 3,of: 80, imagesize: imageSize ?? CGSize(width: 0, height: 0)).height ?? 0) * CGFloat(count/(Int(viewModel?.item_in_a_row ?? "1")  ?? 1))//(numberOfColumns: 2.2, imagesize: imageSize ?? CGSize(width: 0, height: 0))
                    var height: CGFloat = (collection?.calculateCellSizeOld(numberOfColumns: Int(viewModel?.item_in_a_row ?? "0") ?? 3).height ?? 0) * CGFloat(count/(Int(viewModel?.item_in_a_row ?? "1")  ?? 1))
                   
                    if(viewModel?.item_title == "1"){
                        height +=  30 * CGFloat(count/(Int(viewModel?.item_in_a_row ?? "1")  ?? 1))
                    }
                    if(viewModel?.item_price == "1"){
                        height +=  20 * CGFloat(count/(Int(viewModel?.item_in_a_row ?? "1")  ?? 1))
                    }
                    if(viewModel?.header == "1"){
                        height += 40
                        if(viewModel?.header_subtitle == "1"){
                            height += 20
                        }
                        if(viewModel?.header_deal == "1" && dealEnd==false){
                            height += 85
                        }
                    }
                    layoutHeight[componentName] = height
                }
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            else{
//                var height: CGFloat = (collection?.calculateVerticalCellSize(numberOfColumns: 1,of: 90).height ?? 0) * CGFloat(prodCount)
                var height: CGFloat = (collection?.calculateVerticalCellSizeOld(numberOfColumns: 1,of: 113).height ?? 0) * CGFloat(prodCount)
              
                if(viewModel?.header == "1"){
                    height += 50
                    if(viewModel?.header_subtitle == "1"){
                        height += 30
                    }
                    if(viewModel?.header_deal == "1"){
                        height += 85
                    }
                }
                layoutHeight[componentName] = height
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension HomeViewController:HomeCollectionGridLayoutUpdate {
    
    func updateLayoutAccordingToGrid(viewModel: HomeCollectionGridLayoutViewModel?, collection: UICollectionView?, index: IndexPath, imageSize: CGSize?, reload: Bool) {
        let componentName = getComponentOnIndex(index: index.section)!
        imageHeight[componentName] = imageSize
        if layoutHeight[componentName] == nil || reload {
            
            if viewModel?.header == "1" {
                if viewModel?.item_title == "1" {
                    let size = ((collection?.calculateCellSize(numberOfColumns: 2,of: 75, imagesize: imageSize ?? CGSize(width: 1, height: 1), spacing: 25).height ?? 0 ) + 45) * CGFloat(Int(viewModel?.item_rows ?? "0") ?? 0)
                    layoutHeight[componentName] = size + 40
                }else {
                    let height =  ((collection?.calculateCellSize(numberOfColumns: 2,of: 75, imagesize: imageSize ?? CGSize(width: 1, height: 1), spacing: 20).height ?? 0 )+14) * CGFloat(Int(viewModel?.item_rows ?? "0") ?? 0)
                    layoutHeight[componentName] = height + 40
                }
            }else{
                if viewModel?.item_title == "1" {
                    layoutHeight[componentName] = ((collection?.calculateCellSize(numberOfColumns: 2,of: 75, imagesize: imageSize ?? CGSize(width: 1, height: 1), spacing: 25).height ?? 0 ) + 45) * CGFloat(Int(viewModel?.item_rows ?? "0") ?? 0)
                }else {
                    let height =  ((collection?.calculateCellSize(numberOfColumns: 2,of: 75, imagesize: imageSize ?? CGSize(width: 1, height: 1), spacing: 20).height ?? 0 )+15) * CGFloat(Int(viewModel?.item_rows ?? "0") ?? 0)
                    layoutHeight[componentName] = height
                }
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

//extension HomeViewController: HomeGridLayoutUpdate
//{
//    func updateLayoutAccordingToGrid(viewModel:HomeProductListSliderViewModel?,collection:UICollectionView?, productsArray: Array<ProductViewModel>!,componentName: String, index: Int, imageSize: CGSize?,reload:Bool,dealEnd: Bool){
//        self.productsArray[index] = productsArray
//        self.imageHeight[componentName] = imageSize
//        if layoutHeight[componentName] == nil || reload{
//            if productsArray != nil {
//                if(productsArray.count>0){
//                    if viewModel?.header == "1" {
//                        var size = collection?.calculateHalfCellSize(numberOfColumns: 2.5, imagesize: imageSize ?? CGSize(width: 0, height: 0))
//                        size?.height += 40
//                        if(viewModel?.item_title == "1"){
//                            size!.height = size!.height + 35
//                        }
//                        if(viewModel?.item_price == "1"){
//                            size!.height = size!.height + 20
//                        }
//                        var height = (size?.height ?? 0)
//
//                        if viewModel?.numberOfRows == "2" {
//                            if productsArray.count <= 4 {
//                                height = height + 0
//                            } else {
//                                height = (2 * height) - 20
//                                if viewModel?.header_subtitle != "1" {
//                                    height += 20
//                                }
//                            }
//                        } else {
//                            if viewModel?.header_subtitle != "1" {
//                                height += 20
//                            }
//                        }
//
//                        if(viewModel?.header_deal == "1" && dealEnd == false){
//                            height += 85;
//                        }
//                        if(viewModel?.header_subtitle == "1"){
//                            height += 30
//                        }
//                        layoutHeight[componentName] = height;
//                    }
//                    else {
//                        var size = (collection?.calculateHalfCellSize(numberOfColumns: 2.5, imagesize: imageSize ?? CGSize(width: 0, height: 0)))
//
//
//                        if(viewModel?.item_title == "1"){
//                            size!.height = size!.height + 35
//                        }
//                        if(viewModel?.item_price == "1"){
//                            size!.height = size!.height + 20
//                        }
//                        var height = size?.height ?? 0
//
//
//                        if viewModel?.numberOfRows == "2" {
//                            if productsArray.count <= 4 {
//                                height = height + 0
//                            } else {
//                                height = (2 * height)
//
//                            }
//                        }
//                        layoutHeight[componentName] = height + 30
//                    }
//                }
//            }
//            else
//            {
//                layoutHeight[componentName] = CGFloat(0.0)
//            }
//            tableView.reloadSections(IndexSet(arrayLiteral: index), with: .automatic)
//
//            //   tableView.reloadRows(at: [index], with: .automatic)
//        }
//        tableView.beginUpdates()
//        tableView.endUpdates()
//    }
//}


extension HomeViewController: HomeGridLayoutUpdate
{
    func updateLayoutAccordingToGrid(viewModel:HomeProductListSliderViewModel?,collection:UICollectionView?, productsArray: Array<ProductViewModel>!,componentName: String, index: Int, imageSize: CGSize?,reload:Bool,dealEnd: Bool){
        self.productsArray[index] = productsArray
//        self.imageHeight[componentName] = imageSize
        if layoutHeight[componentName] == nil || reload{
            if productsArray != nil {
                if(productsArray.count>0){
                    if viewModel?.header == "1" {
                        var height = (collection?.calculateHalfCellSizeOld(numberOfColumns: 2.5,of: 40).height ?? 0)
                        height += 40
                        if(viewModel?.item_title == "1"){
                            height = height + 35
                        }
                        if(viewModel?.item_price == "1"){
                            height = height + 20
                        }
                        
                        if viewModel?.numberOfRows == "2" {
                            if productsArray.count <= 4 {
                                height = height + 0
                            } else {
                                height = (2 * height) - 20
                                if viewModel?.header_subtitle != "1" {
                                    height += 20
                                }
                            }
                            
                        } else {
                            if viewModel?.header_subtitle != "1" {
                                height += 20
                            }
                        }
                        
                        if(viewModel?.header_deal == "1" && dealEnd == false){
                            height += 85;
                        }
                        if(viewModel?.header_subtitle == "1"){
                            height += 30
                        }
                        layoutHeight[componentName] = height;
                    }
                    else {
                   
                        var height = (collection?.calculateHalfCellSizeOld(numberOfColumns: 2.5,of: 40).height ?? 0)
                        
                        if(viewModel?.item_title == "1"){
                           height = height + 35
                        }
                        
                        if(viewModel?.item_price == "1"){
                            height = height + 20
                        }
                        
                        if viewModel?.numberOfRows == "2" {
                            if productsArray.count <= 4 {
                                height = height + 0
                            } else {
                                height = (2 * height)
                            }
                        }
                        
                        layoutHeight[componentName] = height + 30
                    }
                }
            }
            else
            {
                layoutHeight[componentName] = CGFloat(0.0)
            }
//            tableView.reloadSections(IndexSet(arrayLiteral: index), with: .automatic)
            
            //   tableView.reloadRows(at: [index], with: .automatic)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension HomeViewController:productClicked{
    
    func productCellClicked(product: ProductViewModel, sender: Any) {
        let productViewController     = ProductVC()//:ProductViewController = self.storyboard!.instantiateViewController()
        productViewController.product = product
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
}


extension HomeViewController:bannerClicked{
    
    func bannerDidSelect(banner: [String:String]?, sender: Any) {
        guard let banner = banner else {return}
        switch banner["link_type"]{
        case "products":
            let viewController=ProductVC()
            let str="gid://shopify/Product/"+((banner["link_value"])!)
            //let str1 = (str).data(using: String.Encoding.utf8)
            //let base64 = str1!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            viewController.productId = str
            viewController.isProductLoading = true
            self.navigationController?.pushViewController(viewController, animated: true)
        case "collections":
            let coll = collection(id: banner["link_value"], title: banner["link_type"])
            let vc = ProductListVC()
            vc.isfromHome = true
            if banner["title"] != nil{
                vc.pageTitle = banner["title"] ?? ""
            }
            else{
                vc.pageTitle = ""
            }
            vc.collect = coll
            self.navigationController?.pushViewController(vc, animated: true)
        case "list_collection":
            let coll = collection(id: banner["link_value"], title: banner["link_type"])
            print(coll)
            if customAppSettings.sharedInstance.showTabbar{
                self.parent?.tabBarController?.selectedIndex = 2;
            }else{
                let viewController = GetNavigation.shared.getCategoriesController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            print("webView")
            let urlString = banner["link_value"] ?? ""
            if urlString.isValidUrl(){
                let viewController:WebViewController = storyboard!.instantiateViewController()
                viewController.url = banner["link_value"]?.getURL()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension HomeViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: EmptyData.homeTitle)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: EmptyData.homeDesciption)
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return self.homeData?.email == ""
    }
}

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
}

extension HomeViewController: RecommendedProductsLayoutUpdate{
    func updateLayoutAccordingToGrid(collection: UICollectionView?, productsArray: Array<ProductViewModel>!, recommendedName: String) {
        if(productsArray.count>0){
            if  UIDevice.current.model.lowercased() == "ipad".lowercased() {
                layoutHeight[recommendedName] = (collection?.calculateHalfCellSize(numberOfColumns: 4.0, imagesize:  CGSize(width: 0, height: 0)).height ?? 0)
            }
            layoutHeight[recommendedName] = (collection?.calculateHalfCellSize(numberOfColumns: 2.3, imagesize:  CGSize(width: 0, height: 0)).height ?? 0) + 55
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension HomeViewController: CollectionSliderDelegateLayout{
    func updateLayoutAccordingToCollection(collection: UICollectionView?, productsArray: HomeCollectionListSliderViewModel!, componentName: String,index: Int) {
        //if layoutHeight[componentName] == nil {
        if(productsArray.items?.count ?? 0>0){
            let aspectRatio = 200.0/253.0
            var cellHeight = CGFloat((self.view.frame.width/2.3)/aspectRatio)
            if productsArray?.header == "1" {
                cellHeight += 30
                if(productsArray?.header_subtitle == "1"){
                    cellHeight += 30
                }
                layoutHeight[componentName] = cellHeight;
            }else {
                layoutHeight[componentName] = cellHeight
            }
        }
        else{
            layoutHeight[componentName] = CGFloat(0.0)
        }
//        tableView.reloadSections(IndexSet(arrayLiteral: index), with: .automatic)
        tableView.beginUpdates()
        tableView.endUpdates()
        //}
    }
}

//MARK: ------Static theme work------
extension HomeViewController {
    func checkForStaticThemeOption() {
        if Client.merchantID == "18" {
            if UserDefaults.standard.valueExists(forKey: "showThemeFirst") {
                floatingThemeButton?.isHidden = false
            }
            else {
                let vc = PreviewThemesController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false) //first time rediret to themeView
                UserDefaults.standard.setValue(true, forKey: "showThemeFirst")
            }
        }
    }
    
    func setupThemeSwitchBtn() {
        floatingThemeButton = UIButton()
        floatingThemeButton?.translatesAutoresizingMaskIntoConstraints = false
        floatingThemeButton?.backgroundColor = UIColor.AppTheme()
        floatingThemeButton?.setImage(UIImage(named: "themeIcon"), for: .normal)
        floatingThemeButton?.tintColor = UIColor.AppTheme()
        floatingThemeButton?.addTarget(self, action: #selector(showMoreThemes), for: .touchUpInside)
        floatingThemeButton?.setTitle("Themes".localized, for: .normal)
        floatingThemeButton?.semanticContentAttribute = .forceLeftToRight

        floatingThemeButton?.setupFont(fontType: .Medium, fontSize: 14.0)
        floatingThemeButton?.setTitleColor(UIColor.textColor(), for: .normal)
        floatingThemeButton?.layer.cornerRadius = 25.0
        self.view.addSubview(floatingThemeButton!)
        floatingThemeButton?.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        floatingThemeButton?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        floatingThemeButton?.heightAnchor.constraint(equalToConstant: 60).isActive = true
        floatingThemeButton?.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    /*
    
    func setupThemeView() {
       let tempView = UIView()
        tempView.backgroundColor = UIColor(light: .black.withAlphaComponent(0.5),dark: .white.withAlphaComponent(0.5))
        let themeView = SelectThemeView()
        themeView.dataSource = ["Grocery".localized,"MarketPlace".localized,"Fashion".localized]
        themeView.loadData()
        themeView.closeBtn.addTarget(self, action: #selector(dismissThemeView), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.dismissThemeView))
        tempView.addGestureRecognizer(tapGesture)
        tempView.tag = 45678
        self.view.addSubview(tempView)
        tempView.addSubview(themeView)
        tempView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor)
        themeView.anchor(top: tempView.topAnchor, left: tempView.leadingAnchor, bottom: tempView.bottomAnchor, right: tempView.trailingAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 30, paddingRight: 30)
        
        
        
    }
    
    @objc func dismissThemeView() {
        if let view = self.view.viewWithTag(45678) {
            view.removeFromSuperview()
            self.checkForStaticThemeOption()
        }
    }
    */
    
    @objc func showMoreThemes() {
        let vc = PreviewThemesController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
