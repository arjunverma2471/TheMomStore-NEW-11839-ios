//
//  HomeAnnouncementBarCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit
import WebKit

class HomeAnnouncementBarCell: UITableViewCell {
    
    @IBOutlet weak var marqueeWebView: WKWebView!
    @IBOutlet weak var announcementImage: UIImageView!
    @IBOutlet weak var announcementText: UILabel!
    var model : HomeAnnouncementBarViewModel!
    var marqueeSpeed = 0.0
    var parent : HomeViewController!
    var screenwidth = UIScreen.main.bounds.width
    
    var delegate:bannerClicked?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.announcementImage.backgroundColor = .randomAlpha
        self.setTarget()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    func configure(model:HomeAnnouncementBarViewModel) {
        self.model = model
        if model.bar_type == "image" {
            self.configureAnnouncementImage()
        }
        else {
            if model.bar_text_marquee == "1" {
                self.configureMarqueeView()
            }
            else {
                self.configureAnnouncementText()
            }
        }
        
        
    }
    
    func setTarget() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            self.contentView.isUserInteractionEnabled = true
            self.contentView.addGestureRecognizer(tapGesture);
    }
    
    func configureMarqueeView() {
        self.announcementText.isHidden = true
        self.marqueeWebView.isHidden = false
        self.announcementImage.isHidden = true
        self.marqueeWebView.scrollView.isScrollEnabled = false
        self.marqueeWebView.scrollView.bounces = false
        marqueeWebView.scrollView.minimumZoomScale = 1.0
        marqueeWebView.scrollView.maximumZoomScale = 1.0
        
        let direction=(model.marquee_text_direction ?? "") == "rtl" ? "right" : "left"
        let customCSS = returnCustomCSS(direction: direction)
        let marqueeText=model.bar_text ?? ""
        let backgroundColor = model.background_color.2 ?? "black"
        let textColor = model.text_color.2 ?? "white"
        let marqueeSpeed = getMarqueeSpeed(speed: (model.marquee_text_speed ?? 0.0))
        let html = """
                <html>
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <style>
                            @font-face{
                                font-family: 'Poppins';
                                src: local('Poppins-Regular'),url('Poppins-Regular.ttf') format('opentype');
                            }
                            body {
                                margin: 0;
                                padding: 0;
                                height: 100%;
                                background-color: \(backgroundColor);
                            }
                            .marquee {
                                background-color: \(backgroundColor);
                                color: \(textColor);
                                margin: 0;
                                padding: 5;
                                direction: \(direction);
                                animation: marquee \(marqueeSpeed)s linear infinite;
                                font-size: 16px;
                                height: 100%;
                                width : 100%;
                                display: flex;
                                justify-content: \(direction);
                                font-family: 'Poppins', sans-serif;
                                font-weight:400;
                            }
                            \(customCSS)
                        </style>
                    </head>
                    <body>
                       <p class="marquee">\(marqueeText)</p>
                    </body>
                </html>
                """
          self.marqueeWebView.loadHTMLString(html, baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "webfile", ofType: "css") ?? "" ))
        
    }
    
    func configureAnnouncementImage() {
        self.announcementText.isHidden = true
        self.marqueeWebView.isHidden = true
        self.announcementImage.isHidden = false
        self.announcementImage.setImageFrom(model.image_link)
        self.contentView.backgroundColor = UIColor(light: .clear,dark: .black)
    }
    
    func configureAnnouncementText() {
        self.announcementText.isHidden = false
        self.announcementImage.isHidden = true
        self.marqueeWebView.isHidden = true
        self.announcementText.text = "   " + (model.bar_text ?? "") + "   "
        self.contentView.backgroundColor = UIColor(hexString: model.background_color.0 ?? "", alpha: CGFloat(model.background_color.1 ?? 0.0))
        self.announcementText.backgroundColor = .clear
        self.announcementText.textColor = UIColor(hexString: model.text_color.0 ?? "", alpha: CGFloat(model.text_color.1 ?? 0.0))
        self.announcementText.font = mageFont.regularFont(size: 14.0)
        self.announcementText.textAlignment = model.bar_text_alignment ?? .left
    }
    
    func returnCustomCSS(direction:String)->String {
        if direction == "left" {
            return """
        @keyframes marquee {
                        0% { transform: translateX(-100%); }
                        100% { transform: translateX(100%); }
                    }
      """
        }
        else {
            return  """
      @keyframes marquee {
                      0% { transform: translateX(100%); }
                      100% { transform: translateX(-100%); }
                  }
      """
        }
    }
    
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer)
    {
        print("imageTapped")
        if model.bar_type == "image"  {
            self.delegate?.bannerDidSelect(banner: ["link_type":self.model?.image_link_type ?? "","link_value":self.model?.image_link_value ?? ""], sender: self)
        }
        else {
            self.delegate?.bannerDidSelect(banner: ["link_type":self.model?.text_link_type ?? "","link_value":self.model?.text_link_value ?? ""], sender: self)
        }
    }
    
    func getMarqueeSpeed(speed:TimeInterval) -> TimeInterval {
        print("MARQUEE SPEED FROM PANEL", speed)
        switch speed {
        case 10.0 : return 5.0;
        case 9.0 : return 7.0;
        case 8.0 : return 9.0;
        case 7.0 : return 10.0;
        case 6.0 : return 11.0;
        case 5.0 : return 12.0;
        case 4.0 : return 21.0;
        case 3.0 : return 24.0;
        case 2.0 : return 27.0;
        case 1.0 : return 30.0;
        default : return 20.0;
        }
    }
    
}
extension String {
    func convertToTimeInterval() -> TimeInterval {
        guard self != "" else {
            return 0
        }

        var interval:Double = 0

        let parts = self.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }

        return interval
    }
}

