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

class Country {
    static let shared=Country()
    var countries:[String]?
    var countriesWithState:[String:Any]?
    var currentStates:[Any]?
     private init() {
        guard let path = Bundle.main.path(forResource: "country", ofType: "json") else {return}
        guard let value = NSData(contentsOfFile: path) else {return}
        do {
            let json =  try JSONSerialization.jsonObject(with: value as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            let country =  json.keys
            self.countries = country.sorted()
            self.countriesWithState = json
        }catch let error {
            print(error)
        }
      
    }
    
   
    func stateWithCountry(with country:String){
        self.currentStates = self.countriesWithState?[country] as! [String]
    }
}
