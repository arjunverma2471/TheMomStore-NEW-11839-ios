//
//  Home3hvlayoutCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/06/19.
//  Copyright © 2019 MageNative. All rights reserved.
//

import UIKit
import SwiftUI


protocol ThreeLayoutHeightProtocol{
    func getLayoutHeight(height: CGFloat,componentName: String)
}


class Home3hvlayoutCell: UITableViewCell {
  @IBOutlet weak var parentStackView: UIStackView!
  @IBOutlet weak var childStackView1: UIStackView!
  @IBOutlet weak var childStackView2: UIStackView!
    var heightDelegate: ThreeLayoutHeightProtocol?
  @IBOutlet weak var childStack1View2: UIView!
  @IBOutlet weak var childStackView1imageView2: UIImageView!
  @IBOutlet weak var childStack2View1: UIView!
  @IBOutlet weak var childStack2View2: UIView!
  @IBOutlet weak var childStack2View1ImageView: UIImageView!
  @IBOutlet weak var childStack2View2ImageView: UIImageView!
  
  @IBOutlet weak var parentView: UIView!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var label3: UILabel!
  @IBOutlet weak var label2: UILabel!
  @IBOutlet weak var label1: UILabel!
  @IBOutlet weak var topHeaderSpaceView: UIView!
  
  @IBOutlet weak var bottomHeaderSpaceView: UIView!
  @IBOutlet weak var headerStackView: UIStackView!
  @IBOutlet weak var headerButtonView: UIView!
  @IBOutlet weak var headerTitle: UILabel!
  @IBOutlet weak var headerSubtitle: UILabel!
 
 @IBOutlet weak var dealView: DealView!
    
    @IBOutlet weak var headerDealStackView: UIStackView!
    @IBOutlet weak var headerButton: UIButton!
    var parent : HomeViewController!
  var delegate: bannerClicked?
  var dealtime = 100
  var timer = Timer()
  var startTime = TimeInterval()
  var timerStatus = String()
  var componentName = ""
  var viewModel : Home3hvLayoutViewModel?
    
  override func awakeFromNib() {
    super.awakeFromNib()
      childStackView1imageView2.backgroundColor = .randomAlpha
      childStack2View1ImageView.backgroundColor = .randomAlpha
      childStack2View2ImageView.backgroundColor = .randomAlpha
  }
  
  func configure(from viewmodel:Home3hvLayoutViewModel){
    viewModel = viewmodel
    setupContent(viewmodel: viewmodel)
    if(viewmodel.header == "1")
    {
      setupHeader(viewmodel: viewmodel)
      showHeader(viewmodel: viewmodel)
    }
    else{
      hideHeader()
    }
      
      parentView.backgroundColor = UIColor(light: viewmodel.panel_background_color ?? .white,dark: .black)
      self.backgroundColor = UIColor(light: viewmodel.panel_background_color ?? .white,dark: .black)
  }
  
  @objc func update() {
      
    if(startTime>0){
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            
        }
        let time = NSInteger(self.startTime)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time%(24*3600) / 3600)
        let days = (time/(24*3600))
        
