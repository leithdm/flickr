import UIKit

class ViewController: UIViewController {

  //MARK: - constants
  let BASE_URL = "https://api.flickr.com/services/rest/"
  let METHOD_NAME = "flickr.galleries.getPhotos"
  let API_KEY = "fd24760b02ba530ea261db0a3ab9b09e"
  let GALLERY_ID = "72157663354529069"
  let EXTRAS = "url_m"
  let DATA_FORMAT = "json"
  let NO_JSON_CALLBACK = "1"

  @IBOutlet weak var ImageView: UIImageView!
  @IBOutlet weak var imageTitle: UILabel!

  //MARK: - lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()

    getImageFromFlickr()
  }


  //MARK: - get image from Flickr
  func getImageFromFlickr() {

    //Flickr API method arguments
    let methodArguments = [
      "method": METHOD_NAME,
      "api_key": API_KEY,
      "gallery_id": GALLERY_ID,
      "extras": EXTRAS,
      "format": DATA_FORMAT,
      "nojsoncallback": NO_JSON_CALLBACK
    ]

    //Initialize session and url
    let session = NSURLSession.sharedSession()
    let urlString = BASE_URL + escapedParameters(methodArguments)
    let url = NSURL(string: urlString)
    let request = NSURLRequest(URL: url!)

    //Initialize task for getting data
    let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in

      // GUARD: Was there an error?
      guard (error == nil) else {
        print("There was an error with your request: \(error)")
        return
      }

      // GUARD: Did we get a successful 2XX response?
      guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
        if let response = response as? NSHTTPURLResponse {
          print("Your request returned an invalid response! Status code: \(response.statusCode)!")
        } else if let response = response {
          print("Your request returned an invalid response! Response: \(response)!")
        } else {
          print("Your request returned an invalid response!")
        }
        return
      }

      // GUARD: Was there any data returned?
      guard let data = data else {
        print("No data was returned by the request!")
        return
      }

      var parsedResult: AnyObject!

      //get the JSON data
      do {
        parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String : AnyObject]
      } catch {
        parsedResult = nil
        print("Could not parse the data as JSON: '\(data)'")
        return
      }

      // GUARD: Did Flickr return an error (stat != ok)?
      guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
        print("Flickr API returned an error. See error code and message in \(parsedResult)")
        return
      }

      // GUARD: Are the "photos" and "photo" keys in our result?
      guard let photosDictionary = parsedResult["photos"] as? NSDictionary,
        photoArray = photosDictionary["photo"] as? [[String: AnyObject]] else {
          print("cannot find keys 'photos' and 'photo' in \(parsedResult)")
          return
      }

      //generate a random photo, then select it.
      let randomNumber = Int(arc4random_uniform(UInt32(photoArray.count)))
      let firstPhoto = photoArray[randomNumber] as [String: AnyObject]
      let photoURLM = firstPhoto["url_m"] as? String
      let photoTitle = firstPhoto["title"] as? String

      let imageURL = NSURL(string: photoURLM!)

      //GUARD: Does an image exist at the URL
      guard let imageData = NSData(contentsOfURL: imageURL!) else {
        print("error")
        return
      }
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.ImageView.image = UIImage(data: imageData)
        self.imageTitle.text = photoTitle
      })
    }

    task.resume()
  }

  //MARK: - escaped parameters metho
  func escapedParameters(parameters: [String: AnyObject]) -> String {

    var urlVars = [String]()

    for (key, value) in parameters {
      // Make sure that it is a string value
      let stringValue = "\(value)"

      //Escape it
      let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

      //Append it
      urlVars += [key + "=" + "\(escapedValue!)"]
    }

    return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
  }
  
  @IBAction func getNewImage(sender: UIButton) {
    getImageFromFlickr()
  }

}

