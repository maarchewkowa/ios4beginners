//
//  JokeController.swift
//  Switter
//
//  Created by Karolina Beata Natalia Guzewska on 17.11.2017.
//  Copyright © 2017 Karolina Beata Natalia Guzewska. All rights reserved.
//
import UIKit

class JokeController: UIViewController {

    @IBOutlet weak var loadActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelJoke: UILabel!
    @IBOutlet weak var newJokeButton: UIButton!
    
    @IBAction func newJokeButtonPushed(_ sender: Any) {
        prepareToJokeDownload()
        
        let endpoint = "https://switter.int.daftcode.pl/api/joke"
        let url = URL(string: endpoint)!
        var urlRequest = URLRequest(url: url)
        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown device uuid"
        urlRequest.addValue(deviceUUID, forHTTPHeaderField: "x-device-uuid")
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        session.dataTask(with: urlRequest) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw JokeApiError.parsingDataFailed }
                guard let httpResponse = response as? HTTPURLResponse else { throw JokeApiError.parsingHTTPURLResponseFailed }
                
                if httpResponse.statusCode != 200 {
                    let responseString = String(data: data, encoding: .utf8) ?? "Could not parse response"
                    throw JokeApiError.unexpectedStatusCode(statusCode: httpResponse.statusCode, responseString: responseString)
                }
                
                let jsonDecoder = JSONDecoder()
                let decodedJoke = try jsonDecoder.decode(Joke.self, from: data)
                
                DispatchQueue.main.async {
                    self.setNewJoke(joke: decodedJoke)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    self.displayGettingJokeFailedMessage()
                }
            }
        }.resume()
    }
    
    func prepareToJokeDownload() {
        loadActivityIndicator.startAnimating()
        newJokeButton.isEnabled = false
        labelJoke.text = ""
    }
    
    func setNewJoke(joke: Joke) {
        labelJoke.text = joke.content
        resetControls()
    }
    
    func displayGettingJokeFailedMessage() {
        let alertController = UIAlertController(title: "Ups ☹️", message: "Nie udało się pobrać nowego dowcipu, spróbuj ponownie później", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        super.present(alertController, animated: true, completion: nil)
        resetControls()
    }
    
    func resetControls() {
        loadActivityIndicator.stopAnimating()
        newJokeButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

