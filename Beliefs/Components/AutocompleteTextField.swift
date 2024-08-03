import SwiftUI

struct AutocompleteTextField: View {
    @Binding var text: String
    var suggestions: [String]
    var onSuggestionSelected: (String) -> Void

    var body: some View {
        VStack {
            TextField("Enter or select category", text: $text)
                .onChange(of: text) { newValue, _ in
                    // Update logic if needed when text changes
                }
            if !suggestions.filter({ $0.hasPrefix(text) }).isEmpty && !text.isEmpty {
                List {
                    ForEach(suggestions.filter { $0.hasPrefix(text) }, id: \.self) { suggestion in
                        Text(suggestion).onTapGesture {
                            onSuggestionSelected(suggestion)
                            text = suggestion
                        }
                    }
                }
                .frame(maxHeight: 100)
            }
        }
    }
}
