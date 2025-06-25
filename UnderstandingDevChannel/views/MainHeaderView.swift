//
//  MainHeaderView.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 5/3/24.
//

import SwiftUI

struct MainHeaderView: View {
    
    @State var displaySearch = false;
    @State var searchText: String = ""
    private let debounceDelay = 0.3
    @State private var debouncedText: String = ""
    public var searchAction: (_ results: Any) -> Void = { results in }
    
    var body: some View {
        HStack {
            
            if !displaySearch {
                Image("youtube_icon")
                Text("Understanding Dev Channel").bold()
                
                Spacer()
                
                Button(action: {
                    displaySearch = true
                }) {
                    Image(systemName: "magnifyingglass")
                }
            } else {
                
                TextField("Search", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        Spacer()
                    }
                    .overlay {
                        Image(systemName: "multiply.circle.fill")
                            .frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                alignment: .trailing
                            )
                            .padding(.trailing, 8)
                            .onTapGesture {
                                searchText = ""
                            }
                    }
                    .onChange(of: searchText) { newValue in
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + debounceDelay) {

                            if newValue == searchText {
                                debouncedText = newValue
                                print("Debounced search: \(debouncedText)")
                                searchAction(debouncedText)
                            }
                            
                        }
                        print("User typed: \(newValue)")
                        
                    }
                
                Spacer()
                
                Button(action: {
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                    displaySearch.toggle()
                }) {
                    Text("Cancel")
                }
                .transition(.move(edge: .trailing))
                .animation(.default)
                
            }
                
            
        }.padding(.leading)
            .padding(.trailing)
    }
}

#Preview {
    MainHeaderView()
}
