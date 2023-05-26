//
//  selecting_local.swift
//  Localization102
//
//  Created by cedcoss on 3/23/17.
//  Copyright © 2017 cedcoss. All rights reserved.
//

import UIKit

class selecting_local: NSObject {
    class func DoTheSwizzling() {
        
        // 1
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(key:value:table:)))
        
    }
    
}

extension Bundle {
    
    @objc func specialLocalizedStringForKey(key: String, value: String?, table tableName: String?) -> String {
        let userlang=UserDefaults.standard
        
        /*2*/ let lang = userlang.object(forKey: "AppleLanguages") as! Array<String>
        let currentLanguage=lang[0];
        var bundle = Bundle();
        
        /*3*/if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            
            bundle = Bundle(path: _path)!
            
        } else {
            
            let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
            
            bundle = Bundle(path: _path)!
            
        }
        
        /*4*/return (bundle.specialLocalizedStringForKey(key: key, value: value, table: tableName))
        
    }
    
}

/// Exchange the implementation of two methods for the same Class

func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    print(cls)
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
    
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!;
    
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        
    } else {
        
        method_exchangeImplementations(origMethod, overrideMethod);
        
    }
}
