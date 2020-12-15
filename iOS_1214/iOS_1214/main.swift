

import Foundation

#if false
protocol Job {
  func start(input: String) -> Bool
}

// 프로토콜은 제네릭 파라미터를 허용하지 않습니다.
// => 프로토콜 관계 타입을 사용해야 합니다. => PAT(Protocol Associated Type)
// protocol Job<Input, Output> {
//  func start(input: Input) -> Output
// }
#endif

#if true
protocol Job {
  associatedtype Input
  associatedtype Output

  func start(input: Input) -> Output
}

class MailJob: Job {
  // 명시적으로 PAT를 지정 하는 방법
  // => 생략하였을 경우, 컴파일러가 추론 가능하면, 자동으로 추론됩니다.
  typealias Input = String
  typealias Output = Bool

  @discardableResult
  func start(input: String) -> Bool {
    print("MailJob start - \(input)")
    return true
  }
}

let job = MailJob()
// job.start(input: "hello")

// 문제점
//  - Input과 Output의 타입이 다른 경우가 있습니다.
class DirRemover: Job {
  typealias Input = URL
  typealias Output = [String]

  func start(input: URL) -> [String] {
    do {
      var results = [String]()
      let fileManager = FileManager.default
      let fileUrls = try fileManager.contentsOfDirectory(at: input, includingPropertiesForKeys: nil)

      for file in fileUrls {
        try fileManager.removeItem(at: file)
        results.append(file.absoluteString)
      }

      return results

    } catch {
      print("Error - \(error)")
      return []
    }
  }
}

// PAT를 사용하면, Protocol에 컴파일 타임에 내부 타입을 결정할 수 있습니다.
// => PAT를 사용하면, 런타임 다형성을 지원하지 않습니다.
// let jobs: [Job] = [
//   MailJob(),
//   DirRemover(),
// ]

// => Job를 사용하는 코드를 만들때, 컴파일 타임 다형성을 사용해야 합니다.
func runJob<J: Job>(job: J, inputs: [J.Input]) {
  for input in inputs {
    _ = job.start(input: input)
  }
}

let emails = [
  "hello1@gmail.com",
  "hello2@gmail.com",
  "hello3@gmail.com",
]

// runJob(job: MailJob(), inputs: emails)

struct User {
  let email: String
}

func runJob<J: Job>(job: J, inputs: [J.Input]) where J.Input == User {
  for input in inputs {
    print(input.email) // J.Input 타입은 User이기 때문에, User의 고유 프로퍼티에 접근이 가능합니다.
    _ = job.start(input: input)
  }
}

let users = [
  User(email: "hello1@gmail.com"),
  User(email: "hello2@gmail.com"),
  User(email: "hello3@gmail.com"),
]

class UserMailJob: Job {
  typealias Input = User
  typealias Output = Bool

  @discardableResult
  func start(input: User) -> Bool {
    print("UserMailJob start - \(input.email)")
    return true
  }
}

// runJob(job: UserMailJob(), inputs: users)
#endif

class UIImage {}

// Input: UIImage
// Output: Bool

#if false
struct ImageCropper: Job {
  let size: CGSize

  func start(input: UIImage) -> Bool {
    print("이미지 크롭 - \(size)")
    return true
  }
}

// 아래처럼 제네릭에 제약이 반복적으로 필요할 경우, 프로토콜 상속을 통해 편리하게 관리할 수 있습니다.
struct ImageProcessor<J: Job> where J.Input == UIImage, J.Output == Bool {
  let job: J

  func start() {
    let image = UIImage()
    let result = job.start(input: image)
    print("ImageProcessor - \(result)")
  }
}
#endif

protocol ImageJob: Job where Input == UIImage, Output == Bool {
  // ...
}

struct ImageCropper: ImageJob {
  let size: CGSize

  func start(input: UIImage) -> Bool {
    print("이미지 크롭 - \(size)")
    return true
  }
}

struct ImageProcessor<J: ImageJob> {
  let job: J

  func start() {
    let image = UIImage()
    let result = job.start(input: image)
    print("ImageProcessor - \(result)")
  }
}

let cropper = ImageCropper(size: CGSize(width: 100, height: 200))
let processor = ImageProcessor(job: cropper)
processor.start()
