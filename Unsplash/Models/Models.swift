//
//  File.swift
//  Unsplash
//
//  Created by Indrajit-mac on 31/12/18.
//  Copyright © 2018 IND. All rights reserved.
//

import Foundation


class Photo:Codable {
  
    var id: String?
    var createdAt, updatedAt: String?
    var width, height: Int?
    var color: String?
    var urls: Urls?
    var links: Links?
    var sponsored: Bool?
    var sponsoredBy: SponsoredBy?
    var sponsoredImpressionsID: String?
    var likes: Int?
    var likedByUser: Bool?
    var user: SponsoredBy?
    
    

}



class Links:Codable {
    let linksSelf, html, download, downloadLocation: String?
  
}

class SponsoredBy:Codable {
    let id: String?
    let updatedAt: String?
    let username, name, firstName: String?
    let lastName: String?
    let twitterUsername: String?
    let portfolioURL: String?
    let bio, location: String?
    let links: SponsoredByLinks?
    let profileImage: ProfileImage?
    let instagramUsername: String?
    let totalCollections, totalLikes, totalPhotos: Int?
    let acceptedTos: Bool?
    
 
}

class SponsoredByLinks:Codable {
    let linksSelf, html, photos, likes: String?
    let portfolio, following, followers: String?
    
}

class ProfileImage:Codable {
    let small, medium, large: String?
    
  
}

class Urls:Codable {
    let raw,thumb,full, regular, small: String?
}
