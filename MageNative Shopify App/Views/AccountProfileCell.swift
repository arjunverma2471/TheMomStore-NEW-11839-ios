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

class AccountProfileCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var loginViaMailLabel: UILabel!
    @IBOutlet weak var nameInitials: UILabel!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileButton.setTitle("", for: .normal)
        profileButton.setImage(UIImage(named: "profileN")?.withRenderingMode(.alwaysTemplate), for: .normal)
        profileButton.tintColor = UIColor(light: .black,dark: .white)
        profileButton.imageView?.contentMode = .scaleAspectFit
        profileImage.backgroundColor = UIColor(light: UIColor(hexString: "#D1D1D1"), dark: UIColor.gray)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
