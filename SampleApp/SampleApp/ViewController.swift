import RxSwift // !!!
import UIKit

let IMAGE_URL = URL(string: "https://picsum.photos/500/500")!

class ViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var timeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
      self.timeLabel.text = "\(Date().timeIntervalSince1970)"
    }
  }
  
  // 6. 비동기 흐름 제어
  //  - Bolts / PromiseKit

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
  
  @IBAction func onLoad(_ sender: Any) {}
  
  @IBAction func onCancel(_ sender: Any) {}

  // 5. Rx - Reactive eXtension
  //    http://reactivex.io/
  //  Rx: 비동기 기반의 이벤트 처리 코드를 작성하기 위한 라이브러리 입니다.
  //    - 콜백 방식과는 달리 발생하는 이벤트를 이벤트 스트림에 전달하고,
  //      이벤트 스트림을 관찰하다가 원하는 이벤트를 감지하면 이에 따른 동작을 수행하는 방식을 따릅니다.
  
  //   Sequence      < -- >    IteratorProtocol
  // ----------------------------------------------
  //   Array<Int>       <-       func next() -> Element?    => pull
  
  //   Observable               Observer
  // ----------------------------------------------
  //   EventStream      ->       func onNext() -> Element?  => push
  
  // Rx 목적: 비동기 이벤트의 처리를 컬렉션을 처리하듯 일반화할 수 있다.
  
  // 요소 5가지
  // 1. Observable
  //  : 이벤트를 만들어내는 주체로, 이벤트 스트림을 통해 이벤트를 내보냅니다.
  //    한개부터 여러개의 이벤트를 만들어 낼 수 있으며, 이벤트를 발생하지 않을 수도 있습니다.
  
  // 2. Observer
  //  : Observable에서 만들어진 이벤트에 반응하며, 이벤트를 받았을 때 수행할 작업을 정의합니다.
  //    "Observer가 Observable을 구독(subscribe)한다" 라고 합니다.
  
  // 3. Operator
  //  : 연산자는 이벤트 스트림을 통해 전달되는 이벤트를 변환하는 작업을 수행합니다.
  //    단순히 이벤트가 갖고 있는 값을 다른 형태로 넘겨주는 것 뿐 아니라, 특정 조건을 만족하는 이벤트 스트림을 생성하거나,
  //    개수를 바꿔주는 등의 작업을 수행할 수 있습니다.
  
  // 4. Scheduler
  //  : 작업을 수행할 스레드를 지정하는 기능을 제공합니다.
  //    UI 스레드 / IO 스레드 / 작업 스레드 / 새로운 스레드
  
  // 5. Disposable
  //  : Observer가 Observable을 구독할 때 생성되는 객체입니다.
  //    Observable에서 만드는 이벤트 스트림과 이에 필요한 리소스를 관리합니다.
  //    더 이상 이벤트를 받고 싶지 않을 때, 이 객체를 통해 구독을 취소할 수 있습니다.
  
  // func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?, Error?) -> Void)
  #if false
  func loadImageFromURL(_ url: URL) -> Observable<UIImage> {
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
        
        guard let image = UIImage(data: data) else {
          observer.onError(NSError(domain: "Invalid Data", code: 0, userInfo: [:]))
          return
        }
        
        observer.onNext(image)
        observer.onCompleted()
        
        // onError 또는 onCompleted가 수행되기 전까지 자원은 해지되지 않습니다.
      }
      
      task.resume()
      
      return Disposables.create {
        // 사용자가 명시적으로 작업을 취소하거나, 자원이 파괴하기 위해서 호출해야 하는 작업을 정의합니다.
        task.cancel()
      }
    }
  }
  
  @IBAction func onCancel(_ sender: Any) {
    disposable?.dispose()
  }
  
  // Observable Lifecycle
  //  - onNext(..)
  //  - onNext(..)
  
  //  - onError( )
  //    or
  //  - onComplete()
  
  var disposable: Disposable?
  @IBAction func onLoad(_ sender: UIButton) {
    let observable = loadImageFromURL(IMAGE_URL)
    
    disposable = observable
      .observe(on: MainScheduler.instance)
      .subscribe { event in
        switch event {
        case let .next(image):
          print("onNext")
        
          self.imageView.image = image
        
        // DispatchQueue.main.async {
        //   self.imageView.image = image
        // }
        
        case let .error(error):
          print("onError - \(error)")
        
        case .completed:
          print("onCompleted")
        }
      }
  }
  #endif
  
  // 4. RxSwift
  #if false
  func loadImageFromURL(_ url: URL) -> Observable<Int> {
    return Observable.create { observer -> Disposable in
      observer.onNext(10)
      sleep(1)
      observer.onNext(20)
      sleep(1)
      observer.onNext(30)
      sleep(1)
      observer.onNext(40)
      observer.onCompleted()
      
      return Disposables.create()
    }
  }
  
  @IBAction func onLoad(_ sender: UIButton) {
    let observable = loadImageFromURL(IMAGE_URL)
    
    _ = observable.subscribe { event in
      switch event {
      case let .next(data):
        print("onNext: \(data)")
      case let .error(error):
        print("onError: \(error)")
      case .completed:
        print("onComplete")
      }
    }
  }
  #endif
  
  // 3. 비동기 - 취소가 가능해야 한다.
  //   : Task
  //     => URLSession
  //    문제점
  //     - 비동기의 처리의 문제점은 결과의 발생을 콜백을 통해서 처리합니다.
  //     - 순차적인 작업을 처리할 경우, 흐름 제어가 어렵습니다.
  #if false
  var loadTask: URLSessionTask?
  
  @IBAction func onCancel(_ sender: Any) {
    loadTask?.cancel()
  }
  
  func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        completion(nil, error)
        return
      }
      
      guard let data = data else {
        completion(nil, NSError(domain: "Invalid Data(null)", code: 0, userInfo: [:]))
        return
      }
      
      guard let image = UIImage(data: data) else {
        completion(nil, NSError(domain: "Invalid Data", code: 0, userInfo: [:]))
        return
      }
      
      completion(image, nil)
    }
    
    loadTask = task
    task.resume()
  }
  
  @IBAction func onLoad(_ sender: UIButton) {
    // 콜백 지옥 - Callback hell
    //    Bolts / PromiseKit - 비동기 흐름 제어를 위한 라이브러리
    //    RxSwift
    loadImageFromURL(IMAGE_URL) { image, _ in
      self.loadImageFromURL(IMAGE_URL) { image, _ in
        self.loadImageFromURL(IMAGE_URL) { image, _ in
          DispatchQueue.main.async {
            self.imageView.image = image
          }
        }
      }
    }
  }
  #endif
  
  // 2. 비동기 - GCD
  // - 아래 처럼 만들었을 경우, 비동기 요청에 대한 취소가 불가능하다.
  #if false
  func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
    DispatchQueue.global().async {
      do {
        let data = try Data(contentsOf: url)
        
        if let image = UIImage(data: data) {
          completion(image, nil)
        } else {
          completion(nil, NSError(domain: "Invalid data", code: 0, userInfo: [:]))
        }
        
      } catch {
        completion(nil, error)
      }
    }
  }
  
  @IBAction func onLoad(_ sender: UIButton) {
    loadImageFromURL(IMAGE_URL) { image, _ in
      
      DispatchQueue.main.async {
        self.imageView.image = image
      }
    }
  }
  #endif
  
  // 1. 동기 버전
  //  문제점: UI 스레드에서 오래 걸리는 작업을 수행할 경우,
  //        UI의 업데이트가 멈추는 문제가 발생합니다.
  //  해결방법
  //    - 비동기로 처리해야 합니다.
  //      비동기: 별도의 백그라운드 스레드를 통해 문제를 해결해야 합니다.
  //           GCD library
  #if false
  @IBAction func onLoad(_ sender: UIButton) {
    let data = try! Data(contentsOf: IMAGE_URL)
    
    if let image = UIImage(data: data) {
      imageView.image = image
    }
  }
  #endif
}
