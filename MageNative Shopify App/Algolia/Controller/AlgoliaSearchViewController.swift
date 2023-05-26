//
//  SearchViewController.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 17/03/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import UIKit
import MLKit
import ChatSDK
import MessagingSDK
import Speech
import AlgoliaSearchClient
import RxSwift
class AlgoliaSearchViewController: UIViewController,ProductAddProtocol, SFSpeechRecognizerDelegate{
    
    func productAdded() {
        self.setupTabbarCount()
    }
    var disposeBag = DisposeBag()
    var addView: UIView!
    private lazy var voiceBtn: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false;
        return button;
    }()
    fileprivate lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false;
        return search
    }()
    fileprivate lazy var productsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: AlgoliaProductNewCell.className, bundle: nil), forCellWithReuseIdentifier: AlgoliaProductNewCell.className)
        collectionView.register(UINib(nibName: AlgoliaCollectionCell.className, bundle: nil), forCellWithReuseIdentifier: AlgoliaCollectionCell.className)
        return collectionView
    }()
    
    fileprivate var collections: PageableArray<CollectionViewModel>!
    fileprivate var products: PageableArray<ProductListViewModel>!
    var searchedData = [[String:String]]()
    var datasourceArray = [String]()
    var imageLabeler: ImageLabeler?
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Categories".localized
        self.navigationItem.title = "SEARCH YOUR PRODUCTS".localized
        //  self.title = "SEARCH YOUR PRODUCTS".localized
        searchBar.placeholder = "Search for products and more..".localized
        view.backgroundColor = .white
        productsCollectionView.delegate = self;
        productsCollectionView.dataSource = self;
        searchBar.delegate = self;
        let imageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageButton.setImage(UIImage(named: "camera"), for: .normal);
        imageButton.imageView?.contentMode = .scaleAspectFit
        imageButton.tintColor = UIColor.black
        
        imageButton.addTarget(self, action: #selector(imageSearchClicked(_:)), for: .touchUpInside)
        let customImageButton = UIBarButtonItem(customView: imageButton)
        let barcodeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        barcodeButton.setImage(UIImage(named: "barcode"), for: .normal);
        barcodeButton.addTarget(self, action: #selector(barcodeScannerClicked(_:)), for: .touchUpInside)
        barcodeButton.tintColor = UIColor.black
        barcodeButton.imageView?.contentMode = .scaleAspectFit
        let customBarcodeButton = UIBarButtonItem(customView: barcodeButton)
        
        self.navigationItem.rightBarButtonItems = []
        
        if customAppSettings.sharedInstance.qrCodeSearchScanner {
            self.navigationItem.rightBarButtonItems = [customBarcodeButton,customImageButton]
        }
        view.addSubview(searchBar)
        view.addSubview(productsCollectionView)
        view.addSubview(voiceBtn)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            productsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            productsCollectionView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            productsCollectionView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            productsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            voiceBtn.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -50),
            voiceBtn.heightAnchor.constraint(equalToConstant: 30),
            voiceBtn.widthAnchor.constraint(equalToConstant: 30),
            voiceBtn.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor)
        ])
        searchBar.superview?.bringSubviewToFront(voiceBtn)
        voiceBtn.setImage(UIImage(named: "mic_inactive"), for: .normal)
        voiceBtn.tintColor = .black
        voiceBtn.imageView?.contentMode = .scaleAspectFit
        voiceBtn.isEnabled = false  //2
        voiceBtn.addTarget(self, action: #selector(voiceButtonTapped(_:)), for: .touchUpInside)
        speechRecognizer?.delegate = self  //3
           
           SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
               
               var isButtonEnabled = false
               
               switch authStatus {  //5
               case .authorized:
                   isButtonEnabled = true
                   
               case .denied:
                   isButtonEnabled = false
                   print("User denied access to speech recognition")
                   
               case .restricted:
                   isButtonEnabled = false
                   print("Speech recognition restricted on this device")
                   
               case .notDetermined:
                   isButtonEnabled = false
                   print("Speech recognition not yet authorized")
                   
               @unknown default:
                   print("Unknown error occured")
               }
               
               OperationQueue.main.addOperation() {
                   self.voiceBtn.isEnabled = isButtonEnabled
               }
           }
        
        loadCategories()
    }
    
    @objc func voiceButtonTapped(_ sender : UIButton) {
        print("voiceButtonTapped")
        if audioEngine.isRunning {
                audioEngine.stop()
                recognitionRequest?.endAudio()
            voiceBtn.setImage(UIImage(named: "mic_inactive"), for: .normal)
                //voiceBtn.isEnabled = false
            

            } else {
                voiceBtn.setImage(UIImage(named: "mic_active"), for: .normal)
                startRecording()
                //addSearch()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // JS
        self.tabBarController?.tabBar.tabsVisiblty()
        //     setupNavBar()
        // END
        //        FloatingButton.shared.controller = self
        //        FloatingButton.shared.renderFloatingButton()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        
    }
    
    func loadCategories(){
        self.view.addLoader()
        Client.shared.fetchCollections(maxImageWidth: 300, maxImageHeight: 300, completion: {
            result,error  in
            self.view.stopLoader()
            if let results = result {
                self.collections = results
                self.productsCollectionView.reloadData()
            }else {
                //self.showErrorAlert(error: error?.localizedDescription)
            }
        })
    }
    
    @objc func barcodeScannerClicked(_ sender: UIButton){
        let viewController:ScanViewController = self.storyboard!.instantiateViewController()
        viewController.barcodeScannerCheck = true;
        viewController.delegate = self;
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @objc func addToCartPressed(_ sender:UIButton) {
        if(self.searchedData[sender.tag]["variantTitle"] == "Default Title"){
            if self.searchedData[sender.tag]["inventoryAvailable"]=="true"{
                let variantt = VariantDetail()
                variantt.id = self.searchedData[sender.tag]["variantId"] ?? ""
                variantt.title = self.searchedData[sender.tag]["variantTitle"] ?? ""
                variantt.imageUrl = self.searchedData[sender.tag]["image"] ?? ""//WishlistManager.shared.getVariant((self.products.items[sender.tag].variants.items.first)!)
                let product = self.products.items[sender.tag]
                let item = CartProduct(product: (product.model?.node.viewModel)!, variant: variantt, quantity: 1)
                CartManager.shared.addToCart(item, id: self.searchedData[sender.tag]["id"] ?? "")
                self.quickAddClicked(productId: self.searchedData[sender.tag]["id"] ?? "" , title: self.searchedData[sender.tag]["title"] ?? "" ,error: false)
                
            }
            else {
                if(!(self.searchedData[sender.tag]["inventoryAvailable"]=="true")){
                    self.quickAddClicked(productId: self.searchedData[sender.tag]["id"] ?? "" , title: self.searchedData[sender.tag]["title"] ?? "" ,error: true)
                }
                else
                {
                    let variantt = VariantDetail()
                    variantt.id = self.searchedData[sender.tag]["variantId"] ?? ""
                    variantt.title = self.searchedData[sender.tag]["variantTitle"] ?? ""
                    variantt.imageUrl = self.searchedData[sender.tag]["image"] ?? ""
                    
                    
                    let item = CartProduct(product: nil, variant: variantt, quantity: 1)
                    
                    CartManager.shared.addToCart(item, id: self.searchedData[sender.tag]["id"] ?? "")
                    self.quickAddClicked(productId: self.searchedData[sender.tag]["id"] ?? "" , title: self.searchedData[sender.tag]["title"] ?? "" ,error: false)
                }
            }
        }
        else
        {
            self.quickAddClicked(productId: self.searchedData[sender.tag]["id"] ?? "" ,title: "",error: false)
        }
    }
    
    func quickAddClicked(productId: String,title: String,error: Bool) {
        if(title == ""){
            let vc = AddToCartVC()
            vc.id = productId
            self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: vc)
            vc.modalPresentationStyle = .custom
            vc.delegate = self;
            vc.isFromWishlist=false
            vc.transitioningDelegate = self.halfModalTransitioningDelegate
            self.present(vc, animated: true, completion: nil)
        }
        else{
            if(error){
                self.view.makeToast(title+" not available.".localized, duration: 2.0, position: .center)
            }
            else{
                self.view.makeToast(title+" added to cart.".localized, duration: 2.0, position: .center)
                self.setupTabbarCount()
            }
        }
    }
}

