import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: LogicaVM
    
    // Основные свойства вводимые пользователем
    @State private var valutoSelect: String = "USD"
    @State private var enterMoney: Double = 0

    // Строка фокуссирования на клавиатуре
    @FocusState private var amountIsFocused: Bool
    
    // Курс к доллару
    @State private var courseEUR_USD: Double = 1.07
    @State private var courseGEL_USD: Double = 0.37955
    @State private var courseRUB_USD: Double = 0.012365
    
    // Курс к евро
    @State private var courseUSD_EUR: Double = 0.93379
    @State private var courseGEL_EUR: Double = 0.35493
    @State private var courseRUB_EUR: Double = 0.011481
   
    // Курс к лари
    @State private var courseUSD_GEL: Double = 2.82
    @State private var courseEUR_GEL: Double = 2.63
    @State private var courseRUB_GEL: Double = 0.032545
    
    // Курс к рублю
    @State private var courseUSD_RUB: Double = 80.88
    @State private var courseEUR_RUB: Double = 87.1
    @State private var courseGEL_RUB: Double = 30.64
    
    // Секция сегментарного выбора валют 1 шага
    let valutoSelected = ["USD", "EUR", "GEL", "RUB"]
    
    // Основные свойства для выбора валют в 3 шаге
    @State private var UsdGelRubSelect: String = "USD"
    let UsdGelRubSelected = ["USD", "EUR", "GEL", "RUB"]
    
    var body: some View {
        NavigationView {
            Form {
                // Секция выбора валют
                Section {
                    Picker("", selection: $valutoSelect) {
                        ForEach(valutoSelected, id: \.self) {
                            Text("\($0)")
                        }
                    } .pickerStyle(.segmented)
                } header: {
                    Text("1 шаг. Выберете валюту внесения")
                }
                // секция ввода средств
                Section {
                    HStack {
                        TextField("Сумма", value: $enterMoney, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($amountIsFocused)
                        
                        Button ("| внести средства") {
                            if valutoSelect == "USD" {
                                vm.enterMoneyUSD.append(enterMoney)
                            } else if valutoSelect == "GEL" {
                                vm.enterMoneyGEL.append(enterMoney)
                            } else if valutoSelect == "EUR" {
                                vm.enterMoneyEUR.append(enterMoney)
                            } else {
                                vm.enterMoneyRUB.append(enterMoney)
                            }
                            vm.generator.selectionChanged()
                        }
                    }
                } header: {
                    Text("2 шаг. Внесите средства в кошелёк")
                }
                
                Section {
                    // Сумма всех элементов в массиве USD
                    let sumUSD = vm.enterMoneyUSD.reduce(0, +)
                    HStack {
                        Text("В кошельке:")
                        if valutoSelect == "USD" {
                            Image(systemName: "arrowshape.right.fill")
                                .foregroundColor(.accentColor)
                        }
                        Spacer()
                        Text("\(sumUSD, format: .currency(code: "USD"))")
                        Image(systemName: "trash.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.accentColor)
                            .onTapGesture {
                                vm.enterMoneyUSD.removeAll()
                                vm.generator.selectionChanged()
                            }
                    }
                    // Сумма всех элементов в массиве USD
                    let sumEUR = vm.enterMoneyEUR.reduce(0, +)
                    HStack {
                        Text("В кошельке:")
                        if valutoSelect == "EUR" {
                            Image(systemName: "arrowshape.right.fill")
                                .foregroundColor(.accentColor)
                        }
                        Spacer()
                        Text("\(sumEUR, format: .currency(code: "EUR"))")
                        Image(systemName: "trash.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.accentColor)
                            .onTapGesture {
                                vm.enterMoneyEUR.removeAll()
                                vm.generator.selectionChanged()
                            }
                    }
                    
                    // Сумма всех элементов в массиве GEL
                    let sumGEL = vm.enterMoneyGEL.reduce(0, +)
                    HStack {
                        Text("В кошельке:")
                        if valutoSelect == "GEL" {
                            Image(systemName: "arrowshape.right.fill")
                                .foregroundColor(.accentColor)
                        }
                        Spacer()
                        Text("\(sumGEL, format: .currency(code: "GEL"))")
                        Image(systemName: "trash.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.accentColor)
                            .onTapGesture {
                                vm.enterMoneyGEL.removeAll()
                                vm.generator.selectionChanged()
                            }
                    }
                    // Сумма всех элементов в массиве RUB
                    let sumRUB = vm.enterMoneyRUB.reduce(0, +)
                    HStack {
                        Text("В кошельке:")
                        if valutoSelect == "RUB" {
                            Image(systemName: "arrowshape.right.fill")
                                .foregroundColor(.accentColor)
                        }
                        Spacer()
                        Text("\(sumRUB, format: .currency(code: "RUB"))")
                        Image(systemName: "trash.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.accentColor)
                            .onTapGesture {
                                vm.enterMoneyRUB.removeAll()
                                vm.generator.selectionChanged()
                            }
                    }
                } header: {
                    Text("Сумма средств в USD, EUR, GEL, RUB")
                }
                
                // Секция выбора и вычисления суммы всех кошельков в одной валюте
                Section {
                    Picker("", selection: $UsdGelRubSelect) {
                        ForEach(UsdGelRubSelected, id: \.self) {
                            Text("\($0)")
                        }
                    } .pickerStyle(.segmented)
                    
                    // Предварительный блок математики сумммы всех валют
                    let matematicaSuk = { (whatValuto: String) -> Double in
                        var summaUSD = vm.enterMoneyUSD.reduce(0, +)
                        var summaEUR = vm.enterMoneyEUR.reduce(0, +)
                        var summaGEL = vm.enterMoneyGEL.reduce(0, +)
                        var summaRUB = vm.enterMoneyRUB.reduce(0, +)
                        if whatValuto == "USD" {
                            summaEUR = summaEUR * courseEUR_USD
                            summaGEL = summaGEL * courseGEL_USD
                            summaRUB = summaRUB * courseRUB_USD
                            return summaUSD + summaEUR + summaGEL + summaRUB
                        } else if whatValuto == "EUR" {
                            summaUSD = summaUSD * courseUSD_EUR
                            summaGEL = summaGEL * courseGEL_EUR
                            summaRUB = summaRUB * courseRUB_EUR
                            return summaUSD + summaEUR + summaGEL + summaRUB
                        } else if whatValuto == "GEL" {
                            summaUSD = summaUSD * courseUSD_GEL
                            summaEUR = summaEUR * courseEUR_GEL
                            summaRUB = summaRUB * courseRUB_GEL
                            return summaUSD + summaEUR + summaGEL + summaRUB
                        } else if whatValuto == "RUB" {
                            summaUSD = summaUSD * courseUSD_RUB
                            summaEUR = summaEUR * courseEUR_RUB
                            summaGEL = summaGEL * courseGEL_RUB
                            return summaUSD + summaEUR + summaGEL + summaRUB
                        } else {
                            return 0
                        }
                    }
                    
                    HStack {
                        Text("Сумма кошельков в выбранной валюте:")
                        Spacer()
                        Text("\(matematicaSuk("\(UsdGelRubSelect)"), format: .currency(code: UsdGelRubSelect))")
                    }
                } header: {
                    Text("3 Шаг. Выберете валюту для вычисления всех средств в 1 выбранной валюте")
                }

            }
            // Общее оформление вида и доп кнопка к клавиатуре для сворачивания
            .navigationBarTitle("Сумма в 4 валютах")
            .navigationTitle("Считаем \"Гроши\"")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Готово") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(LogicaVM())
    }
}
