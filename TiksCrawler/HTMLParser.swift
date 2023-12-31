//
//  HTMLParser.swift
//  TiksCrawler
//
//  Created by Dương Nguyễn on 20/12/2023.
//

import Foundation
import SwiftSoup
import SwiftyJSON

final class HTMLParser {
    
    func getInfo(link: String) {
        do {
            print("--------- GET INFO DOWNLOAD--------")
            guard let url = URL(string: link) else {return}
            let html = try String(contentsOf: url)
            self.parse(html: html)
            getCookie(url)
            print("--------- Referer:")
            print("https://www.tiktok.com/")
            print("--------- END GET INFO DOWNLOAD--------")
        } catch {
            return;
        }
    }
    
    func parse(html: String) {
        do {
            let document: Document = try SwiftSoup.parse(html)
            guard let body = document.body() else {
                return
            }
            let jsonString = try? body.getElementById("__UNIVERSAL_DATA_FOR_REHYDRATION__")?.html()
            guard let jsonData = jsonString?.data(using: .utf8)! else { return }
            let json = try? JSON(data: jsonData)
            let itemStruct = json?["__DEFAULT_SCOPE__"]["webapp.video-detail"]["itemInfo"]["itemStruct"]
            let video = itemStruct?["video"]
            if let linkReview = video?["downloadAddr"].string {
                print("--------- Link review:")
                print(linkReview)
            }
            if let link = video?["playAddr"].string {
                print("--------- Link download:")
                print(link)
            }
            let stats = itemStruct?["stats"]
            if let playCount = stats?["playCount"].number {
                print("--------- Play Count:")
                print(playCount)
            }
        } catch {
            print("Error get info video tiktok: " + String(describing: error))
        }
    }
    
    func getCookie(_ url: URL) {
        // Check if the response has cookies
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            print("--------- Cookie:")
            var cookieText = ""
            for cookie in cookies {
                cookieText += "\(cookie.name)=\(cookie.value);"
            }
            print(cookieText)
        }
    }
}
