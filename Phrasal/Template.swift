import Foundation

struct Template {
    let template: String
    let title: String
    let frags: [String]
    let variables: [String]
    var phrases = [String]()

    init(_ string: String) {
        template = string
        let (headerPart, bodyPart) = splitParts(string)
        let headers = parseHeaders(headerPart)
        if let val = headers["Title"] {
            title = val
        } else {
            title = "untitled"
        }
        
        let (f, v) = parseBody(bodyPart)
        frags = f
        variables = v
    }
    
    init (contentsOf url: URL) {
        let data = try? String(contentsOf: url, encoding: .utf8)
        if (data != nil) {
            self.init(data!)
        } else {
            self.init("Failed to read \(url)")
        }
    }
}

private func splitParts(_ s: String) -> (String, String)
{
    let all = s.startIndex ..< s.endIndex
    if let delimiter = s.range(of: "\n\n", options: .literal, range: all) {
        let headerPart = s[s.startIndex ..< delimiter.lowerBound]
        let bodyPart = s[delimiter.upperBound ..< s.endIndex]
        
        return (headerPart.trimmingCharacters(in: CharacterSet.whitespaces),
                bodyPart.trimmingCharacters(in: CharacterSet.whitespaces))
    } else {
        return ("", s.trimmingCharacters(in: CharacterSet.whitespaces))
    }
}

private func parseHeaders(_ s: String) -> [String : String]
{
    var headers: [String : String] = [:]
    
    s.enumerateLines { (line, done) -> () in
        if let colon = line.index(of: ":") {
            let aftercolon =  line.index(after: colon)
            let key = String(line[..<colon])
            let value = String(line[aftercolon...])
            headers[key] = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
    return headers
}

private func parseBody(_ s: String) -> ([String], [String])
{
    let all = s.startIndex ..< s.endIndex
    var range = all
    var match: Range<String.Index>?
    var prevIndex = s.startIndex
    var frags: [String] = []
    var variables: [String] = []
    
    repeat {
        /*
         * Using a regular expression here is a bit much, but it's handy.
         * Note that the "*?" operator is a non-greedy version of the usual "*".
         * That is, "*?" matches as few times as possible.
         */
        match = s.range(of: "\\{.*?\\}", options: .regularExpression, range: range)
        if let r = match {
            frags.append(String(s[prevIndex..<r.lowerBound]))
            prevIndex = r.upperBound
            
            let low = s.index(r.lowerBound, offsetBy: 1)
            let high = s.index(r.upperBound, offsetBy: -1)
            variables.append(String(s[low..<high]))
            
            range = high ..< s.endIndex
        }
    } while (match != nil)
    if (prevIndex < s.endIndex) {
        frags.append(String(s[prevIndex...]))
    }
    return (frags, variables)
}

