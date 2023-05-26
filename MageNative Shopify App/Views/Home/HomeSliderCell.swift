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
import SwiftUI
protocol HomeCustomisableFixedLayoutUpdate {
    func updateLayoutAccording(viewModel:HomeFixedCustomisableLayoutViewModel?,collection:UICollectionView?,index:IndexPath,prodCount:Int,hasNewproduct:Bool, products: PageableArray<ProductListViewModel>!, imageSize: CGSize?, reload: Bool, dealEnd: Bool)
}


class HomeSliderCell: UITableViewCell {
    
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
//    @IBOutlet weak var dealLabel: UILabel!
//    @IBOutlet weak var dealImage: UIImageView!
    
    @IBOutlet weak var viewAllWidth: NSLayoutConstraint!
    @IBOutlet weak var dealView: DealView!
    
    var dealEnded = false;
    var delegateLayout:HomeCustomisableFixedLayoutUpdate?
    @IBOutlet weak var ViewAll: UIButton!
    @IBOutlet weak var viewAllButtonView: UIView!
    @IBOutlet weak var bottomHeaderSpaceView: UIView!
    @IBOutlet weak var topHeaderSpaceView: UIView!
    
    @IBOutlet weak var headerView: UIView!
    
    var dealtime = 100
    var timer = Timer()
    var startTime = TimeInterval()
    var timerStatus = String()
    var viewModel:HomeFixedCustomisableLayoutViewModel?
    var bannerdelegate:bannerClicked?
    var parentView = HomeViewController()
    var products: PageableArray<ProductListViewModel>!
    var delegate:productClicked?
    var indexPaths = IndexPath()
    var imageSize: CGSize = CGSize(width: 1, height: 1)
    
