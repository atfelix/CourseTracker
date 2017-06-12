//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, playground"

//
//func fetchQuote(completionHandler: @escaping (Quote) -> Void){
//    
//    let url = URL(string: "http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en")
//    let session = URLSession(configuration: URLSessionConfiguration.default)
//    let dataTask = session.dataTask(with: url!, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//        
//        guard let data = data else {
//            print("No data, \(String(describing: error?.localizedDescription))")
//            return
//        }
//        
//        guard let realResponse = response as? HTTPURLResponse, realResponse.statusCode == 200 else{
//            print("Not a 200 response")
//            return
//        }
//        
//        var jsonObject:[String: String]?
//        
//        do{ jsonObject = try JSONSerialization.jsonObject(with: data) as? Dictionary<String, String>
//        }
//        catch {
//            print(error.localizedDescription)
//        }
//        
//        guard let json = jsonObject else{
//            print("Error with JSON!")
//            return
//        }
//        //set data to newQuote
//        let newQuote = Quote()
//        newQuote.quoteAuthor = json["quoteAuthor"]!
//        newQuote.quoteText = json["quoteText"]!
//        
//        completionHandler(newQuote)
//    })
//    dataTask.resume()
//}

var components = URLComponents()
components.scheme = "https"
components.host = "cobalt.qas.im"
components.path = "/api/1.0/buildings/080"
components.queryItems = [URLQueryItem(name:"key", value:"UofTKey")]

print(components.url ?? "")

let session = URLSession(configuration: .default)
let dataTask = session.dataTask(with: components.url!, completionHandler: { (data, response, error) in
    guard let data = data else {
        print("No data, \(String(describing: error?.localizedDescription))")
        return
    }
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        print("Not a 200 response")
        return
    }
    
    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
    
    if let responseJSON = responseJSON as? [String:Any] {
        print("RESPONSE OKAY")
        print(responseJSON)
    }
})
dataTask.resume()