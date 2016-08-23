//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


var str = "My fellow {plural noun}, now is the time to {verb} your voices.  Cast your {noun} for me! {yow}"


class story {
  var template: String
  var frags = [String]()
  var variables = [String]()
  var values = [String]()

  init (contentsOf url: URL) {
    let data = try? String(contentsOf: url, encoding: .utf8)
    if (data != nil) {
      template = data!
      processTemplate()
    } else {
      template = "Failed to read \(url)"
    }
  }

  private func processTemplate()
  {
    let s = template
    var range = s.startIndex ..< s.endIndex
    var match: Range<String.Index>?
    var prevIndex = s.startIndex

    repeat {
      /*
       * Using a regular expression here is a bit much, but it's handy.
       * Note that the "*?" operator is a non-greedy version of the usual "*".
       * That is, "*?" matches as few times as possible.
       */
      match = s.range(of: "\\{.*?\\}", options: .regularExpression, range: range)
      if let r = match {
        frags.append(s.substring(with: prevIndex ..< r.lowerBound))
        prevIndex = r.upperBound

        let low = s.index(r.lowerBound, offsetBy: 1)
        let high = s.index(r.upperBound, offsetBy: -1)
        variables.append(s.substring(with: low ..< high))

        range = high ..< s.endIndex
      }
    } while (match != nil)

    if (prevIndex < s.endIndex) {
      frags.append(s.substring(with: prevIndex ..< s.endIndex))
    }
  }
  
}

var text: String

/*
do {
  let url = playgroundSharedDataDirectory.appendingPathComponent("story.txt")
  text = try String(contentsOf: url, encoding: .utf8)
  let s = story(contentsOf: url)
} catch let error as NSError {
  text = "nothing"
  print("Error: \(error.localizedDescription)")
}

*/

let header = "Title: Little Red Riding Hood\nAuthor: Claude Perrault\n\nFoo."
let colon = header.characters.index(of: ":")
let key = header.substring(to: colon!)
let value = header.substring(from: header.index(after: colon!))

func foo (headerString: String) -> [String : String] {
  var headers: [String : String] = [:]

  headerString.enumerateLines { (line, done) -> () in
    if let colon = line.characters.index(of: ":") {
      let key = line.substring(to: colon)
      let value = line.substring(from: line.index(after: colon))
      headers[key] = value.trimmingCharacters(in: CharacterSet.whitespaces)
    }
  }
  return headers
}

let dict = foo(headerString: header)
print(dict["Title"])
print(dict)
header.characters.index(of: "\n\n")
