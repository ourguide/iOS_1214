
import Foundation

// POP
//  - Protocol Oriented Programming
//   1) 런타임 프로토콜: Java/Kotlin 에서 사용하는 인터페이스의 기반 프로그래밍
//   2) 컴파일타임 프로토콜: Generic을 이용한 컴파일 타임에 코드를 생성하는 프로그래밍

protocol Country {
  var name: String { get }
  var exchangeRate: Float { get set }
}

struct Korea: Country {
  var name: String = "Korea"
  var exchangeRate: Float = 1200
}

struct America: Country {
  var name: String = "US"
  var exchangeRate: Float = 1
}

// Generic
#if false
class World<C: Country> {
  var countries: [C]

  init(countries: [C]) {
    self.countries = countries
  }

  func addCountry(_ country: C) {
    countries.append(country)
  }
}
#endif

class World {
  var countries: [Country]

  init(countries: [Country]) {
    self.countries = countries
  }

  func addCountry(_ country: Country) {
    countries.append(country)
  }
}

 let countries: [Country] = [
  Korea(),
  America(),
 ]
//let countries = [
//  America(),
//  America(),
//  America(),
//]

for c in countries {
  print("\(c.name) - \(c.exchangeRate)")
}

let world = World(countries: countries)

print(type(of: world))
print(type(of: world.countries))
