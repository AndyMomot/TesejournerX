//
//  HelpViewModel.swift
//  TesejournerX
//
//  Created by Andrii Momot on 04.04.2024.
//

import Foundation

extension HelpView {
    final class HelpViewModel: ObservableObject {
        let dataSource: [HelpCellModel] = [
            .init(title: "Jak utworzyć nową kategorię?",
                  description: "Przejdź do menu w prawym górnym rogu, wybierz opcję 'Konfiguracja kategorii', a następnie kliknij 'Utwórz nową kategorię'."),
            .init(title: "Jak dodać wydatki?",
                  description: "Skorzystaj z menu w prawym górnym rogu lub na ekranie głównym, u dołu, kliknij znak plus."),
            .init(title: "Jak dodać ulubione?",
                  description: "Na stronie głównej kliknij gwiazdkę, aby zobaczyć historię ulubionych, а потім натисни знак плюс на екрані głównym u dołu.")
        ]
        
        let heltURL = "https://www.google.com"
    }
}

extension HelpView {
    struct HelpCellModel: Identifiable {
        var id = UUID().uuidString
        var title: String
        var description: String
    }
}