        switch self.viewModel?.item_deal_format! {
        case let x where (x?.contains(":"))!:
         // headerDeal.text = "  \(days)day:\(hours)h:\(minutes)m:\(seconds)s " + (viewModel?.item_deal_message ?? "")
            let data = self.viewModel?.item_deal_message ?? ""
            self.dealView.dayTimerLabel.text = "\(days)"
            self.dealView.hourTimerLabel.text = "\(hours)"
            self.dealView.minTimerLabel.text = "\(minutes)"
            self.dealView.secTimerLabel.text = "\(seconds)"
            
                self.dealView.dealMessageLabel.text = data
           
            
        case let x where (x?.contains("/"))!:
            let data = (self.viewModel?.item_deal_message ?? "")
            self.dealView.dayTimerLabel.text = "\(days)"
            self.dealView.hourTimerLabel.text = "\(hours)"
            self.dealView.minTimerLabel.text = "\(minutes)"
            self.dealView.secTimerLabel.text = "\(seconds)"
            self.dealView.dealMessageLabel.text = data
            
         // headerDeal.text = "  \(days)day/\(hours)h/\(minutes)m/\(seconds)s " + (viewModel?.item_deal_message ?? "")
        default:
            let data = (self.viewModel?.item_deal_message ?? "")
            self.dealView.dayTimerLabel.text = "\(days)"
            self.dealView.hourTimerLabel.text = "\(hours)"
            self.dealView.minTimerLabel.text = "\(minutes)"
            self.dealView.secTimerLabel.text = "\(seconds)"
            self.dealView.dealMessageLabel.text = data
        }
        self.startTime = self.startTime - 0.5
      
    }
    else{
        let data = (viewModel?.item_deal_message) ?? ""
        self.dealView.dealMessageLabel.text = data
    }
    
  }
  
  func addGestureRecognizerInImageview(_ imageView: UIImageView)
  {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    imageView.isUserInteractionEnabled = true;
    imageView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
  {
    let tappedImage = tapGestureRecognizer.view as! UIImageView
    switch tappedImage {
    case childStackView1imageView2:
      if let view1Data = viewModel?.items?[0] as? [String:String] {
        self.delegate?.bannerDidSelect(banner: ["link_type":view1Data["link_type"] ?? "","link_value":view1Data["link_value"] ?? ""], sender: self)
      }
      
    case childStack2View1ImageView:
      if let view1Data = viewModel?.items?[1] as? [String:String] {
        self.delegate?.bannerDidSelect(banner: ["link_type":view1Data["link_type"] ?? "","link_value":view1Data["link_value"] ?? ""], sender: self)
        
      }
    case childStack2View2ImageView:
      if let view1Data = viewModel?.items?[2] as? [String:String] {
        self.delegate?.bannerDidSelect(banner: ["link_type":view1Data["link_type"] ?? "","link_value":view1Data["link_value"] ?? ""], sender: self)
        
      }
    default:
      print("dfdsf")
    }
    
    // Your action
  }
  
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
}
extension Home3hvlayoutCell{
  func showHeader(viewmodel: Home3hvLayoutViewModel){
    if(Client.locale == "ar"){
      headerTitle.textAlignment = .right
      headerSubtitle.textAlignment = .right
      //headerDeal.textAlignment = .right
    }
    else{
      headerTitle.textAlignment = .left
      headerSubtitle.textAlignment = .left
      //headerDeal.textAlignment = .left
    }
    self.headerStackView.isHidden = false;
    topHeaderSpaceView.isHidden = false;
    bottomHeaderSpaceView.isHidden = false;
    headerTitle.isHidden = false;
    headerView.isHidden = false;
      self.headerView.backgroundColor =  UIColor(light: viewmodel.header_background_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
    if(viewmodel.header_subtitle == "1"){
      self.headerSubtitle.isHidden = false;
    }
    else{
      self.headerSubtitle.isHidden = true;
    }
    if(viewmodel.header_deal == "1")
    {
        self.headerDealStackView.isHidden = false;
        self.dealView.isHidden = false
//      self.headerDeal.isHidden = false;
//      self.headerDealImage.isHidden = false;
//      self.headerDealImage.image = UIImage(named: "clock")?.withRenderingMode(.alwaysTemplate)
//      self.headerDealImage.tintColor = viewmodel.header_deal_color
      let dateFormatter1 = DateFormatter()
      dateFormatter1.dateFormat = "MM/dd/yyyy HH:mm:ss"
      if let endDate = dateFormatter1.date(from: (viewmodel.item_deal_end_date)!){
        if(endDate>Date()){
          self.startTime = Double(Calendar.current.dateComponents([.second], from: Date(), to: endDate).second!)
            
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true);
            //RunLoop.current.add(self.timer, forMode: .common)
        }
        else{
            self.dealView.isHidden = true;
//          self.headerDeal.isHidden = true;
//          self.headerDealImage.isHidden = true;
//          self.headerDealImage.image = nil
            self.headerDealStackView.isHidden = true;
        }
      }
    }
    else{
        self.dealView.isHidden = true;
//      self.headerDeal.isHidden = true;
//      self.headerDealImage.isHidden = true;
//      self.headerDealImage.image = nil
      self.headerDealStackView.isHidden = true;
    }
    
    if(viewmodel.header_action == "1")
    {
      self.headerButtonView.isHidden = false;
      self.headerButton.isHidden = false;
    }
    else{
      self.headerButtonView.isHidden = true;
      self.headerButton.isHidden = true;
    }
  }
  
  func hideHeader(){
    self.headerStackView.isHidden = true;
    self.topHeaderSpaceView.isHidden = true;
    self.bottomHeaderSpaceView.isHidden = true;
    self.headerView.isHidden = true;
    self.headerSubtitle.isHidden = true;
    self.headerTitle.isHidden = true;
      self.dealView.isHidden = true;
//    self.headerDealImage.isHidden = true;
//    headerDeal.isHidden = true;
//    headerDealImage.image = nil
    self.headerButtonView.isHidden = true;
    self.headerButton.isHidden = true;
  }
  
