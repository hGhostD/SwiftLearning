import Cocoa
/*:
 > 代理模式的核心是一个对象--代理对象，此对象可以用于代表其他资源，此对象可以用于代表其他资源。
*/

func getHeader(header: String) {
    let url = URL(string: "https://www.baidu.com")!
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        print(error ?? "NoErr")
        if let httpResponse = response as? HTTPURLResponse {
            if let headerValue = httpResponse.allHeaderFields[header] as? String {
                print("\(header):\(headerValue)")
            }
        }
    }.resume()
}

let headers = ["Content-Length", "Content-Encoding"]
headers.forEach {
    getHeader(header: $0)
}

FileHandle.standardInput.availableData

protocol HttpHeaderRequest {
    func getHeader(url: String, header: String) -> String?
}

class HttpHeaderRequestProxy: HttpHeaderRequest {
    private let semaphore = DispatchSemaphore(value: 0)
    
    func getHeader(url: String, header: String) -> String? {
        var headerValue: String?
        
        let nsUrl = URL(string: url)!
        let request = URLRequest(url: nsUrl)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                headerValue = httpResponse.allHeaderFields[header] as? String
            }
            self.semaphore.signal()
        }.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return headerValue
    }
}

let url = "https://www.baidu.com"

let headers2 = ["Content-Length", "Content-Encoding"]
let proxy = HttpHeaderRequestProxy()

headers2.forEach {
    if let val = proxy.getHeader(url: url, header: $0) {
        print($0 + ":" + val)
    }
}
