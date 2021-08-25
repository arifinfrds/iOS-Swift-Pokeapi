//
//  SwiftUIPokemonsView.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 25/08/21.
//

import SwiftUI

struct SwiftUIPokemonsView: View {
    
    var body: some View {
        
        List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
            SwiftUIPokemonCell()
        }
    }
}

struct SwiftUIPokemonsView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIPokemonsView()
    }
}
