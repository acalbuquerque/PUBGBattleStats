import Foundation

final class JSONLoader {
    
    func loadJSON(filename: String) -> Data? {
        guard let jsonFilePath = Bundle(for: type(of: self)).path(forResource: filename, ofType: "json"),
            let jsonString = try? String(contentsOfFile: jsonFilePath),
            let jsonData = jsonString.data(using: .utf8)
            else { return nil }
        
        return jsonData
    }
    
    func loadJSONObj(filename: String) -> Any {
        
        let bundle = Bundle(for: type(of: self))
        
        let jsonURL = bundle.url(forResource: filename, withExtension: "json")!
        let data = try! Data(contentsOf: jsonURL)
        let jsonObj = try! JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        return jsonObj
    }
}
