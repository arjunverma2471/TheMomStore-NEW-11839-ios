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

import Foundation

class MenuObject
{
    let name : String
    var children : [MenuObject]
    var id:String
    var image:String
    var type:String
    var url:String
    
    init(name : String, children: [MenuObject], id: String,image: String,type: String,url: String) {
        self.name = name
        self.children = children
        self.id=id
        self.image=image
        self.type = type
        self.url = url
    }
    
    convenience init(name : String, id: String,image: String,type: String,url: String) {
        self.init(name: name, children: [MenuObject](), id: id,image: image,type: type,url: url)
    }
    
    func addChild(_ child : MenuObject) {
        self.children.append(child)
    }
    
    func removeChild(_ child : MenuObject) {
        self.children = self.children.filter( {$0 !== child})
    }
}
