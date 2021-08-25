//
//  SwiftUIPokemonCell.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 25/08/21.
//

import SwiftUI

struct SwiftUIPokemonCell: View {
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5, content: {
            
            Spacer()
            
            Text("Bulbasaur")
                .font(.title3)
                .bold()
            
            Text("#001")
                .foregroundColor(.secondary)
            
            Spacer()
        })
        
    }
}

struct SwiftUIPokemonCell_Previews: PreviewProvider {
    
    static var previews: some View {
        SwiftUIPokemonCell()
    }
}
