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
import youtube_ios_player_helper

class HomeSingleBannerCell: UITableViewCell {
    
    lazy var productVideo : YTPlayerView = {
        let image = YTPlayerView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var textButton1: UIButton!
    @IBOutlet weak var textButton2: UIButton!
    @IBOutlet weak var buttonCenterConstant: NSLayoutConstraint!
    @IBOutlet weak var stackBottomConstant: NSLayoutConstraint!
    
    var delegate: bannerClicked?
    var parent : HomeViewController!
    
    var model:HomeStandAloneBannerViewModel?
    
    
    func setupUI() {
        addSubview(productVideo)
        productVideo.anchor(top: bannerImageView.topAnchor, left: bannerImageView.leadingAnchor, bottom: bannerImageView.bottomAnchor, right: bannerImageView.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        self.productVideo.isHidden = true
        self.bannerImageView.layer.masksToBounds = true
        self.bannerImageView.contentMode = .scaleAspectFill
    }
    
    func configure(from model:HomeStandAloneBannerViewModel?){
        self.model = model
        
        if let urlString = model?.banner_url?.absoluteString {
            if urlString.contains("youtube.com") || urlString.contains("www.youtube.com") || urlString.contains("http://www.youtube.com")  {
                self.productVideo.isHidden = false
                if let id = urlString.components(separatedBy: "=").last {
                    self.productVideo.load(withVideoId: id, playerVars: ["autoplay"     : 0,
                                                                          "playsinline"  : 0,
                                                                          "controls"     : "1",
                                                                          "showinfo"     : "0",
                                                                          "origin"       : "http://www.youtube.com"])
                }
               
            } else {
                self.productVideo.isHidden = true
                bannerImageView.setImageFrom(model?.banner_url)
                bannerImageView.isUserInteractionEnabled = true;
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
                bannerImageView.addGestureRecognizer(tapGesture);
            }
           
        }
       
      //  textButton1.setTitle(model?.first_button_text, for: .normal)
        let data = model?.first_button_text ?? ""
        let data1 = model?.second_button_text ?? ""
        self.textButton1.setTitle(data, for: .normal)
        self.textButton2.setTitle(data1, for: .normal)
        self.textButton2.titleLabel?.lineBreakMode = .byTruncatingTail
        self.textButton1.titleLabel?.lineBreakMode = .byTruncatingTail
        textButton1.setTitleColor(model?.button_text_color, for: .normal)
        textButton2.setTitleColor(model?.button_text_color, for: .normal)
        textButton1.backgroundColor = model?.button_background_color
        textButton2.backgroundColor = model?.button_background_color
      textButton1.titleLabel?.font = mageFont.setFont(fontWeight: (model?.item_font_weight)!, fontStyle: (model?.item_font_style)!,fontSize: 13.0)
        textButton2.titleLabel?.font = mageFont.setFont(fontWeight: (model?.item_font_weight)!, fontStyle: (model?.item_font_style)!,fontSize: 13.0)
//        textButton1.makeBorder(width: 1, color: model?.button_border_color, radius: 0)
//        textButton2.makeBorder(width: 1, color: model?.button_border_color, radius: 0)
        textButton1.addTarget(self, action: #selector(textButtonClicked(_:)), for: .touchUpInside);
        textButton2.addTarget(self, action: #selector(textButtonClicked(_:)), for: .touchUpInside);
        switch model?.item_text_alignment! {
        case "center":
            textButton2.contentHorizontalAlignment = .center
            textButton1.contentHorizontalAlignment = .center
        case "right":
            if(Client.locale == "ar"){
                textButton2.contentHorizontalAlignment = .left
                textButton1.contentHorizontalAlignment = .left
            }
            else{
                textButton2.contentHorizontalAlignment = .right
                textButton1.contentHorizontalAlignment = .right
            }
        default:
            if(Client.locale == "ar"){
                textButton2.contentHorizontalAlignment = .right
                textButton1.contentHorizontalAlignment = .right
            }
            else{
                textButton2.contentHorizontalAlignment = .left
                textButton1.contentHorizontalAlignment = .left
            }
        }
//        switch model?.item_button_count{
//        case "no-btn":
//            disableTextButtons(textButton: textButton1);
//            disableTextButtons(textButton: textButton2);
//        case "single-btn":
//            disableTextButtons(textButton: textButton2);
//        default:
//            print("both are present")
//        }
    
//        if model?.item_button_count == "no-btn"{
//            disableTextButtons(textButton: textButton1);
//            disableTextButtons(textButton: textButton2);
//
//        }
        
        
//        if model?.item_button_position == "no-btn"{
//            disableTextButtons(textButton: textButton1);
//            disableTextButtons(textButton: textButton2);
//
//        }
        switch model?.item_button_position{
        case "single-btn":
            disableTextButtons(textButton: textButton2);
            textButton1.isHidden = false;
            buttonCenterConstant.priority = .defaultHigh
            stackBottomConstant.priority = .defaultLow
        case "bottom":
//            buttonCenterConstant.constant = 50
        
            buttonCenterConstant.priority = .defaultLow
            stackBottomConstant.priority = .defaultHigh
            
            textButton1.isHidden = false;
            textButton2.isHidden = false;
        case "no-btn":
            disableTextButtons(textButton: textButton1);
            disableTextButtons(textButton: textButton2);
        default:
            textButton1.isHidden = false;
            textButton2.isHidden = false;
            print("center")
            buttonCenterConstant.priority = .defaultHigh
            stackBottomConstant.priority = .defaultLow
        }
        
    }
    
    func disableTextButtons(textButton: UIButton)
    {
        textButton.isHidden = true;
        textButton.removeTarget(self, action: #selector(textButtonClicked(_:)), for: .touchUpInside)
        textButton.setTitle("", for: .normal)
        textButton.addTarget(self, action: #selector(disableButtonRedirect(_:)), for: .touchUpInside)
        textButton.backgroundColor = UIColor.clear
        textButton.makeBorder(width: 0.0, color: .clear, radius: 0.0)
    }
    
    @objc func disableButtonRedirect(_ sender: UIButton){
        self.delegate?.bannerDidSelect(banner: ["link_type":self.model?.banner_link ?? "","link_value":self.model?.banner_link_value ?? ""], sender: self)
    }
    
    @objc func textButtonClicked(_ sender: UIButton)
    {
        if(sender.currentTitle == self.model?.first_button_text)
        {
            self.delegate?.bannerDidSelect(banner: ["link_type":self.model?.first_button_link_type ?? "","link_value":self.model?.first_button_link_value ?? ""], sender: self)
        }
        else if(sender.currentTitle == self.model?.second_button_text){
            self.delegate?.bannerDidSelect(banner: ["link_type":self.model?.second_button_link_type ?? "","link_value":self.model?.second_button_link_value ?? ""], sender: self)
        }
        else{
            self.delegate?.bannerDidSelect(banner: ["link_type":self.model?.banner_link ?? "","link_value":self.model?.banner_link_value ?? ""], sender: self)
        }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer)
    {
        self.delegate?.bannerDidSelect(banner: ["link_type":self.model?.banner_link ?? "","link_value":self.model?.banner_link_value ?? ""], sender: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        bannerImageView.backgroundColor = .red
        bannerImageView.backgroundColor = .randomAlpha
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