extension AlgoliaSearchViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let products = products{
//            if(products.items.count > 0){
//                return products.items.count
//            }
//        }
        if searchedData.count > 0 {
            return searchedData.count
        }
        return collections?.items.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(searchedData.count > 0){
            let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: AlgoliaProductNewCell.className, for: indexPath) as! AlgoliaProductNewCell
            let product = self.searchedData[indexPath.item]
            cell.setupView(product: product)
            cell.delegate = self
            cell.addToCartButton.addTarget(self, action: #selector(addToCartPressed(_:)), for: .touchUpInside)
            cell.addToCartButton.tag = indexPath.item
            return cell
        }
        
        let cell       = collectionView.dequeueReusableCell(withReuseIdentifier: AlgoliaCollectionCell.className, for: indexPath) as! AlgoliaCollectionCell
        let collection = self.collections.items[indexPath.row]
        cell.configureFrom(collection)
        return cell
    }
    
//    func addSearch(){
//
//        addView = UIView()
//        addView.translatesAutoresizingMaskIntoConstraints = false;
//        addView.backgroundColor = .gray
//        addView.alpha = 0.95
//        self.view.addSubview(addView)
//        let voiceView = VoiceView()
//        voiceView.translatesAutoresizingMaskIntoConstraints = false;
//        addView.addSubview(voiceView)
//        NSLayoutConstraint.activate([
//            addView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            addView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            addView.topAnchor.constraint(equalTo: view.topAnchor),
//            addView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            voiceView.heightAnchor.constraint(equalToConstant: 200),
//            voiceView.widthAnchor.constraint(equalToConstant: 200),
//            voiceView.centerXAnchor.constraint(equalTo: addView.centerXAnchor),
//            voiceView.centerYAnchor.constraint(equalTo: addView.centerYAnchor),
//
//        ])
//        voiceView.cancelButton.rx.tap.bind{
//            self.addView.removeFromSuperview()
//        }.disposed(by: disposeBag)
//    }
//    func removeSearch(){
//        self.addView.removeFromSuperview()
//        voiceBtn.isEnabled = true;
//        self.audioEngine.stop()
//        recognitionRequest?.endAudio()
//        recognitionTask?.cancel()
//        let inputNode = audioEngine.inputNode
//        inputNode.removeTap(onBus: 0)
//        self.recognitionRequest = nil
//        self.recognitionTask = nil
//
//    }
}

