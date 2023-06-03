//
//  SwiftUIView.swift
//  Money Counter
//
//  Created by Илья Курлович on 03.06.2023.
//

import SwiftUI

struct SwiftUIView: View {
    
    @State private var usdRate: Double = 0.0
    
    var body: some View {
        Text("1 GEL = \(usdRate) USD")
            .onAppear(perform: loadData)
    }
    func loadData() {
        let url = URL(string: "https://api.exchangeratesapi.io/latest?base=GEL&symbols=USD")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let rates = json["rates"] as? [String: Double] {
                        if let rate = rates["USD"] {
                            DispatchQueue.main.async {
                                self.usdRate = rate
                            }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
