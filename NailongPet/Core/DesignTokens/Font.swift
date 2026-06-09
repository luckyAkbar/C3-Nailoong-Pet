//
//  Font.swift
//  NailongPet
//
//  Design Token - Single Source of Truth untuk semua tipografi aplikasi.
//  Menggunakan Font.system(_:design:weight:) agar mendukung Dynamic Type —
//  ukuran teks mengikuti preferensi aksesibilitas pengguna secara otomatis.
//
//  Mapping ke iOS text style (base size default):
//    largeTitleBold  → .largeTitle   (~34 pt)
//    title1Bold      → .title        (~28 pt)
//    title2Bold      → .title2       (~22 pt)
//    title3Bold      → .title3       (~20 pt)
//    calloutBold     → .callout      (~16 pt, bold)
//    calloutRegular  → .callout      (~16 pt, regular)
//    subheadBold     → .subheadline  (~15 pt, bold)
//    subheadRegular  → .subheadline  (~15 pt, regular)
//    footnoteRegular → .footnote     (~13 pt)
//    captionRegular  → .caption      (~12 pt)
//

import SwiftUI

extension Font {

    // MARK: - Display & Titles

    /// Large Title (~34 pt) — Empty state hero numbers, large decorative text
    static let largeTitleBold = Font.system(.largeTitle, design: .rounded, weight: .bold)

    /// Title 1 (~28 pt) — Home screen heading
    static let title1Bold = Font.system(.title, design: .rounded, weight: .bold)

    /// Title 2 (~22 pt) — Page titles, section headers
    static let title2Bold = Font.system(.title2, design: .rounded, weight: .bold)

    /// Title 3 (~20 pt) — Sub-section headers, overlay titles
    static let title3Bold = Font.system(.title3, design: .rounded, weight: .bold)

    // MARK: - Body & UI

    /// Callout Bold (~16 pt) — Toolbar icon labels, button labels
    static let calloutBold = Font.system(.callout, design: .rounded, weight: .bold)

    /// Callout Regular (~16 pt) — Overlay body text, instruction text
    static let calloutRegular = Font.system(.callout, design: .rounded, weight: .regular)

    /// Subhead Bold (~15 pt) — Emphasis body text, pill button labels
    static let subheadBold = Font.system(.subheadline, design: .rounded, weight: .bold)

    /// Subhead Regular (~15 pt) — Body text, guidelines
    static let subheadRegular = Font.system(.subheadline, design: .rounded, weight: .regular)

    // MARK: - Small

    /// Footnote Regular (~13 pt) — Small interaction labels
    static let footnoteRegular = Font.system(.footnote, design: .rounded, weight: .regular)

    /// Caption Regular (~12 pt) — Smallest readable text, row item labels
    static let captionRegular = Font.system(.caption, design: .rounded, weight: .regular)
}
