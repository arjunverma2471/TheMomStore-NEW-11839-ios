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

protocol HomeGridLayoutUpdate {
    func updateLayoutAccordingToGrid(viewModel:HomeProductListSliderViewModel?,collection:UICollectionView?, productsArray: Array<ProductViewModel>!,componentName: String, index: Int, imageSize: CGSize?,reload:Bool,dealEnd: Bool)
}

class HomeGridCell: UITableViewCell {
    
    @IBOutlet weak var headerViewBackgroundColor: UIView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ViewAll: UIButton!
    @IBOutlet weak var topHeaderSpaceView: UIView!
    @IBOutlet weak var bottomHeaderSpaceView: UIView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var subtitleLabel: UILabel!
    var bannerDelegate: bannerClicked?
    @IBOutlet weak var viewAllView: UIView!
    var parentView = HomeViewController()
    
    //@IBOutlet weak var dealLabel: UILabel!
    //@IBOutlet weak var dealImage: UIImageView!
    
    @IBOutlet weak var dealView: DealView!
    let value = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
    
    var componentName: String?
    var limit:Int!
    var dealtime = 100
    var timer = Timer()
    var startTime = TimeInterval()
    var timerStatus = String()
    var dealEnded = false
    var products: Array<ProductViewModel>!
    var gridDelegate: HomeGridLayoutUpdate?
    var viewModel:HomeProductListSliderViewModel?
    var index = 0
    var imageSize: CGSize = CGSize(width: 1, height: 1)
    
    @IBOutlet weak var headerStack: UIStackView!
    
    @IBOutlet weak var collectionImageView: UIImageView!
    
