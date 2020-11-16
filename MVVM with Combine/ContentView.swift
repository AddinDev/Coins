//
//  ContentView.swift
//  MVVM with Combine
//
//  Created by addjn on 16/11/20.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject private var viewModel = CoinListViewModel()
    
    var body: some View {
        NavigationView {
        List(viewModel.coinViewModels, id: \.self) { coin in
            Text(coin.displayText)
        }
            .onAppear {
                viewModel.fetchCoins()
            }
        .navigationBarTitle("Coins")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class CoinListViewModel: ObservableObject {
    
    private let cryptoService = CryptoService()
    
    @Published var coinViewModels = [CoinViewModel]()
    
    var cancellable: AnyCancellable?
    
    func fetchCoins() {
        cancellable = cryptoService.fetchCoins().sink(receiveCompletion: { _ in
            
        }, receiveValue: { cryptoContainer in
            self.coinViewModels = cryptoContainer.data.coins.map { CoinViewModel($0) }
            print(self.coinViewModels)
        })
    }
    
}

struct CoinViewModel: Hashable {
    private let coin: Coin
    
    var name: String {
        return coin.name
    }
    
    var formattedPrice: String {
        var numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        guard let price = Double(coin.price), let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) else {
            return ""
        }
        //do sumtin
        return formattedPrice
    }
    
    var displayText: String {
        return name + " - " + formattedPrice
    }
    
    init(_ coin: Coin) {
        self.coin = coin
    }
    
}