  func setupHeader(viewmodel: Home3hvLayoutViewModel){
   // headerTitle.text = viewmodel.header_title_text
      self.headerTitle.text = viewmodel.header_title_text ?? ""
      self.headerButton.setTitle(viewmodel.header_action_text, for: .normal)
      
 //   headerButton.setTitle(viewmodel.header_action_text, for: .normal)
    headerView.backgroundColor = UIColor(light: viewmodel.header_background_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
    headerTitle.textColor = UIColor(light: viewmodel.header_title_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
    parentView.backgroundColor = UIColor(light: viewmodel.panel_background_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
    self.backgroundColor = UIColor(light: viewmodel.panel_background_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).panelBackgroundColor)
    self.headerTitle.font = mageFont.setFont(fontWeight: (viewModel?.header_title_font_weight)!, fontStyle: (viewmodel.header_title_font_style)!, fontSize: 15.0)
    
    if(viewmodel.header_deal == "1"){
        self.dealView.dayTimerLabel.font = mageFont.setFont(fontWeight: (viewmodel.header_subtitle_font_weight)!, fontStyle: (viewmodel.header_subtitle_font_style)!, fontSize: 16.0)
        self.dealView.hourTimerLabel.font = mageFont.setFont(fontWeight: (viewmodel.header_subtitle_font_weight)!, fontStyle: (viewmodel.header_subtitle_font_style)!, fontSize: 16.0)
        self.dealView.minTimerLabel.font = mageFont.setFont(fontWeight: (viewmodel.header_subtitle_font_weight)!, fontStyle: (viewmodel.header_subtitle_font_style)!, fontSize: 16.0)
        self.dealView.secTimerLabel.font = mageFont.setFont(fontWeight: (viewmodel.header_subtitle_font_weight)!, fontStyle: (viewmodel.header_subtitle_font_style)!, fontSize: 16.0)
      //headerDeal.textColor = viewmodel.header_deal_color
    }
    
    if(viewmodel.header_subtitle == "1"){
      self.headerSubtitle.font = mageFont.setFont(fontWeight: (viewmodel.header_subtitle_font_weight)!, fontStyle: (viewmodel.header_subtitle_font_style ?? "normal"), fontSize: 14.0)
        headerSubtitle.text = viewmodel.header_subtitle_text
      headerSubtitle.textColor = UIColor(light: viewmodel.header_subtitle_color ?? .white, dark: UIColor.provideColor(type: .newHomeCategorySliderCell).itemTitleColor)
    }
    
    if(viewmodel.header_action == "1"){
      self.headerButton.titleLabel?.font = mageFont.setFont(fontWeight: (viewmodel.header_action_font_weight)!, fontStyle: (viewmodel.header_action_font_style)!)
        self.headerButton.setTitle(viewmodel.header_action_text, for: .normal)
        
      self.headerButton.setTitleColor(viewmodel.header_action_color, for: .normal)
      self.headerButton.backgroundColor = viewmodel.header_action_background_color
    }
    
  }
  
}
extension Home3hvlayoutCell{
  func setupContent(viewmodel: Home3hvLayoutViewModel){
    if let view1Data = viewmodel.items?[0] as? [String:String] {
        
      if let imageUrl = view1Data["image_url"]?.getURL(){
          
//          DispatchQueue.global(qos: .userInitiated).async {
//              if let size = ImageSize.shared.sizeOfImageAt(url: imageUrl){
//                  //self!.imageSize=size
//                  DispatchQueue.main.async {
//                      var returnsize = CGFloat(((UIScreen.main.bounds.width-35)*(size.height/size.width)/1.6) + 20)
//                      if(viewmodel.header == "1"){
//                          returnsize += 30
//                          if(viewmodel.header_subtitle == "1"){
//                              returnsize += 20
//                          }
//                          if(viewmodel.header_deal == "1"){
//                              returnsize += 95
//                          }
////                          returnsize = CGFloat(((UIScreen.main.bounds.width-35)*(size.height/size.width)/1.5) + 60)
//                      }
//                      self.heightDelegate?.getLayoutHeight(height: returnsize, componentName: self.componentName)
//                  }
//              }
//          }
          
//          DispatchQueue.global(qos: .userInitiated).async {
//              if let size = ImageSize.shared.sizeOfImageAt(url: imageUrl){
//                  //self!.imageSize=size
//                  DispatchQueue.main.async {
//                      var returnsize = CGFloat(((UIScreen.main.bounds.width-35)*(size.height/size.width)/1.6) + 50)
//                      if(viewmodel.header == "1"){
//                          returnsize += 30
//                          if(viewmodel.header_subtitle == "1"){
//                              returnsize += 20
//                          }
//                          if(viewmodel.header_deal == "1"){
//                              returnsize += 95
//                          }
////                          returnsize = CGFloat(((UIScreen.main.bounds.width-35)*(size.height/size.width)/1.5) + 60)
//                      }
//                      self.heightDelegate?.getLayoutHeight(height: returnsize, componentName: self.componentName)
//                  }
//              }
//          }
        childStackView1imageView2.setImageFrom(imageUrl)
      }
        label1.text = view1Data["title"]
    }
//      childStack2View1ImageView.contentMode = .scaleAspectFit
//      childStackView1imageView2.contentMode = .scaleAspectFit;
//      childStack2View2ImageView.contentMode = .scaleAspectFit
    if let view1Data = viewmodel.items?[1] as? [String:String] {
      if let imageUrl = view1Data["image_url"]?.getURL(){
        childStack2View1ImageView.setImageFrom(imageUrl)
      }
     
        label2.text = view1Data["title"]
        
    }
    if let view1Data = viewmodel.items?[2] as? [String:String] {
      if let imageUrl = view1Data["image_url"]?.getURL(){
        childStack2View2ImageView.setImageFrom(imageUrl)
      }
        label3.text = view1Data["title"]
        
    }
    if(viewmodel.item_shape == "square")
    {
        
        
        childStack1View2.makeBorder(width: 1, color: UIColor(light: viewmodel.item_border_color ?? .white,dark: DarkColor.darkBorderColor),radius: 0)
        childStack2View1.makeBorder(width: 1, color: UIColor(light: viewmodel.item_border_color ?? .white,dark: DarkColor.darkBorderColor),radius: 0)
        childStack2View2.makeBorder(width: 1, color: UIColor(light: viewmodel.item_border_color ?? .white,dark: DarkColor.darkBorderColor),radius: 0)
        childStackView1imageView2.layer.cornerRadius = 0
        childStack2View2ImageView.layer.cornerRadius = 0
        childStack2View1ImageView.layer.cornerRadius = 0
    }
    else{
        childStack1View2.makeBorder(width: 1, color: UIColor(light: viewmodel.item_border_color ?? .white,dark: DarkColor.darkBorderColor),radius: 10)
        childStackView1imageView2.layer.cornerRadius = 10
        childStackView1imageView2.clipsToBounds = true;
        childStack2View2ImageView.layer.cornerRadius = 10
        childStack2View2ImageView.clipsToBounds = true;
        childStack2View1ImageView.layer.cornerRadius = 10
        childStack2View1ImageView.clipsToBounds = true;
        childStack2View1.makeBorder(width: 1, color: UIColor(light: viewmodel.item_border_color ?? .white,dark: DarkColor.darkBorderColor),radius: 10)
        childStack2View2.makeBorder(width: 1, color: UIColor(light: viewmodel.item_border_color ?? .white,dark: DarkColor.darkBorderColor),radius: 10)
    }
    
    if(viewmodel.item_border != "1")
    {
        childStack1View2.layer.borderWidth = 0;
        childStack2View1.layer.borderWidth = 0;
        childStack2View2.layer.borderWidth = 0;
    }
    
    switch viewmodel.item_text_alignment {
    case "center":
      label1.textAlignment = .center
      label2.textAlignment = .center
      label3.textAlignment = .center
    case "right":
        label1.textAlignment = Client.locale == "ar" ? .left : .right
        label2.textAlignment = Client.locale == "ar" ? .left : .right
        label3.textAlignment = Client.locale == "ar" ? .left : .right
    default:
        label1.textAlignment = Client.locale == "ar" ? .right : .left
        label2.textAlignment = Client.locale == "ar" ? .right : .left
        label3.textAlignment = Client.locale == "ar" ? .right : .left
    }
    self.label1.font = mageFont.setFont(fontWeight: (viewmodel.item_title_font_weight)!, fontStyle: (viewmodel.item_title_font_style)!, fontSize: 14.0)
    self.label2.font = mageFont.setFont(fontWeight: (viewmodel.item_title_font_weight)!, fontStyle: (viewmodel.item_title_font_style)!, fontSize: 14.0)
    self.label3.font = mageFont.setFont(fontWeight: (viewmodel.item_title_font_weight)!, fontStyle: (viewmodel.item_title_font_style)!, fontSize: 14.0)
      self.label1.textColor = .white
      self.label2.textColor = .white
      self.label3.textColor = .white
    
    
//    childStack1View2.makeBorder(width: 1, color: viewmodel.item_border_color, radius: 15)
//    childStack2View1.makeBorder(width: 1, color: viewmodel.item_border_color, radius: 15)
//    childStack2View2.makeBorder(width: 1, color: viewmodel.item_border_color, radius: 15)
    addGestureRecognizerInImageview(childStackView1imageView2)
    addGestureRecognizerInImageview(childStack2View1ImageView)
    addGestureRecognizerInImageview(childStack2View2ImageView)
  }
}
