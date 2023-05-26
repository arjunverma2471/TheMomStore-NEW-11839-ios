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

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var accountImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        title.font = mageFont.regularFont(size: 14)
        title.textColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .accountVc).textColor)
        accessoryView?.tintColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .accountVc).backGroundColor)
        accountImage.tintColor = UIColor(light: UIColor(hexString: "#383838"),dark: UIColor.provideColor(type: .accountVc).tintColor)
        accountImage.contentMode = .scaleAspectFit
        if Client.locale == "ar" {
          rightImage.image = rightImage.image?.imageFlippedForRightToLeftLayoutDirection()
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
