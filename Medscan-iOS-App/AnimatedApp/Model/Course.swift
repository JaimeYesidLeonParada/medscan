//
//  Course.swift
//  AnimatedApp
//
//  Created by Meng To on 2022-04-14.
//

import SwiftUI

struct Course: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var caption: String
    var color: Color
    var image: Image
}

var courses = [
    Course(title: "Medicamento 1", subtitle: "Este medicamento te fue recetado para tu dolencia.", caption: "20 pastillas - 3 semanas", color: Color(hex: "7850F0"), image: Image("pill-1")),
    Course(title: "Medicamento 2", subtitle: "Este es un suplemento vitaminico para reforzar defensas.", caption: "1 pastilla - 15 semanas", color: Color(hex: "6792FF"), image: Image("pill-2")),
    Course(title: "Medicamento 3", subtitle: "Este es un anticonceptivo homeopatico.", caption: "2 pastillas - 6 meses", color: Color(hex: "005FE7"), image: Image("pill-1"))
]
