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

class CollectionViewController: BaseViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  fileprivate var collections: PageableArray<CollectionViewModel>!
  
  var products: PageableArray<ProductListViewModel>!
  //var searchController: UISearchDisplayController!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureTableView()
    self.setupSearchBar()
    self.view.addLoader()
//      self.navigationItem.title = "SEARCH YOUR PRODUCTS".localized
      if #available(iOS 13.0, *) {
          searchBar.searchTextField.font = mageFont.regularFont(size: 15.0)
      } else {
          // Fallback on earlier versions
      }
    Client.shared.fetchCollections(maxImageWidth: 300, maxImageHeight: 300, completion: {
      result,error  in
      self.view.stopLoader()
      if let results = result {
        self.collections = results
        self.tableView.reloadData()
      }else {
        //self.showErrorAlert(error: error?.localizedDescription)
      }
      
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
      self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.isHidden = false
      self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  
func setupSearchBar(){
  searchBar.delegate = self
  //        searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
  //        searchController.searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicCell")
  //        searchController.searchResultsTableView.tableFooterView = UIView()
  
  //        searchController.searchResultsDataSource = self
  //        searchController.searchResultsDelegate = self
}
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // ----------------------------------
  //  MARK: - Fetching -
  //
  fileprivate func fetchCollections(after cursor: String? = nil) {
    let width  = tableView.bounds.width
    let height = Int32(width * 0.8)
    self.view.addLoader()
    
    Client.shared.fetchCollections(after: cursor, maxImageWidth: height, maxImageHeight: height) { collections,error  in
      self.view.stopLoader()
      if let collections = collections {
        self.collections.appendPage(from: collections)
      }
      else {
        //self.showErrorAlert(error: error?.localizedDescription)
      }
      self.tableView.reloadData()
    }
  }
  
  private func configureTableView() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    
    if (maximumOffset - currentOffset) <= 40 {
      if let _ = collections {
        if self.collections.hasNextPage {
          self.fetchCollections(after: self.collections.items.last?.cursor)
        }
      }
    }
  }
}
// ----------------------------------
//  MARK: - UICollectionViewDelegate -
//
extension CollectionViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if self.tableView != tableView {
      let product         = self.products.items[indexPath.row]
      let productViewController=ProductVC()//:ProductViewController = self.storyboard!.instantiateViewController()
      productViewController.product = product.model?.node.viewModel
      //productViewController.relatedProducts = self.products
      self.navigationController?.pushViewController(productViewController, animated: true)
    }
    else {
      let collection = self.collections.items[indexPath.section]
      let productListingController = ProductListVC() //:ProductListViewController = self.storyboard!.instantiateViewController()
      productListingController.collection = collection
      productListingController.title = collection.title
      self.navigationController?.pushViewController(productListingController, animated: true)
    }
  }
}

// ----------------------------------
//  MARK: - UICollectionViewDataSource -
//
extension CollectionViewController: UITableViewDataSource {
  
  // ----------------------------------
  //  MARK: - Data -
  //
  func numberOfSections(in tableView: UITableView) -> Int {
    if self.tableView != tableView {
      return self.products?.items.count ?? 0
    }else {
      return self.collections?.items.count ?? 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if self.tableView != tableView {
      let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
      let product = self.products.items[indexPath.row]
      cell?.textLabel?.text = product.title
        cell?.textLabel?.font = mageFont.regularFont(size: 15.0)
      if let image = product.images.items.first {
        let url = image.url
        cell?.imageView?.setImageFrom(url)
      }
      return cell!
    }
    else {
      let cell       = tableView.dequeueReusableCell(withIdentifier: CollectionsTableCell.className, for: indexPath) as! CollectionsTableCell
      let collection = self.collections.items[indexPath.section]
      
      cell.configureFrom(collection)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if self.tableView != tableView {
      return 50
    }
    return 150
  }
}


extension CollectionViewController:UISearchBarDelegate,UISearchDisplayDelegate{
  
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.navigationController?.navigationBar.isHidden = true
      self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if let searchText = searchBar.text {
      if searchText != "" {
        let viewControl=ProductListVC()//:ProductListViewController = self.storyboard!.instantiateViewController()
        viewControl.isFromSearch = true
        viewControl.searchText = searchText
        viewControl.title = searchText
        self.navigationController?.pushViewController(viewControl, animated: true)
      }
    }
  }
}



