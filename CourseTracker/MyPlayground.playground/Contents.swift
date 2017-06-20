//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

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
