import Foundation
import SwiftUI

extension ContentView {
    class ViewModel: ObservableObject {
        @AppStorage("AUTH_KEY") var authenticated = false {
            willSet { objectWillChange.send() }
        }
        @AppStorage("USER_KEY") var username = ""
        @Published var password = ""
        @Published var invalid: Bool = false
        
        private var sampleUser = "123"
        private var samplePassword = "abc"
        
        struct Model: Decodable {
            let id: Int
            let albumId: Int
            let title: String
            let url: String
            let thumbnailUrl: String
        }
        
        @Published var items = [Model]()
        
        init() {
            print("Current logged on: \(authenticated)")
            print("Current user: \(username)")
        }
        
        func toggleAuthentication() {
            self.password = ""
            
            withAnimation {
                authenticated.toggle()
            }
        }
        
        func authenticate() {
            guard self.username.lowercased() == sampleUser else {
                self.invalid = true
                return
            }
            guard self.password.lowercased() == samplePassword else {
                self.invalid = true
                return
            }
            
            toggleAuthentication()
        }
        
        func logOut() {
            toggleAuthentication()
        }
        
        func logPressed() {
            print("Button pressed")
        }
        
        func fetchData() async {
            let api = "https://jsonplaceholder.typicode.com/photos"
            guard let url = URL(string: api) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
              do {
                 if let data = data {
                   let result = try JSONDecoder().decode([Model].self, from: data)
                   DispatchQueue.main.async {
                      self.items = result
                   }
                 } else {
                   print("No data")
                 }
              } catch (let error) {
                 print(error.localizedDescription)
              }
             }.resume()
        }
    }
}
