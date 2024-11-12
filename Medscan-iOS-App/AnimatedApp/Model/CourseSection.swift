//
//  CourseSection.swift
//  AnimatedApp
//
//  Created by Meng To on 2022-04-14.
//

import SwiftUI

struct CourseSection: Identifiable {
    var id = UUID()
    var title: String
    var caption: String
    var color: Color
    var image: Image
}

var courseSections = [
    CourseSection(title: "Medicamento 3", caption: "Siguiente toma - 15 mins", color: Color(hex: "9CC5FF"), image: Image("pill-2")),
    CourseSection(title: "Medicamento 1", caption: "Quedan 5 pildoras", color: Color(hex: "6E6AE8"), image: Image("pill-1")),
    CourseSection(title: "Medicamento 2", caption: "Viene en camino - 8 mins", color: Color(hex: "005FE7"), image: Image("pill-1")),
    CourseSection(title: "Notificación", caption: "Padre acaba de seguirte.", color: Color(hex: "BBA6FF"), image: Image("pill-2"))
]