    @IBOutlet weak var headerStack: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        headerStack.isLayoutMarginsRelativeArrangement = true
        headerStack.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        runTimer()
    }
    func runTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true);
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageSize = CGSize(width: 1, height: 1)
        products = nil
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func configureFrom(_ viewModel:HomeFixedCustomisableLayoutViewModel?){
        collectionView.register(UINib(nibName: ProductListCollectionCell.className, bundle: nil), forCellWithReuseIdentifier: ProductListCollectionCell.className)
        //        collectionView.delegate = nil
        //        collectionView.dataSource = nil
        //        collectionView.reloadData()
        self.viewModel = viewModel
        collectionView.backgroundColor =  UIColor(light: viewModel?.panel_background_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        self.headerStackView.backgroundColor = UIColor(light: viewModel?.header_background_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        if(viewModel?.header == "1")
        {
            
            headerView.backgroundColor = UIColor(light: viewModel?.header_background_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
           // self.titleLabel.text = viewModel?.header_title_text
            let data = viewModel?.header_title_text ?? ""
            self.titleLabel.text = data
            self.titleLabel.textColor = UIColor(light: viewModel?.header_title_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
            self.titleLabel.font = mageFont.setFont(fontWeight: (viewModel?.header_title_font_weight)!, fontStyle: (viewModel?.item_header_font_style)!, fontSize: 15.0)
            if(Client.locale == "ar"){
                titleLabel.textAlignment = .right
                subtitleLabel.textAlignment = .right
                //dealLabel.textAlignment = .right
            }
            else{
                titleLabel.textAlignment = .left
                subtitleLabel.textAlignment = .left
                //dealLabel.textAlignment = .left
            }
            self.titleLabel.isHidden = false;
            self.headerStackView.isHidden = false;
            topHeaderSpaceView.isHidden = false;
            bottomHeaderSpaceView.isHidden = false;
            self.headerView.isHidden = false;
            self.headerView.backgroundColor = UIColor(light: viewModel?.header_background_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
            
            if(viewModel?.header_subtitle == "1"){
                self.subtitleLabel.isHidden = false;
                self.subtitleLabel.font = mageFont.setFont(fontWeight: (viewModel?.header_subtitle_font_weight)!, fontStyle: (viewModel?.header_subtitle_title_font_style)!, fontSize: 14.0)
                self.subtitleLabel.textColor = UIColor(light: viewModel?.header_subtitle_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
               // self.subtitleLabel.text = viewModel?.header_subtitle_text
                let data = viewModel?.header_subtitle_text ?? ""
                self.subtitleLabel.text = data
            }
            else{
                subtitleLabel.isHidden = true;
            }
            
            if(viewModel?.header_deal == "1")
            {
//                self.dealLabel.isHidden = false;
//                self.dealImage.isHidden = false;
                
                self.dealView.isHidden = false;
                self.dealView.dayTimerLabel.font = mageFont.setFont(fontWeight: (viewModel?.header_subtitle_font_weight)!, fontStyle: (viewModel?.header_subtitle_title_font_style)!, fontSize: 16.0)
                self.dealView.hourTimerLabel.font = mageFont.setFont(fontWeight: (viewModel?.header_subtitle_font_weight)!, fontStyle: (viewModel?.header_subtitle_title_font_style)!, fontSize: 16.0)
                self.dealView.minTimerLabel.font = mageFont.setFont(fontWeight: (viewModel?.header_subtitle_font_weight)!, fontStyle: (viewModel?.header_subtitle_title_font_style)!, fontSize: 16.0)
                self.dealView.secTimerLabel.font = mageFont.setFont(fontWeight: (viewModel?.header_subtitle_font_weight)!, fontStyle: (viewModel?.header_subtitle_title_font_style)!, fontSize: 16.0)
//                self.dealLabel.textColor = viewModel?.header_deal_color
//                self.dealImage.image = UIImage(named: "clock")?.withRenderingMode(.alwaysTemplate)
//                self.dealImage.tintColor = viewModel?.header_deal_color
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "MM/dd/yyyy HH:mm:ss"
                if let endDate = dateFormatter1.date(from: (viewModel?.item_deal_end_date)!){
                    if(endDate>Date()){
                        self.startTime = Double(Calendar.current.dateComponents([.second], from: Date(), to: endDate).second!)
                       // self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true);
                       // RunLoop.current.add(self.timer, forMode: .common)
                    }
                    else{
                        self.dealView.isHidden = true;
                        self.dealEnded = true;
                        if let _ = self.products{
                            self.delegateLayout?.updateLayoutAccording(viewModel: self.viewModel, collection: self.collectionView, index: self.indexPaths,prodCount:self.products.items.count,hasNewproduct:true, products: self.products, imageSize: self.imageSize,reload: true,dealEnd: true)
                        }
                        self.collectionView.dataSource = self
                        self.collectionView.delegate = self
                        self.collectionView.reloadData()
//                        self.dealLabel.isHidden = true;
//                        self.dealImage.isHidden = true;
//                        self.dealImage.image = nil
                    }
                }
            }
            else{
                self.dealView.isHidden = true;
                self.dealEnded = true;
//                self.dealLabel.isHidden = true;
//                self.dealImage.isHidden = true;
//                self.dealImage.image = nil
            }
            if(viewModel?.header_action == "1")
            {
                headerStack.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 120)
                self.viewAllButtonView.isHidden = false;
                self.ViewAll.isHidden = false;
                self.ViewAll.layer.borderWidth = 0.5
                self.ViewAll.layer.borderColor = UIColor.white.cgColor
            }
            else{
                headerStack.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                viewAllButtonView.isHidden = true;
                ViewAll.isHidden = true;
            }
        }
        else{
            self.headerStackView.isHidden = true;
            bottomHeaderSpaceView.isHidden = true;
            topHeaderSpaceView.isHidden = true;
            self.headerView.isHidden = true;
            self.subtitleLabel.isHidden = true;
            self.titleLabel.isHidden = true;
            self.dealView.isHidden = true;
//            self.dealLabel.isHidden = true;
//            self.dealImage.isHidden = true;
//            self.dealImage.image = nil
            self.viewAllButtonView.isHidden = true;
            self.ViewAll.isHidden = true;
        }
        //self.ViewAll.titleLabel?.font = mageFont.setFont(fontWeight: (viewModel?.header_action_font_weight)!, fontStyle: (viewModel?.header_action_title_font_style)!)
        let data = viewModel?.header_action_text ?? ""
        let text = data as NSString
        var width = 35.0
        width += data.size(withAttributes: [.font: mageFont.regularFont(size: 12)]).width
        self.ViewAll.setTitle(data, for: .normal)
        
//        viewAllWidth.constant = width
        self.ViewAll?.titleLabel?.adjustsFontSizeToFitWidth = true

        self.ViewAll?.titleLabel?.minimumScaleFactor = 0.5
        
        self.ViewAll.titleLabel?.font = mageFont.setFont(fontWeight: (viewModel?.header_title_font_weight)!, fontStyle: (viewModel?.header_action_title_font_style ?? "normal"))
        
        self.ViewAll.setTitleColor(UIColor(light:  viewModel?.header_action_color ?? .black,dark: .white) , for: .normal)
        self.ViewAll.backgroundColor =  UIColor(light: viewModel?.header_action_background_color ?? .clear, dark: .black)
        
        ViewAll.addTarget(self, action: #selector(viewAllClicked(_:)), for: .touchUpInside)
        //  if self.products == nil {
        if(products == nil){
//            loadProduct()
        }
        else{
            self.delegateLayout?.updateLayoutAccording(viewModel: self.viewModel, collection: self.collectionView, index: self.indexPaths,prodCount:self.products.items.count,hasNewproduct:false, products: self.products, imageSize: imageSize,reload: true, dealEnd: dealEnded)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
        }
        // }
    }
    
    @objc func update() {
        if(startTime>0){
            let time = NSInteger(startTime)
            let seconds = time % 60
            let minutes = (time / 60) % 60
            let hours = (time%(24*3600) / 3600)
            let days = (time/(24*3600))
            
            switch viewModel?.item_deal_format! {
            case let x where (x?.contains(":"))!:
              //  dealLabel.text = "  \(days)day:\(hours)h:\(minutes)m:\(seconds)s " + (viewModel?.item_deal_message ?? "")
                
                let data = (viewModel?.item_deal_message ?? "")
                self.dealView.dayTimerLabel.text = "\(days)"
                self.dealView.hourTimerLabel.text = "\(hours)"
                self.dealView.minTimerLabel.text = "\(minutes)"
                self.dealView.secTimerLabel.text = "\(seconds)"
                self.dealView.dealMessageLabel.text = data
                
            case let x where (x?.contains("/"))!:
             //   dealLabel.text = "  \(days)day/\(hours)h/\(minutes)m/\(seconds)s " + (viewModel?.item_deal_message ?? "")
                let data = (viewModel?.item_deal_message ?? "")
                self.dealView.dayTimerLabel.text = "\(days)"
                self.dealView.hourTimerLabel.text = "\(hours)"
                self.dealView.minTimerLabel.text = "\(minutes)"
                self.dealView.secTimerLabel.text = "\(seconds)"
                self.dealView.dealMessageLabel.text = data
            default:
                let data = (viewModel?.item_deal_message ?? "")
                self.dealView.dayTimerLabel.text = "\(days)"
                self.dealView.hourTimerLabel.text = "\(hours)"
                self.dealView.minTimerLabel.text = "\(minutes)"
                self.dealView.secTimerLabel.text = "\(seconds)"
                self.dealView.dealMessageLabel.text = data
            }
            startTime = startTime - 0.5
        }
        else{
            let data = (viewModel?.item_deal_message) ?? ""
            self.dealView.dealMessageLabel.text = data
        }
    }
    
    @objc func viewAllClicked(_ sender: UIButton){
        print("yash")
        //var  collectionid = collection(id: "1", title: "1")
        if let collectionID = viewModel?.items?[0]["link_value"] as? String {
            //collectionid = collection(id: collectionID, title: "All")
            if(collectionID=="all_collection"){
                self.bannerdelegate?.bannerDidSelect(banner: ["link_type":"list_collection","link_value":collectionID], sender: sender)
            }
            else{
                self.bannerdelegate?.bannerDidSelect(banner: ["link_type":"collections","link_value":collectionID], sender: sender)
            }
        }
    }
    
    func loadProduct(cursor:String?=nil){
        var  collectionid = collection(id: "1", title: "1")
        if let collectionID = viewModel?.items?[0]["link_value"] as? String {
            collectionid = collection(id: collectionID, title: "All")
        }
        ViewAll.addTarget(self, action: #selector(viewAllClicked(_:)), for: .touchUpInside)
        //collectionid = collection(id: "94754078816", title: "All Products")
        if(viewModel?.item_layout_type == "grid")
        {
            switch viewModel?.item_row {
            case "3","2","1","infinite":
                
                Client.shared.searchProductsForQuery(for:  viewModel?.queryString ?? "",ids: viewModel?.productIds ?? [String](), limit: viewModel?.productIds?.count ?? 0, completion: {
                    [weak self] response,ad  in
                    DispatchQueue.main.async {
                        if let response = response {
                            self?.products = response
                            DispatchQueue.global(qos: .userInitiated).async {
                                if(self?.imageSize == CGSize(width: 1, height: 1)){
                                    if let _ = self!.products{
                                        if(self!.products.items.count>0){
                                            if let url = self!.products.items.first?.images.items.first!.url, let size = ImageSize.shared.sizeOfImageAt(url: url){
                                                self!.imageSize=size
                                                
                                                DispatchQueue.main.async {
                                                    self?.delegateLayout?.updateLayoutAccording(viewModel: self?.viewModel, collection: self?.collectionView, index: self!.indexPaths,prodCount:self!.products.items.count ,hasNewproduct:false, products: self!.products, imageSize: self!.imageSize,reload: true, dealEnd: self!.dealEnded)
                                                    self?.collectionView.dataSource = self
                                                    self?.collectionView.delegate = self
                                                    self?.collectionView.reloadData()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            self?.delegateLayout?.updateLayoutAccording(viewModel: self?.viewModel, collection: self?.collectionView, index: self!.indexPaths,prodCount:self?.products.items.count ?? 0,hasNewproduct:false, products: self!.products, imageSize: self!.imageSize,reload: false, dealEnd: self!.dealEnded)
                            self?.collectionView.dataSource = self
                            self?.collectionView.delegate = self
                            self?.collectionView.reloadData()
                        }
                    }
                })
            default:
                Client.shared.fetchProducts(coll:collectionid,after:cursor, completion: {
                    [weak self] response,image,error,handle    in
                    DispatchQueue.main.async {
                        if let response = response {
                            
                            if cursor != nil {
                                
                                self?.products.appendPage(from: response)
                                DispatchQueue.global(qos: .userInitiated).async {
                                    if(self?.imageSize == CGSize(width: 1, height: 1)){
                                        if let _ = self!.products{
                                            if(self!.products.items.count>0){
                                                if let url = self!.products.items.first?.images.items.first!.url, let size = ImageSize.shared.sizeOfImageAt(url: url){
                                                    self!.imageSize=size
                                                    DispatchQueue.main.async {
                                                        self?.delegateLayout?.updateLayoutAccording(viewModel: self?.viewModel, collection: self?.collectionView, index: self!.indexPaths,prodCount:self?.products.items.count ?? 0,hasNewproduct:true, products: self!.products, imageSize: self!.imageSize,reload: true,dealEnd: self!.dealEnded)
                                                        self?.collectionView.dataSource = self
                                                        self?.collectionView.delegate = self
                                                        self?.collectionView.reloadData()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                
                                self?.delegateLayout?.updateLayoutAccording(viewModel: self?.viewModel, collection: self?.collectionView, index: self!.indexPaths,prodCount:self?.products.items.count ?? 0,hasNewproduct:true, products: self!.products, imageSize: self!.imageSize,reload: false,dealEnd: self!.dealEnded)
                                self?.collectionView.dataSource = self
                                self?.collectionView.delegate = self
                                self?.collectionView.reloadData()
                            }
                            else {
                                self?.products = response
                                DispatchQueue.global(qos: .userInitiated).async {
                                    if(self?.imageSize == CGSize(width: 1, height: 1)){
                                        if let _ = self!.products{
                                            if(self!.products.items.count>0){
                                                if let url = self!.products.items.first?.images.items.first!.url, let size = ImageSize.shared.sizeOfImageAt(url: url){
                                                    self!.imageSize=size
                                                    DispatchQueue.main.async {
                                                        self!.delegateLayout?.updateLayoutAccording(viewModel: self?.viewModel, collection: self?.collectionView, index: self!.indexPaths,prodCount:self?.products.items.count ?? 0,hasNewproduct:false, products: self!.products, imageSize: self!.imageSize,reload:true,dealEnd: self!.dealEnded)
                                                        self?.collectionView.dataSource = self
                                                        self?.collectionView.delegate   = self
                                                        self?.collectionView.reloadData()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                self?.delegateLayout?.updateLayoutAccording(viewModel: self?.viewModel, collection: self?.collectionView, index: self!.indexPaths,prodCount:self?.products.items.count ?? 0,hasNewproduct:false, products: self!.products, imageSize: self!.imageSize,reload:false, dealEnd: self!.dealEnded)
                            }
                            self?.collectionView.dataSource = self
                            self?.collectionView.delegate = self
                            self?.collectionView.reloadData()
                        }
                        else {
                            self?.parentView.showErrorAlert(error: error?.localizedDescription)
                        }
                    }
                })
            }
        }
        else{
           
            Client.shared.searchProductsForQuery(for:  viewModel?.queryString ?? "",ids: viewModel?.productIds ?? [String](), limit: viewModel?.productIds?.count ?? 0, completion: {
                [weak self] response,ad  in
                DispatchQueue.main.async {
                    if let response = response {
                        self?.products = response
                        DispatchQueue.global(qos: .userInitiated).async {
                            
                            if(self?.imageSize == CGSize(width: 1, height: 1)){
                                if let _ = self!.products{
                                    if(self!.products.items.count>0){
                                        if let url = self!.products.items.first?.images.items.first!.url, let size = ImageSize.shared.sizeOfImageAt(url: url){
                                            self!.imageSize=size
                                            DispatchQueue.main.async {
                                                self!.delegateLayout?.updateLayoutAccording(viewModel: self?.viewModel, collection: self?.collectionView, index: self!.indexPaths,prodCount:self!.products.items.count ,hasNewproduct:false, products: self!.products, imageSize: self!.imageSize,reload:true,dealEnd: self!.dealEnded)
                                                self?.collectionView.dataSource = self
                                                self?.collectionView.delegate = self
                                                self?.collectionView.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        self?.delegateLayout?.updateLayoutAccording(viewModel: self?.viewModel, collection: self?.collectionView, index: self!.indexPaths,prodCount:self?.products.items.count ?? 0,hasNewproduct:false, products: self!.products, imageSize: self!.imageSize,reload:false,dealEnd: self!.dealEnded)
                        self?.collectionView.dataSource = self
                        self?.collectionView.delegate = self
                        self?.collectionView.reloadData()
                    }
                }
            })
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HomeSliderCell:UICollectionViewDelegate {
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.productCellClicked(product: (products.items[indexPath.row].model?.node.viewModel)!, sender: self)
    }
    
    func loadMoreproducts() {
        if self.products?.hasNextPage ?? false {
            loadProduct(cursor: self.products.items.last?.cursor)
        }
    }
    
}

extension HomeSliderCell:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(viewModel?.item_layout_type == "list")
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCollectionCell.className, for: indexPath) as! ProductListCollectionCell
            cell.priceColor =  UIColor(light: (viewModel?.item_price_color)!, dark: .white)
            cell.priceFont = mageFont.setFont(fontWeight: (viewModel?.item_price_font_weight)!, fontStyle: (viewModel?.item_price_font_style)!)
//            cell.priceFont = mageFont.setFont(fontWeight: "bold", fontStyle: (viewModel?.item_price_font_style)!)
            cell.specialPriceColor = (viewModel?.item_compare_at_price_color)!
            if(viewModel?.item_title != "1")
            {
                cell.productName.isHidden = true;
            }
            else
            {
                cell.productName.isHidden = false;
                cell.itemNameFont = mageFont.setFont(fontWeight: (viewModel?.item_title_font_weight)!, fontStyle: (viewModel?.item_title_font_style)!)
                
                cell.itemTitleColor = UIColor(light: (viewModel?.item_title_color)!, dark: .white)
            }
            if(viewModel?.item_price != "1")
            {
                cell.productPrice.isHidden = true;
            }
            else
            {
                cell.productPrice.isHidden = false;
            }
            if(viewModel?.item_compare_at_price != "1")
            {
                cell.specialPriceHide = true;
            }
            else
            {
                cell.specialPriceHide = false;
//                cell.specialPriceFont = mageFont.setFont(fontWeight: (viewModel?.item_compare_at_price_font_weight)!, fontStyle: (viewModel?.item_compare_at_price_font_style)!)
                cell.specialPriceFont = mageFont.setFont(fontWeight: "light", fontStyle: (viewModel?.item_compare_at_price_font_style)!)
            }
            switch viewModel?.item_text_alignment {
            case .center :
                cell.productPrice.textAlignment = .center
                cell.productName.textAlignment = .center
            case .right :
                cell.productPrice.textAlignment = Client.locale == "ar" ? .left : .right
                cell.productName.textAlignment = Client.locale == "ar" ? .left : .right
            default :
                cell.productPrice.textAlignment = Client.locale == "ar" ? .right : .left
                cell.productName.textAlignment = Client.locale == "ar" ? .right : .left
            }
            cell.cellView.backgroundColor =  UIColor(light: viewModel?.cell_background_color ?? .black, dark: .black)
            
            if(viewModel?.item_border == "1"){
                cell.layer.borderColor = UIColor(light: viewModel?.item_border_color ?? .white,dark: DarkColor.darkBorderColor).cgColor
                cell.layer.borderWidth = 1;
            }
            if(viewModel?.item_shape == "rounded"){
               
                cell.cardView()
                cell.layer.cornerRadius = 5;
                cell.productImage.layer.cornerRadius = 5
                cell.productImage.clipsToBounds = true;
            }
            else{
                cell.layer.cornerRadius = 0;
                cell.productImage.layer.cornerRadius = 0
                cell.productImage.clipsToBounds = true;
            }
            cell.setupView((products.items[indexPath.item].model?.node.viewModel)!)
            cell.productImage.contentMode = .scaleAspectFit
            return cell
        }
        else
        {
            let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
            cell.isFromHome=true
            if(viewModel?.item_title != "1")
            {
                cell.productName.isHidden = true;
            }
            else
            {
                cell.productName.isHidden = false;
                cell.itemTitleColor = UIColor(light: (viewModel?.item_title_color)!, dark: .white)
                cell.itemNameFont = mageFont.setFont(fontWeight: (viewModel?.item_title_font_weight)!, fontStyle: (viewModel?.item_title_font_style)!)
            }
            if(viewModel?.item_price != "1")
            {
                cell.productPrice.isHidden = true;
            }
            else{
                cell.productPrice.isHidden = false;
                cell.priceColor = UIColor(light: (viewModel?.item_price_color)!, dark: .white)
                cell.priceFont = mageFont.setFont(fontWeight: (viewModel?.item_price_font_weight)!, fontStyle: (viewModel?.item_price_font_style)!)
            }
            if(viewModel?.item_compare_at_price != "1")
            {
                cell.specialPriceHide = true;
            }
            else
            {
                cell.specialPriceHide = false;
                cell.specialPriceColor = (viewModel?.item_compare_at_price_color)!
//                cell.specialPriceFont = mageFont.setFont(fontWeight: (viewModel?.item_compare_at_price_font_weight)!, fontStyle: (viewModel?.item_compare_at_price_font_style)!)
                cell.specialPriceFont = mageFont.setFont(fontWeight: "light", fontStyle: (viewModel?.item_compare_at_price_font_style)!)
            }
            cell.productPrice.textAlignment = viewModel?.item_text_alignment ?? .natural
            cell.productName.textAlignment = viewModel?.item_text_alignment ?? .natural
            cell.backgroundColor = UIColor(light: viewModel?.cell_background_color ?? .white, dark: .black)
            
            if(viewModel?.item_border == "1"){
                cell.layer.borderColor = UIColor(light: viewModel?.item_border_color ?? .white,dark: DarkColor.darkBorderColor).cgColor
                
                cell.layer.borderWidth = 1;
            }
            else
            {
                cell.layer.borderWidth = 0;
            }
            if(viewModel?.item_shape == "rounded"){
                cell.cardView()
                cell.layer.cornerRadius = 5;
                cell.productImage.layer.cornerRadius = 5
                cell.productImage.clipsToBounds = true;
            }
            else{
                cell.layer.cornerRadius = 0;
                cell.productImage.layer.cornerRadius = 0
                cell.productImage.clipsToBounds = true;
            }
            cell.setupView((products.items[indexPath.row].model?.node.viewModel)!)
            cell.productImage.contentMode = .scaleAspectFit
            return cell
        }
    }
    
    func setupCell<T>(cell: T){}
}

extension HomeSliderCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(viewModel?.item_layout_type == "grid")
        {
            //return collectionView.calculateCellSize(numberOfColumns: Int(viewModel?.item_in_a_row ?? "") ?? 3,of: 80)//CGSize(width: collectionView.frame.width/2, height: 150 )
//            var size = collectionView.calculateCellSize(numberOfColumns: Int(viewModel?.item_in_a_row ?? "") ?? 3,of: 80, imagesize: imageSize)
            var size = collectionView.calculateCellSizeOld(numberOfColumns: Int(viewModel?.item_in_a_row ?? "") ?? 3,of: 70)//CGSize(width:
            print(size)
            size.height += 10
            if(viewModel?.item_title == "1"){
                size.height = size.height + 25
            }
            if(viewModel?.item_price == "1"){
                size.height = size.height + 15
            }
           // let s2 = CGSize(width: size.width, height: size.height-60)
            return size
        }
        else
        {
            return collectionView.calculateVerticalCellSizeOld(numberOfColumns: 1,of: 100)//CGSize(width: collectionView.frame.width/2, height: 150 )
        }
        //}
    }
}

extension HomeSliderCell:wishListDelegate{
    func addToWishListProduct(_ cell: ProductCollectionViewCell, didAddToWishList sender: Any) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else {return}
        let product = self.products.items[indexPath.row]
        guard let productModel = product.model?.node.viewModel else {return}
        let wishProduct = CartProduct.init(product: productModel, variant: WishlistManager.shared.getVariant(product.variants.items.first!))
    
        if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct){
            WishlistManager.shared.removeFromWishList(wishProduct)
        }
        else {
            WishlistManager.shared.addToWishList(wishProduct)
        }
        parentView.setupTabbarCount()
        parentView.setupNavBarCount()
        self.collectionView.reloadItems(at: [indexPath])
    }
}
