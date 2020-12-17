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

class ViewController2: UIViewController {
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var label: UILabel!

  @IBOutlet var tableView: UITableView!

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
      .subscribe(onNext: { [label](text: String) in

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
}