extension AlgoliaSearchViewController:algoliaWishlistDelegate
{
    
    func addToWishListProduct(_ cell: AlgoliaProductNewCell, didAddToWishList sender: Any) {
        guard let indexPath = self.productsCollectionView.indexPath(for: cell) else {return}
        let product = self.searchedData[indexPath.row]
        
        let variantDetail = VariantDetail()
        variantDetail.id = product["variantId"]!
        variantDetail.title = product["variantTitle"]!
        variantDetail.imageUrl = product["image"]!
        let wishProduct = CartProduct(product: nil, variant: variantDetail)
        
        if let wishlistProducts = DBManager.shared.wishlistProducts{
            
            if wishlistProducts.contains(where: {$0.variant.id == product["variantId"]!}){
                WishlistManager.shared.removeFromWishList(wishProduct)
            }
            else {
                WishlistManager.shared.addToWishList(wishProduct,id: product["id"],title: product["title"], price: product["price"])
            }
        }
        
        self.setupTabbarCount()
        self.productsCollectionView.reloadItems(at: [indexPath])
    }
}


extension AlgoliaSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(searchedData.count > 0){
            if UIDevice.current.model.lowercased() == "ipad".lowercased(){
                return collectionView.calculateCellSize(numberOfColumns: 4,of: 185.0)
            }
            return collectionView.calculateCellSize(numberOfColumns: 2,of: 150.0)
        }
        //Collection Cell Size
        //return CGSize(width: UIScreen.main.bounds.width - 10, height: 3/7*self.view.frame.width)
        return CGSize(width: UIScreen.main.bounds.width - 10, height: 3/9*self.view.frame.width)
    }
}

