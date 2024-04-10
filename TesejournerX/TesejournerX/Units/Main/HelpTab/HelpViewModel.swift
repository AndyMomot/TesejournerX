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
            .init(title: "Jakie informacje są dostępne na stronie 'Budżet'?",
                  description: "• Strona 'Budżet' zapewnia alternatywne spojrzenie na Twoje dane finansowe, oferując statystyczne spojrzenie na Twoje wydatki i przychody. Dzięki wizualnym reprezentacjom, takim jak wykresy i grafiki, możesz uzyskać głębsze zrozumienie swoich wzorców wydatków i tendencji finansowych na przestrzeni czasu. To analityczne podejście do budżetowania pozwala zidentyfikować obszary, w których możesz wydawać za dużo lub za mało, umożliwiając podejmowanie świadomych dostosowań budżetu i celów finansowych."),
            .init(title: "Jaki jest cel strony 'Ustawienia budżetu'?",
                  description: "• Strona 'Ustawienia budżetu' oferuje przyjazny użytkownikowi interfejs do wprowadzania przychodu lub wydatków do Twojego budżetu. Tutaj możesz łatwo dodawać lub edytować transakcje finansowe, dostosowywać kategorie budżetowe i ustawiać limity budżetowe dla każdej kategorii, zgodnie z Twoimi celami finansowymi i priorytetami. To elastyczne podejście do zarządzania budżetem pozwala dostosować budżet do swoich indywidualnych potrzeb i preferencji, zapewniając, że pozostajesz na ścieżce do realizacji swoich planów i celów finansowych."),
            .init(title: "Czy są dostępne dodatkowe ustawienia?",
                  description: "• Tak, możesz uzyskać dostęp do dodatkowych ustawień w sekcji 'Ustawienia' w celu dalszej personalizacji aplikacji. Od preferencji konta po ustawienia powiadomień, ta sekcja pozwala dostosować aplikację do swoich konkretnych wymagań i preferencji. Czy to dostosowanie ustawień wyświetlania, włączanie funkcji zabezpieczeń czy synchronizowanie danych między urządzeniami, sekcja Ustawienia zapewnia elastyczność i kontrolę, której potrzebujesz, aby zoptymalizować swoje doświadczenie użytkownika i maksymalizować korzyści z aplikacji."),
            .init(title: "Co znajduje się na stronie 'Główny'?",
                  description: " ◦ Strona 'Główny' służy jako wszechstronne podsumowanie Twoich działań finansowych, wyświetlając zarówno przychody, jak i wydatki z kategoriami według dnia, miesiąca i dzisiaj. Pozwala to łatwo śledzić przepływ finansowy w różnych okresach czasu, co ułatwia lepsze zarządzanie budżetem i planowanie finansowe. Dodatkowo, dla zwiększenia wygody, masz możliwość dostępu do niestandardowego kalendarza bezpośrednio z tej strony. Funkcja kalendarza zapewnia wizualne przedstawienie Twoich transakcji finansowych, umożliwiając planowanie i organizację wydatków oraz przychodów w bardziej efektywny sposób."),
            .init(title: "Co znajduje się na stronie 'Ulubione'?",
                  description: "• Na stronie 'Ulubione' znajdziesz skomponowaną listę wydatków, które oznaczyłeś jako ulubione dla szybkiego odniesienia. Ta funkcja pozwala łatwo identyfikować i uzyskiwać dostęp do często występujących wydatków, bez konieczności przeszukiwania całej historii transakcji. Czy to powtarzające się rachunki, regularne zakupy czy konkretne transakcje, których chcesz śledzić, oznaczenie ich jako ulubione zapewnia wygodny sposób monitorowania i zarządzania swoimi nawykami wydatkowymi."),
            .init(title: "Jak korzystać ze strony 'Koszty'?",
                  description: " • Strona 'Koszty' służy jako centralne miejsce do rejestrowania zarówno wydatków, jak i przychodów. Tutaj możesz łatwo wprowadzić szczegóły każdej transakcji finansowej, w tym kategorię, kwotę, datę i dodatkowe notatki. To kompleksowe podejście do śledzenia wydatków zapewnia klarowny i dokładny zapis wszystkich Twoich działań finansowych, ułatwiając lepsze zarządzanie finansami i podejmowanie decyzji. Czy to rutynowy wydatek czy niespodziewany przychód, strona Koszty pozwala zachować porządek i kontrolę nad finansami.")
        ]
        
        let helpURL = "https://support.tesejournerx.info"
    }
}

extension HelpView {
    struct HelpCellModel: Identifiable {
        var id = UUID().uuidString
        var title: String
        var description: String
    }
}
