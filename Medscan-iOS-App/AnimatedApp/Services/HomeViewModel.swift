import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var searchQuery = ""
    
    var searchCancellable: AnyCancellable? = nil
    
    @Published var fetchedCharacters: [Character]? = nil
    
    init() {
        searchCancellable = $searchQuery
            .removeDuplicates()
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str == "" {
                    self.fetchedCharacters = nil
                    
                } else {
                    self.searchCharacter()
                }
            })
    }
    
    func searchCharacter() {
        let originalQuery = searchQuery.replacingOccurrences(of: " ", with: "%20")
        let url = "https://www.datos.gov.co/resource/n4dj-8r7k.json?nombre_comercial=\(originalQuery)"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            guard let apiData = data else {
                print("no data found")
                return
            }
            
            do {
                var characters = try JSONDecoder().decode([Character].self, from: apiData)
                
                characters = characters.map { character in
                        var mutableCharacter = character
                        mutableCharacter.id = UUID()
                        return mutableCharacter
                    }
                
                DispatchQueue.main.async {
                    self.fetchedCharacters = characters
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
}