extension AlgoliaSearchViewController:UISearchBarDelegate,UISearchDisplayDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchProduct), object: nil)
        self.perform(#selector(searchProduct), with: nil, afterDelay: 1.65)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset) <= 40 {
            if(searchedData.isEmpty){
                self.scrollCollections()
            }
        }
        //   manageTabbar(scrollView)
    }
    
    func scrollCollections(){
        if let _ = collections {
            if self.collections.hasNextPage {
                self.fetchCollections(after: self.collections.items.last?.cursor)
            }
        }
    }
    // ----------------------------------
    //  MARK: - Fetching -
    //
    fileprivate func fetchCollections(after cursor: String? = nil) {
        let width  = productsCollectionView.bounds.width
        let height = Int32(width * 0.8)
        self.view.addLoader()
        Client.shared.fetchCollections(after: cursor, maxImageWidth: height, maxImageHeight: height) { collections,error  in
            self.view.stopLoader()
            if let collections = collections {
                self.collections.appendPage(from: collections)
            }else {
                //self.showErrorAlert(error: error?.localizedDescription)
            }
            self.productsCollectionView.reloadData()
        }
    }
    
    func loadProducts(searchText:String, cursor: String? = nil){
        searchBar.resignFirstResponder()
        if(searchText != ""){
            self.view.addLoader()
            let index = SearchClient(appID: ApplicationID(rawValue: Client.algoliaAppId), apiKey: APIKey(rawValue: Client.algoliaApiKey)).index(withName: IndexName(rawValue: Client.algoliaIndexName))
            
            //let index = SearchClient(appID: "XEPLJ4LUDO", apiKey: "3ba73174525e37c13d94e9fced1f4125").index(withName: "shopify_products")//, indexName: )
            var query = Query(searchText)
            
            query.attributesToRetrieve = [
              "title",
              "image",
              "price",
              "id",
              "objectID",
              "compare_at_price", "inventory_available","variant_title"]
            
            
            index.search(query: query) { (content) in
                
                DispatchQueue.main.async {
                    self.view.stopLoader()
                }
                switch(content) {
                case .success(let searchRes):
                    var finalData = [[String:String]]()
                    print("--search--")
                    print(searchRes.userData)
                    print(searchRes)
                    for items in searchRes.hits {
                        var data = [String:String]()
                        print(items.object["image"]?.object() as! String)
                        if let id = items.object["id"]?.object() as? Double{
                            if let intId = Int(exactly: id) {
                                data["id"] = "gid://shopify/Product/\(intId)"
                            }
                        }
                        //data["id"] = items.object["id"]?.debugDescription ?? ""
                        if let variantId = items.object["objectID"]?.object() as? String{
                            data["variantId"] = "gid://shopify/ProductVariant/\(variantId)"
                        }
                        if let title = items.object["title"]?.object() as? String{
                            data["title"] = title
                        }
                        if let title = items.object["variant_title"]?.object() as? String{
                            data["variantTitle"] = title
                        }
//                        if let price = items.object["price"]?.object() as? Decimal{
//                            data["price"] = "\(price)"
//                        }
                        data["price"] = items.object["price"]?.debugDescription ?? ""
                        if let inventory = items.object["inventory_available"]?.object() as? Bool{
                            data["inventoryAvailable"] = "\(inventory)"
                        }
                        if let image = items.object["image"]?.object() as? String{
                            data["image"] = image
                        }
                        data["compareAtPrice"] = items.object["compare_at_price"]?.debugDescription ?? ""
                        finalData.append(data)
                    }
                    self.searchedData = finalData
                    DispatchQueue.main.async {
                        self.productsCollectionView.reloadData()
                    }
                    
                case .failure(let error) :
                    print(error.localizedDescription)
                }
                
            }
        }
        else
        {
            self.searchedData = []
            self.productsCollectionView.reloadData()
        }
       
        
    }
    
    @objc func searchProduct(){
        if let searchText = searchBar.text{
            loadProducts(searchText:searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            
            searchBar.resignFirstResponder()
            loadProducts(searchText:searchText)
        }
    }
}

extension AlgoliaSearchViewController: BarcodeProtocol{
    func searchBarcode(text: String) {
        if(text == ""){
            self.view.makeToast("No Products Found In Collection".localized, duration: 2.0, position: .center);
            return;
        }
        loadProducts(searchText:text)
    }
}