    var delegate:productClicked?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        runTimer()
        headerStack.isLayoutMarginsRelativeArrangement = true
    }
    
    func runTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true);
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        products = nil
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    @objc func viewAllClicked(_ sender: UIButton){
        //var  collectionid = collection(id: "1", title: "1")
        let collectionID = viewModel?.item_link_action_value!
        //collectionid = collection(id: collectionID, title: "All")
        self.bannerDelegate?.bannerDidSelect(banner: ["link_type":"collections","link_value":collectionID!], sender: sender)
    }
    
    func loadProducts(sortKey:MobileBuySDK.Storefront.ProductCollectionSortKeys? = MobileBuySDK.Storefront.ProductCollectionSortKeys.created,cursor: String? = nil,reverse:Bool? = true){
        
        let fetchProductsBlock = { [weak self] (products: [ProductViewModel]) in
            DispatchQueue.main.async {
                self?.gridDelegate?.updateLayoutAccordingToGrid(viewModel: self?.viewModel, collection: self?.collectionView, productsArray: products, componentName: self?.componentName ?? "", index: self?.index ?? Int(), imageSize: self?.imageSize, reload: true, dealEnd: self?.dealEnded ?? Bool())
                self?.collectionView.delegate = self
                self?.collectionView.dataSource = self
                self?.collectionView.reloadData()
            }
        }
        
//        DispatchQueue.global(qos: .background).async {
            if let linkActionValue = self.viewModel?.item_link_action_value, !linkActionValue.isEmpty {
                Client.shared.fetchProducts(coll: collection(id: linkActionValue, title: self.viewModel?.type), sortKey: sortKey, reverse: reverse, after: cursor) { (products, _, _, _) in
                    guard let products = products else { return }
                    let productsArray = products.items.compactMap { $0.model?.node.viewModel as? ProductViewModel }
                    let limitedProducts = Array(productsArray.prefix(10))
                    fetchProductsBlock(limitedProducts)
                }
            } else {
                Client.shared.fetchShopAllProducts(after: cursor, with: MobileBuySDK.Storefront.ProductSortKeys.createdAt, reverse: reverse) { (products) in
                    guard let products = products else { return }
                    let productsArray = products.items.compactMap { $0.model?.node.viewModel as? ProductViewModel }
                    let limitedProducts = Array(productsArray.prefix(10))
                    fetchProductsBlock(limitedProducts)
                }
            }
//        }
    }

    func configureFrom(_ viewmodel:HomeProductListSliderViewModel?){
        self.viewModel = viewmodel
        self.contentView.backgroundColor = UIColor(light: viewModel?.cell_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        self.subtitleLabel.numberOfLines = 2
      
        if(products == nil){
//
//            if viewmodel?.linking == "newest_first" {
//                    self.loadProducts()
//            }else{
//                var graphIds = [GraphQL.ID]()
//                for index in viewModel?.item_value ?? [String](){
//                    let str="gid://shopify/Product/"+index
//                    let graphId = GraphQL.ID(rawValue: str)
//                    graphIds.append(graphId)
//                }
//                Client.shared.fetchMultiProducts(ids: graphIds, completion: { [weak self](response, error) in
//                    if let response = response {
//                        self?.products=[]
//                        self?.products = response
//                        DispatchQueue.main.async {
//                            self!.gridDelegate?.updateLayoutAccordingToGrid(viewModel: self?.viewModel, collection: self?.collectionView, productsArray: self?.products, componentName: self?.componentName! ?? "", index: self?.index ?? 0, imageSize: self!.imageSize,reload: true, dealEnd: self!.dealEnded)
//                            self?.collectionView.dataSource = self
//                            self?.collectionView.delegate = self
//                            self?.collectionView.reloadData()
//                        }
//                    }else {
//                        self?.parentView.showErrorAlert(error: error?.localizedDescription)
//                    }
//                })
//            }
        }
        else{
            self.gridDelegate?.updateLayoutAccordingToGrid(viewModel: self.viewModel, collection: self.collectionView, productsArray: self.products, componentName: self.componentName!, index: self.index, imageSize: self.imageSize,reload: false, dealEnd: self.dealEnded)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
        }
        /*viewmodel?.panel_background_color*/
        self.backgroundColor = UIColor(light: viewmodel?.panel_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        
        collectionView.backgroundColor = UIColor(light: viewmodel?.panel_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        self.contentView.backgroundColor = UIColor(light: viewmodel?.panel_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        
        if(viewmodel?.header == "1")
        {
            let data = viewmodel?.header_title_text ?? ""
            self.titleView.text = data
            self.titleView.textColor = UIColor(light: viewmodel?.header_title_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
            self.headerStackView.backgroundColor = UIColor(light: viewmodel?.header_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
            
            //self.dealLabel.textColor = viewmodel?.header_deal_color
            
            if value[0] == "ar"{
                titleView.textAlignment = .right
                subtitleLabel.textAlignment = .right
            }else{
                titleView.textAlignment = .left
                subtitleLabel.textAlignment = .left
            }
            
            self.titleView.font = mageFont.setFont(fontWeight: (viewModel?.item_header_font_weight)!, fontStyle: (viewmodel?.item_header_font_style)!, fontSize: 15.0)
            self.headerStackView.isHidden = false;
            self.topHeaderSpaceView.isHidden = false;
            self.bottomHeaderSpaceView.isHidden = false;
            self.headerViewBackgroundColor.isHidden = false;
            self.headerViewBackgroundColor.backgroundColor = UIColor(light: viewmodel?.header_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
            self.titleView.isHidden = false;
            if(viewmodel?.header_subtitle == "1"){
                self.subtitleLabel.isHidden = false;
                self.subtitleLabel.font = mageFont.setFont(fontWeight: (viewmodel?.header_subtitle_font_weight)!, fontStyle: (viewmodel?.header_subtitle_title_font_style)!, fontSize: 14.0)
                //  self.subtitleLabel.text = viewmodel?.header_subtitle_text
                let data = viewmodel?.header_subtitle_text ?? ""
                self.subtitleLabel.text = data
                
                self.subtitleLabel.textColor = UIColor(light: viewmodel?.header_subtitle_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
            }
            else{
                self.subtitleLabel.isHidden = true;
            }
            if(viewmodel?.header_deal == "1")
            {
                self.dealView.dayTimerLabel.font = mageFont.setFont(fontWeight: (viewmodel?.header_subtitle_font_weight)!, fontStyle: (viewmodel?.header_subtitle_title_font_style)!, fontSize: 16.0)
                self.dealView.hourTimerLabel.font = mageFont.setFont(fontWeight: (viewmodel?.header_subtitle_font_weight)!, fontStyle: (viewmodel?.header_subtitle_title_font_style)!, fontSize: 16.0)
                self.dealView.minTimerLabel.font = mageFont.setFont(fontWeight: (viewmodel?.header_subtitle_font_weight)!, fontStyle: (viewmodel?.header_subtitle_title_font_style)!, fontSize: 16.0)
                self.dealView.secTimerLabel.font = mageFont.setFont(fontWeight: (viewmodel?.header_subtitle_font_weight)!, fontStyle: (viewmodel?.header_subtitle_title_font_style)!, fontSize: 16.0)
                self.dealView.isHidden = false;
                //self.dealImage.image = UIImage(named: "clock")?.withRenderingMode(.alwaysTemplate)
                //self.dealImage.tintColor = viewmodel?.header_deal_color
                //self.dealImage.isHidden = false;
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "MM/dd/yyyy HH:mm:ss"
                if let endDate = dateFormatter1.date(from: (viewmodel?.item_deal_end_date)!){
                    //print("--end--",endDate)
                    //print(viewmodel?.item_deal_end_date)
                    print(endDate)
                    if(endDate>Date()){
                        print(Calendar.current.dateComponents([.second], from: Date(), to: endDate))
                        self.startTime = Double(Calendar.current.dateComponents([.second], from: Date(), to: endDate).second!)
                        self.dealEnded = false
                        // self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true);
                        // RunLoop.current.add(self.timer, forMode: .common)
                    }
                    else{
                        self.dealView.isHidden = true
                        self.dealEnded = true
                        self.gridDelegate?.updateLayoutAccordingToGrid(viewModel: self.viewModel, collection: self.collectionView, productsArray: self.products, componentName: self.componentName! , index: self.index , imageSize: self.imageSize,reload: true, dealEnd: dealEnded)
                        self.collectionView.dataSource = self
                        self.collectionView.delegate = self
                        self.collectionView.reloadData()
                        //self.dealImage.isHidden = true;
                        //dealLabel.isHidden = true;
                        //self.dealImage.image = nil
                    }
                }
            }
            else
            {
                self.dealView.isHidden = true
                self.dealEnded = true;
                //                self.dealImage.isHidden = true;
                //                dealLabel.isHidden = true;
                //                self.dealImage.image = nil
            }
            
            if(viewmodel?.header_action == "1")
            {
                self.viewAllView.isHidden = false;
                self.ViewAll.layer.borderWidth = 0.5
                self.ViewAll.layer.borderColor = UIColor.white.cgColor
                
                
                self.ViewAll.isHidden = false;
                self.ViewAll.addTarget(self, action: #selector(viewAllClicked(_:)), for: .touchUpInside)
                //   self.ViewAll.setTitle(viewmodel?.header_action_text, for: .normal)
                let data = viewmodel?.header_action_text ?? ""
                self.ViewAll.setTitle(data, for: .normal)
                self.ViewAll.setTitleColor(UIColor(light: viewmodel?.header_action_color ?? .black,dark: .white) , for: .normal)
                self.ViewAll.backgroundColor =  UIColor(light: viewmodel?.header_action_background_color ?? .clear, dark: .clear)
                headerStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 110)
            }
            else{
                headerStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.viewAllView.isHidden = true;
                self.ViewAll.isHidden = true;
            }
        }
        else{
            self.headerStackView.isHidden = true;
            self.topHeaderSpaceView.isHidden = true;
            self.bottomHeaderSpaceView.isHidden = true;
            self.headerViewBackgroundColor.isHidden = true;
            self.subtitleLabel.isHidden = true;
            self.titleView.isHidden = true;
            self.dealView.isHidden = true
            //            self.dealImage.isHidden = true;
            //            dealLabel.isHidden = true;
            //            self.dealImage.image = nil
            self.viewAllView.isHidden = true;
            self.ViewAll.isHidden = true;
        }
        self.ViewAll.titleLabel?.font = mageFont.setFont(fontWeight: (viewmodel?.header_action_font_weight)!, fontStyle: (viewmodel?.header_action_font_style)!)
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
                let data = (viewModel?.item_deal_message ?? "")
                self.dealView.dayTimerLabel.text = "\(days)"
                self.dealView.hourTimerLabel.text = "\(hours)"
                self.dealView.minTimerLabel.text = "\(minutes)"
                self.dealView.secTimerLabel.text = "\(seconds)"
                self.dealView.dealMessageLabel.text = data
                
            case let x where (x?.contains("/"))!:
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HomeGridCell:UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
        cell.isFromHome=true
        cell.delegate = self
        cell.priceColor = UIColor(light: (viewModel?.item_price_color)!,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
        cell.specialPriceColor = (viewModel?.item_compare_at_price_color)!
        if(viewModel?.item_title != "1")
        {
            cell.productName.isHidden = true;
        }
        else{
            cell.productName.isHidden = false;
            cell.itemNameFont = mageFont.setFont(fontWeight: (viewModel?.item_title_font_weight)!, fontStyle: (viewModel?.item_title_font_style)!)
            cell.itemTitleColor = UIColor(light: (viewModel?.item_title_color)!,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
        }
        if(viewModel?.item_price != "1")
        {
            cell.productPrice.isHidden = true;
        }
        else{
            cell.productPrice.isHidden = false;
            cell.priceFont = mageFont.setFont(fontWeight: (viewModel?.item_price_font_weight)!, fontStyle: (viewModel?.item_price_font_style)!)
        }
        if(viewModel?.item_compare_at_price != "1")
        {
            cell.specialPriceHide = true;
        }
        else{
            cell.specialPriceHide = false;
            cell.specialPriceFont = mageFont.setFont(fontWeight: "light", fontStyle: (viewModel?.item_compare_at_price_font_style)!)
//            cell.specialPriceFont = mageFont.setFont(fontWeight: (viewModel?.item_compare_at_price_font_weight)!, fontStyle: (viewModel?.item_compare_at_price_font_style)!)
        }
        switch viewModel?.item_alignment {
        case "center":
            cell.productName.textAlignment = .center
            cell.productPrice.textAlignment = .center
        case "right":
            cell.productName.textAlignment = .right
            cell.productPrice.textAlignment = .right
        default:
            cell.productName.textAlignment = .natural
            cell.productPrice.textAlignment = .natural
        }
        cell.gridCellCheck = true;
        cell.setupView((products[indexPath.row].model?.viewModel)!)
        
        cell.backgroundColor = UIColor(light: viewModel?.cell_background_color ?? .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        if(viewModel?.item_border == "1"){
            cell.layer.borderColor = UIColor(light: viewModel?.item_border_color ?? .white,dark: DarkColor.darkBorderColor).cgColor
            cell.layer.borderWidth = 1;
        }else{
            cell.layer.borderWidth = 0;
        }

        if viewModel?.item_border != "1" || viewModel?.item_shape == "rounded"{
            if viewModel?.item_shape == "rounded"{
                cell.cardView()
                cell.layer.cornerRadius = 10;
                cell.productImage.layer.cornerRadius = 10
                cell.productImage.layer.masksToBounds = true
                cell.productImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.productImage.clipsToBounds = true;
            }else{
                cell.removeCardView()
                cell.layer.cornerRadius = 0;
                cell.productImage.layer.cornerRadius = 0
            }
        }else{
            cell.removeCardView()
            cell.layer.cornerRadius = 0;
            cell.productImage.layer.cornerRadius = 0
        }
        
        cell.productImage.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
        return cell
    }
}

extension HomeGridCell:wishListDelegate{
    func addToWishListProduct(_ cell: ProductCollectionViewCell, didAddToWishList sender: Any) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else {return}
        let product = self.products[indexPath.row]
        guard let productModel = product.model?.viewModel else {return}
        let wishProduct = CartProduct.init(product:productModel , variant: WishlistManager.shared.getVariant(product.variants.items.first!))
        
        if WishlistManager.shared.isProductVariantinWishlist(product: wishProduct){
            WishlistManager.shared.removeFromWishList(wishProduct)
        }
        else {
            WishlistManager.shared.addToWishList(wishProduct)
        }
        parentView.setupNavBarCount()
        parentView.setupTabbarCount()
        self.collectionView.reloadItems(at: [indexPath])
    }
}

extension HomeGridCell:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.productCellClicked(product: (products[indexPath.row].model?.viewModel)!, sender: self)
    }
}

extension HomeGridCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionView.calculateHalfCellSizeOld(numberOfColumns: 2.5,of:40)
        
        if(viewModel?.item_title == "1"){
            size.height = size.height + 35
        }
        if(viewModel?.item_price == "1"){
            size.height = size.height + 20
        }
        return size
    
//        return collectionView.calculateHalfCellSizeOld(numberOfColumns: 2.5)
    }
}

