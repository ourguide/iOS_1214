
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

// 런타임 프로토콜은 프로토콜을 만족하는 다양한 타입을 한번에 모아서 관리할 수 있다.
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
// let countries = [
//  America(),
//  America(),
//  America(),
// ]

for c in countries {
  print("\(c.name) - \(c.exchangeRate)")
}

let world = World(countries: countries)

print(type(of: world))
print(type(of: world.countries))

func processCountryRuntime(country: Country, completion: (Country) -> Void) {
  print("\(country.name) - \(country.exchangeRate)")

  completion(country)
}

// Generic 기반으로 처리하면, 불필요한 캐스팅을 없앨 수 있다.
func processCountryCompile<T: Country>(country: T, completion: (T) -> Void) {
  print("\(country.name) - \(country.exchangeRate)")
  completion(country)
}

extension Korea {
  func hangul() {
    print("한글")
  }
}

processCountryRuntime(country: Korea(), completion: { (korea: Country) in
  // 프로토콜을 만족하는 타입의 고유한 기능을 이용하기 위해서는 캐스팅이 필요하다.
  if let korea = korea as? Korea {
    korea.hangul()
  }
})

processCountryCompile(country: Korea()) { (korea: Korea) in
  korea.hangul()
}

// 결론
// - 런타임 프로토콜은 프로토콜 만족하는 다양한 타입을 한번에 관리할 수 있다.
// - 컴파일타임 프로토콜은 구체적인 타입에 대한 기능을 별도의 캐스팅이 없이 사용 가능하다.