extension AlgoliaSearchViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(searchedData.count > 0){
            let product         = self.searchedData[indexPath.row]
            let productViewController=ProductVC()//:ProductViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController()
            productViewController.productId = product["id"]!
            productViewController.isProductLoading = true;
            //productViewController.relatedProducts = self.products
            self.navigationController?.pushViewController(productViewController, animated: true)
        }
        else{
            navigateToProductListing(indexPath: indexPath)
        }
    }
    
    func navigateToProductListing(indexPath: IndexPath){
        let collection         = self.collections.items[indexPath.row]
        let productListingController = ProductListVC()//:ProductListViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController()
        productListingController.collection = collection
        productListingController.title = collection.title
        productListingController.isfromHome = false
        self.navigationController?.pushViewController(productListingController, animated: true)
    }
}

struct SearchCollection : Codable {
    let title : String
    let productImage : String
    let price : String
    let comparePrice : String
    let productId : String
    let variantId : String
    
    init(json:SwiftyJSON.JSON) {
        title = json["title"].stringValue
        productImage = json["product_image"].stringValue
        price = json["price"].stringValue
        productId = json["id"].stringValue
        variantId = json["objectID"].stringValue
        comparePrice = json["compare_at_price"].stringValue
    }
}

extension AlgoliaSearchViewController {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            voiceBtn.isEnabled = true
        } else {
            voiceBtn.isEnabled = false
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        //        guard let inputNode = audioEngine.inputNode else {
        //            fatalError("Audio engine has no input node")
        //        }
        
        let inputNode = audioEngine.inputNode
        
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            //self.removeSearch()
            if result != nil {
                
                self.searchBar.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.voiceBtn.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        //        searchBar.text = "Say something, I'm listening!"
        
    }
}
extension AlgoliaSearchViewController: UINavigationControllerDelegate {
  
  @objc func imageSearchClicked(_ sender: UIButton){
    initializeMLModel()
  }
  
  func initializeMLModel(){
    
    let labelerOptions = ImageLabelerOptions()
    labelerOptions.confidenceThreshold = 0.7
    imageLabeler = ImageLabeler.imageLabeler(options: labelerOptions)
    opencameraController()
  }
  
  func opencameraController()
  {
    guard UIImagePickerController.isCameraDeviceAvailable(.front) ||
            UIImagePickerController.isCameraDeviceAvailable(.rear)
    else {
      return
    }
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .camera
    imagePicker.allowsEditing = true;
    present(imagePicker, animated: true)
    
    
    // [END detect_label]
  }
  
}

// MARK: - UIImagePickerControllerDelegate

extension AlgoliaSearchViewController: UIImagePickerControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    var imageToSave: UIImage?
    if let editedImage = info[.editedImage] as? UIImage{
      imageToSave = editedImage
    }
    else if let originalImage = info[.originalImage] as? UIImage{
      imageToSave = originalImage
    }
    //imageview.image = imageToSave;
    //resultsLabel.text = ""
    dismiss(animated: true, completion: nil)
    guard imageToSave != nil else{
      print("image not found")
      return;
    }
    let visionImage = VisionImage(image: imageToSave!)
    performMLMagicOn(visionImage)
  }
  
  func performMLMagicOn(_ visionImage: VisionImage){
    imageLabeler?.process(visionImage, completion: {[weak self] (labels, error) in
      if let _ = error{
        print("error")
        self?.navigationController?.popViewController(animated: true, completion: {
          self?.loadMLProducts(text: "")
        })
        return;
      }
      if let labels = labels{
        if(labels.count == 0){
          self?.navigationController?.popViewController(animated: true, completion: {
            self?.loadMLProducts(text: "")
          })
          return;
        }
        self?.datasourceArray = [String]()
        for visionLabel in labels{
          let resultText = visionLabel.text.trimmingCharacters(in: .whitespacesAndNewlines)
          self?.datasourceArray.append(resultText);
        }
        if(self?.datasourceArray.count ?? 0 > 0){
          self?.navigationController?.popViewController(animated: true, completion: {
            self?.loadMLProducts(text: self?.datasourceArray[0] ?? "")
          })
        }
      }
    })
  }
  
  func loadMLProducts(text: String){
    if(text == ""){
        self.view.makeToast("No Products Found In Collection".localized, duration: 2.0, position: .center);
      return;
    }
    searchBar.text = text;
    loadProducts(searchText:text)
  }
}
