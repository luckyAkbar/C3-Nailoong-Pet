//
//  AppRoute.swift
//  NailongPet
//
//  Design Token - Single Source of Truth untuk semua tujuan navigasi di app.
//  Setiap case mewakili satu layar yang bisa di-push ke NavigationStack.
//

import Foundation

enum AppRoute: Hashable {
    case choose3DGeneratorTech
    case mlSharp
    case lidar
    case processPage
    case processPetDetail
    case pet3DGallery
    case petDetail(Pet3DProfile)   // associated value: data pet yang dipilih
    case arInteraction
}
