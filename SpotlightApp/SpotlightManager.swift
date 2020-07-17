//
//  SpotlightManager.swift
//  SpotlightApp
//
//  Created by Ömer Faruk Öztürk on 1.12.2017.
//  Copyright © 2017 omerfarukozturk. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class SpotlightManager {
    
    // Singleton
    class var sharedInstance: SpotlightManager {
        struct Static {
            static let instance: SpotlightManager = SpotlightManager()
        }
        return Static.instance
    }
    
    // Create and return CSSearchableItem from given parameters.
    func getSearchableItem(_ parameters : [String:String] = [:], group: SpotlightItemGroupType, title: String, description: String, keywords : [String], phoneNumbers:[String]? = nil, location: String? = nil) -> CSSearchableItem {
        
        let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        
        searchableItemAttributeSet.title = title
        searchableItemAttributeSet.contentDescription = description
        searchableItemAttributeSet.keywords = keywords

        // Set thumbnail image.
        if let thumbnail = UIImage(named: parameters["thumbnailImage"] ?? ""){
            searchableItemAttributeSet.thumbnailData = thumbnail.jpegData(compressionQuality: 0.1)
        }
        
        if let phoneNumbers = phoneNumbers {
            searchableItemAttributeSet.supportsPhoneCall = 1
            searchableItemAttributeSet.phoneNumbers = phoneNumbers
        }
        
        if let location = location {
            searchableItemAttributeSet.supportsNavigation = 1
            searchableItemAttributeSet.namedLocation = location
        }
        
        var queryString = "?group=\(group.rawValue)"
        
        // set parameters as querystring parameters
        parameters.forEach { (key,value) in
            queryString += "&\(key)=\(value)"
        }
        
        let searchableItem = CSSearchableItem(uniqueIdentifier: queryString, domainIdentifier: group.rawValue, attributeSet: searchableItemAttributeSet)
        
        return searchableItem
    }
    
    // Add or update specified list of CSSearchableItem.
    func setSearchableItems(_ searchableItems: [CSSearchableItem]){
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
            if let error =  error {
                print(error.localizedDescription)
            }
        }
    }
    
    // Delete all searchable spotlight items.
    func deleteAllItems(_ completed: ((_ success: Bool)->())? = nil){
        CSSearchableIndex.default().deleteAllSearchableItems { (error) in
            let success = error == nil
            if let completed = completed {
                completed(success)
            }
        }
    }
    
    // Delete spotlight items by related group identifiers.
    func deleteItemsByGroup(_ groupNames: [String], completed: ((_ success: Bool)->())? = nil){
        
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: groupNames, completionHandler: { (error) in
            let success = error == nil
            if let completed = completed {
                completed(success)
            }
        })
    }
    
    // Delete spotlight list of spotlight items by related identifiers.
    func deleteItemById(_ identifiers: [String], completed: ((_ success: Bool)->())? = nil){
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: identifiers, completionHandler: { (error) in
            let success = error == nil
            if let completed = completed {
                completed(success)
            }
        })
    }
    
    // Handle spotlight item.
    func spotlightItemTapAction(_ activity: NSUserActivity){
        
        if activity.activityType == CSSearchableItemActionType {
            if let userInfo = activity.userInfo {
                let selectedItem = userInfo[CSSearchableItemActivityIdentifier] as! String
                
                
                // Read data from selected activity info that was set to related item, and save into dictionary.
                var valueDict = Dictionary<String,String>()
                
                if let components = URLComponents(string: selectedItem), let queryItems = components.queryItems {
                    for item in queryItems {
                        valueDict[item.name] = item.value
                    }
                }
                
                if let frontVC = UIApplication.shared.keyWindow?.rootViewController as? ViewController {
                    frontVC.setSelectedItem(data: valueDict)
                }

                print("Selected Item Parameters: \(valueDict)")
            }
        }
    }
    
    // Set a sample list of spotligt items.
    func setupSpotlightItems(){
        var searchableItems = [CSSearchableItem]()
        
        // Set any parameter.
        let parameters1 = ["thumbnailImage" : "image1", "name" : "Teddy"]
        searchableItems.append(getSearchableItem(parameters1, group: SpotlightItemGroupType.animal, title: "Teddy", description: "Animals", keywords: ["teddy","dog","animal"]))
        
        let parameters2 = ["thumbnailImage" : "image2" , "name" : "My Flower"]
        searchableItems.append(getSearchableItem(parameters2, group: SpotlightItemGroupType.flower, title: "My Flower", description: "Flowers", keywords: ["flower"]))
        
        self.setSearchableItems(searchableItems)
        
    }
    
    // Delete all items and set new items.
    func reloadInitialItems(){
        
        // Delete and reload all items
        self.deleteAllItems { (completed) in
            self.setupSpotlightItems()
        }
    }
}

enum SpotlightItemGroupType : String {
    case undefined = "Undefined",
    animal = "Animal",
    flower = "Flower"
}
