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

class AddressListViewCell: UITableViewCell {
  
    @IBOutlet weak var textlabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
        
    }
    
    func setupView(){
        editButton.layer.borderWidth = 1.0
        editButton.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .addressVC).backGroundColor)
        editButton.setTitleColor(UIColor(light: .black,dark: UIColor.provideColor(type: .addressVC).textColor), for: .normal)
    
        editButton.layer.borderColor = UIColor(light: .black,dark: UIColor.white).cgColor
        deleteButton.layer.borderColor = UIColor(light: .black,dark: UIColor.white).cgColor
      deleteButton.layer.borderWidth = 1.0
        deleteButton.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .addressVC).backGroundColor)
        deleteButton.setTitleColor(UIColor(light: .black,dark: UIColor.provideColor(type: .addressVC).textColor), for: .normal)
        
//      editButton.tintColor = UIColor.black
//      deleteButton.tintColor = UIColor.black
    }
    
    func configureFrom(_ model:AddressesViewModel){
        titleLabel.font = mageFont.mediumFont(size: 14)
        titleLabel.text = model.name?.uppercased()
        var address = model.address1 ?? ""
        if let address2 = model.address2 {
            address +=  " " + address2 + "\n"
        }
        if let city =  model.city {
            address +=  city + " "
        }
        if let province = model.province {
            address += province + "\n"
        }
        if let country = model.country {
            address += country + "-"
        }
        if let zip = model.zip {
            address += zip + "\n"
        }
        if let phone = model.phone {
            address += "Phone: " + phone
        }
        textlabel.text = address
        textlabel.font = mageFont.regularFont(size: 14.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
