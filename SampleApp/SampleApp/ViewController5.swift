
import RxCocoa
import RxSwift
import UIKit

class ViewController5: UIViewController {
  @IBOutlet var searchNameField: UITextField!
  @IBOutlet var searchButton: UIButton!

  @IBOutlet var avatarImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var typeLabel: UILabel!

  var viewModel = ViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    // View -> ViewModel
    Observable.from([
      searchNameField.rx.controlEvent(.editingDidEndOnExit),
      searchButton.rx.tap
    ])
      .merge()
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .flatMapLatest(viewModel.getUser)
      .bind(to: viewModel.user)
      .disposed(by: viewModel.disposeBag)

    searchNameField.rx.text
      .compactMap {
        $0
      }
      .bind(to: viewModel.searchName)
      .disposed(by: viewModel.disposeBag)

    // ViewModel -> View
    viewModel.userName
      .bind(to: nameLabel.rx.text)
      .disposed(by: viewModel.disposeBag)

    viewModel.userType
      .bind(to: typeLabel.rx.text)
      .disposed(by: viewModel.disposeBag)

    viewModel.searchButtonEnabled
      .bind(to: searchButton.rx.isEnabled)
      .disposed(by: viewModel.disposeBag)

    viewModel.avatarImage
      .bind(to: avatarImageView.rx.image)
      .disposed(by: viewModel.disposeBag)

    viewModel.title
      .bind(to: navigationItem.rx.title)
      .disposed(by: viewModel.disposeBag)
  }
}

struct ViewModel {
  let disposeBag = DisposeBag()

  let title = BehaviorSubject<String>(value: "")

  let searchName = BehaviorSubject<String>(value: "")
  let userName = BehaviorSubject<String>(value: "")
  let userType = BehaviorSubject<String>(value: "")

  let user = PublishSubject<User?>()
  let avatarImage = PublishSubject<UIImage>()

  // searchName이 비어있지 않으면
  lazy var searchButtonEnabled: Observable<Bool> = {
    searchName.map { (name: String) -> Bool in
      !name.isEmpty
    }
  }()

  init() {
    // User가 변경되면 UIImage 업데이트
    user
      .compactMap { (user: User?) -> URL? in
        guard let user = user else {
          return nil
        }
        
        return URL(string: user.avatarUrl)
      }
      .flatMapLatest(getData(url:))
      .compactMap { (data: Data) -> UIImage? in
        UIImage(data: data)
      }
      .bind(to: avatarImage)
      .disposed(by: disposeBag)

    // User가 변경되면 userName / userType 업데이트
    user
      .subscribe(onNext: { [self] user in
        if let user = user {
          userName.onNext(user.name)
          userType.onNext(user.type)
          title.onNext(user.login)
        } else {
          userName.onNext("")
          userType.onNext("")
          title.onNext("Error!")
          
          if let image = UIImage(named: "profile") {
            avatarImage.onNext(image)
          }
        }
        
      })
      .disposed(by: disposeBag)
  }

  func getUser() -> Observable<User> {
    guard let login = try? searchName.value() else {
      return .empty()
    }

    guard let url = URL(string: "https://api.github.com/users/\(login)") else {
      return .empty()
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return getData(url: url)
      .compactMap { (data: Data) -> User? in
        if let result = try? decoder.decode(User.self, from: data) {
          return result
        } else {
          
          user.onNext(nil)
        
          return nil
        }
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
}

// 1. searchNameField를 1글자 이상 입력하고,
//    Enter를 누르거나 검색 버튼을 통해 검색 결과를 얻어올 수 있다.
// 2. user.avatarUrl -> avatarImage
//         name      -> nameLabel
//         type      -> typeLabel
//         login     -> navigationItem.title

// 3. follower 버튼은 user가 존재할 경우, 활성화된다.
// 4. 검색 결과가 없는 경우 이미지는 기본 이미지로 변경된다.
//     navigationItem.title도 Error!
