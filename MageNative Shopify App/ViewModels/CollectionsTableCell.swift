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

class CollectionsTableCell: UITableViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var widthConstant: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    // ----------------------------------
    //  MARK: - Configure -
    //
    func configureFrom(_ viewModel: CollectionViewModel) {
        self.categoryName.text = viewModel.title.uppercased()
        self.categoryName.font = mageFont.regularFont(size: 15.0)
        self.categoryImage.setImageFrom(viewModel.imageURL)
        self.categoryImage.contentMode = .scaleAspectFit
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
