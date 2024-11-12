import Foundation

struct Character: Codable, Identifiable {
    var id: UUID? = UUID()
    var expediente_invima: String
    var principio_activo: String
    var concentracion: String
    var unidad_base: String
    var unidad_de_dispensacion: String
    var nombre_comercial: String
    var fabricante: String
    var medicamento: String
    var canal: String
    var precio_por_tableta: String
    var factoresprecio: String
    var numerofactor: String
}

struct APICharacterData: Codable {
    var count: Int
    var results: [Character]
}

struct APIResult: Codable {
    var data: APICharacterData
}
