import UIKit

import RxCocoa
import RxSwift

// 1) compactMap
// 2) filter

// - 클로저에서 참조 계수 기반의 class의 self 참조가 있다면,
//   self 참조로 인해서 메모리 누수가 발생할 수 있다.

// 해결 방법
// - 일반적인 클로저에서 해당 문제가 발생할 경우,
//   클로저에서의 self 참조를 약한 참조 기반으로 사용해야 합니다.
//    : unowned(unsafe_unretained) - 참조하는 객체가 파괴되었을 경우, 참조하면 오류가 발생합니다.(위험합니다)
//      weak                       - 참조하는 객체가 파괴될 경우, nil을 반환합니다.
//                                   self가 Optional 됩니다.

// - Rx에서 문제가 발생하는 이유
//   : Observer가 Observable을 구독하면 생성되는 이벤트 스트림이 해지되기 전까지
//     클로저는 파괴되지 않습니다.
//   - DisposeBag

struct User: Decodable {
  let login: String
  let avatarUrl: String
  let type: String
}

struct UserSearchResponse: Decodable {
  let totalCount: Int
  let incompleteResults: Bool
  let items: [User]
}

class ViewController2: UIViewController {
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var label: UILabel!

  @IBOutlet var tableView: UITableView!

  let disposeBag = DisposeBag()

  lazy var decoder: JSONDecoder = {
    let d = JSONDecoder()
    d.keyDecodingStrategy = .convertFromSnakeCase
    return d
  }()

  // 검색 API - https://api.github.com/search/users?q=\(login)

  let items = PublishSubject<[User]>()

  override func viewDidLoad() {
    super.viewDidLoad()

    items
      .bind(to: tableView.rx.items(cellIdentifier: "MyCell")) { (index: Int, model: User, cell: UITableViewCell) in
        cell.textLabel?.text = model.login
        cell.detailTextLabel?.text = model.type
        
      }
      .disposed(by: disposeBag)

    searchBar.rx.text
//      .subscribe(onNext: { text in
//        self.label.text = text
//        // self.label.rx.text // onNext(text)
//      })
      .bind(to: label.rx.text)
      .disposed(by: disposeBag)

    searchBar.rx.text
      .throttle(.milliseconds(500), latest: true, scheduler: MainScheduler.instance) // 이벤트의 발생 빈도를 조절하고
      .compactMap { (text: String?) -> String? in
        guard let text = text, text.count >= 2 else {
          return nil
        }

        return text
      }
//      .flatMap({ (q: String) -> Observable<UserSearchResponse> in
//        self.searchUser(q: q)
//      })
      .flatMapLatest(searchUser(q:)) // 비동기 작업이 중첩되지 않도록 한다.
      .map { (result: UserSearchResponse) -> [User] in
        result.items
      }
      .subscribe(onNext: { items in
        self.items.onNext(items)
      }, onError: { error in
        print("onError: \(error)")
      })
      .disposed(by: disposeBag)

//    searchUser(q: "apple")
//      .subscribe(onNext: { result in
//        print(result)
//      })
//      .disposed(by: disposeBag)
  }

  func searchUserTest(q: String) -> Observable<UserSearchResponse> {
    return Observable.create { (o) -> Disposable in
      DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: 2)
        o.onNext(UserSearchResponse(totalCount: 0, incompleteResults: false, items: []))
        o.onCompleted()
      }

      return Disposables.create()
    }
  }

  func searchUser(q: String) -> Observable<UserSearchResponse> {
    guard let url = URL(string: "https://api.github.com/search/users?q=\(q)") else {
      return .empty()
    }

    return getData(url: url)
      .compactMap { [decoder] data -> UserSearchResponse? in
        try? decoder.decode(UserSearchResponse.self, from: data)
      }
  }

  func getData(url: URL) -> Observable<Data> {
    return Observable.create { observer -> Disposable in
      let task = URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
          observer.onError(error)
          return
        }

        guard let data = data else {
          observer.onError(NSError(domain: "Invalid Data(null)", code: 0, userInfo: [:]))
          return
        }

        observer.onNext(data)
        observer.onCompleted()
      }

      task.resume()

      return Disposables.create {
        task.cancel()
      }
    }
  }

  #if false
  deinit {
    print("ViewController2가 해지되었음.")
  }

  // var disposable: Disposable?
  var disposeBag = DisposeBag()
  // disposeBag의 참조 계수가 0이 될 때, disposeBag에 담긴 Disposable이 파괴됩니다.

  // let compositeDisposable = CompositeDisposable()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    //     filter: (T? -> Bool)  /  T?
    // compactMap:  T -> T?      /  T

    // 클로저로 인해서 ViewController가 제대로 파괴되지 않는 문제
    //  해결 방법
    // 3) self를 캡쳐하지 말고, 사용하는 객체를 캡쳐하면 됩니다.
    //    사용하는 객체의 참조 계수가 올라갑니다.
    searchBar.rx.text
      .compactMap { $0 }
      .subscribe(onNext: { [label] (text: String) in

        label?.text = text

        // self?.label.text = text
      })
      .disposed(by: disposeBag)

    // 2) Rx 에서는 이벤트 스트림이 파괴될 때, 클로저도 해지됩니다.
    //    명시적으로 이벤트 스트림을 dispose 하면 해결할 수 있다.
    //    : disposeBag = DisposeBag()
    #if false
    searchBar.rx.text
      .compactMap { $0 }
      .subscribe(onNext: { (text: String) in

        self.label.text = text

        // self?.label.text = text
      })
      .disposed(by: disposeBag)
    #endif

    // 1) weak / unowned 를 통해 self를 사용하자.
    #if false
    let d = searchBar.rx.text
      .compactMap { $0 }
      .subscribe(onNext: { [weak self] (text: String) in
        guard let self = self else {
          return
        }
        self.label.text = text

        // self?.label.text = text
      })
    #endif

    #if false
    let d = searchBar.rx.text
      .compactMap { $0 }
      .subscribe(onNext: { (text: String) in
        self.label.text = text
      })

    _ = compositeDisposable.insert(d)

    searchBar.rx.text
      .compactMap { $0 }
      .subscribe(onNext: { (text: String) in
        self.label.text = text
      })
      .disposed(by: disposeBag)
    #endif

    #if false
    _ = searchBar.rx.text
      .compactMap { $0 }
      .subscribe(onNext: { [weak self] (text: String) in
        self?.label.text = text
      })
    #endif

    #if false
    _ = searchBar.rx.text
      .compactMap { (text: String?) -> String? in
        if let text = text, text.count > 5 {
          return nil
        }

        return text
      }
      .subscribe(onNext: { (text: String) in
        print(text)
      })
    #endif

    #if false
    searchBar.rx.text
      .subscribe { (event: Event<String?>) in

        switch event {
        case .next:
          break
        case .error:
          break
        case .completed:
          break
        }
      }
    #endif
  }

  override func viewWillDisappear(_ animated: Bool) {
    // disposable?.dispose()
    // disposeBag = DisposeBag()

    // compositeDisposable.dispose()
    // print("viewWillDisappear")
  }
  #endif
}
