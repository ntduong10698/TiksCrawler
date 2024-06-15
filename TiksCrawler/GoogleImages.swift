//
//  HTMLParserGoogleImages.swift
//  TiksCrawler
//
//  Created by Dương Nguyễn on 08/06/2024.
//

import Foundation
import SwiftSoup
import SwiftyJSON
import UIKit
import SwiftyJSON

final class GoogleImages {

    /*
     query: keyword search
     start: 0, 10, 20 .....
     */
    func search(query: String, start: Int) {
        guard let url = URL(string: "https://www.google.com/search?udm=2&q=\(query)&start=\(start)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Check for valid response and data
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP Error: \(httpResponse.statusCode)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            guard let html = String(data: data, encoding: .utf8) else {
                print("Failed to decode HTML content")
                return
            }

            do {
                let document = try SwiftSoup.parse(html)
                let scripts = try document.getElementsByTag("script")
                for script in scripts {
                    if let content = try? script.html() {
                        //start code change hd
                        if (content.contains("google.jl")) {
                            let functions = content.split(separator: "(function(){")
                            for function in functions {
                                if (function.contains("var m")
                                    && (function.contains(".webp")
                                        || function.contains(".jpg")
                                        || function.contains(".jpeg")
                                        || function.contains(".png")
                                        || function.contains(".gif"))) {
                                    let jsonString = function.split(separator: "var m=")[0].split(separator: "};")[0] + "}";
                                    self.getImagesFromJson(jsonString: String(jsonString))
                                }
                            }
                        }
                        //end code change hd
                    }
                }
            } catch {
                print("Error parsing HTML: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    
    func getImagesFromJson(jsonString: String) {
        let jsonData = jsonString.data(using: .utf8)!
        guard let json = try? JSON(data: jsonData) else {
            return;
        }
        for (_, subJson): (String, JSON) in json {
            if (subJson.arrayValue.count > 2) {
                let subJson1 = subJson.arrayValue[1]
                if (subJson1.arrayValue.count > 4) {
                    let subJson2 = subJson1.arrayValue[3]
                    if (subJson2.arrayValue.count > 1) {
                        let link = subJson2.arrayValue[0].string ?? "";
                        // link crawler hd - check thêm định dạng đuôi ảnh thì view còn lại loại
                        print(link)
                    }
                }
            }
            print("-----------------")
        }
    }

    //function convert base64 to images
    func imageFromBase64(base64String: String) -> UIImage? {
        if let data = Data(base64Encoded: base64String) {
            return UIImage(data: data)
        }
        return nil
    }

}

