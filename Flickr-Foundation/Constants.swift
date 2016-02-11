//
//  Constants.swift
//  Flickr-Foundation
//
//  Created by DML_Admin on 11/02/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit

struct Constants {

	struct Flickr {

		static let APIScheme = "https"
		static let APIHost = "api.flickr.com"
		static let APIPath = "/services/rest"
	}

	// MARK: Flickr Parameter Keys
	struct FlickrParameterKeys {
		static let Method = "method"
		static let APIKey = "api_key"
		static let GalleryID = "gallery_id"
		static let Extras = "extras"
		static let Format = "format"
		static let NoJSONCallback = "nojsoncallback"
	}

	// MARK: Flickr Parameter Values
	struct FlickrParameterValues {
		static let SearchMethod = "flickr.galleries.getPhotos"
		static let APIKey = "ENTER YOUR OWN API KEY HERE"
		static let ResponseFormat = "json"
		static let DisableJSONCallback = "1" /* 1 means "yes" */
		static let GalleryID = "72157663354529069"
		static let Extras = "url_m"
	}
}