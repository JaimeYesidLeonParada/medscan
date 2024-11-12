//
//  SearchView.swift
//  AnimatedApp
//
//  Created by Jaime Leon Parada on 12/11/24.
//
import SwiftUI

/*struct SearchView: View {
    let title: String
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(title)
                .font(.title)
                .foregroundColor(.black)
                .padding()
            
            Text("This is the \(title.lowercased())")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Asegura que ocupe todo el espacio disponible
        .background(Color.white) // Fondo blanco para toda la vista de contenido
        .edgesIgnoringSafeArea(.all) // Permite que ocupe toda el área, ignorando los bordes seguros
    }
}*/

//
//  CharactersView.swift
//  TempMedicamentos
//
//  Created by Jaime Leon Parada on 29/10/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var homeData: HomeViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search Character", text: $homeData.searchQuery)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y:5)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
                }
                .padding()
                
                if let characters = homeData.fetchedCharacters {
                    if characters.isEmpty {
                        Text ("No hay resultados")
                            .padding(.top, 20)
                    } else {
                        ForEach(characters) { data in
                            SearchRowView(character: data)
                        }
                    }
                    
                } else {
                    if homeData.searchQuery != "" {
                        ProgressView()
                            .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Medicamentos")
        }
    }
}

#Preview {
    ContentView()
}

struct SearchRowView: View {
    var character: Character
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image("icono-medicamento")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height:150)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(character.nombre_comercial)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(character.medicamento)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(4)
            }
            
            Spacer()
        }
    }
    
    func extractImage(data: [String: String]) -> URL {
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        return URL(string: "\(path).\(ext)")!
    }
}

