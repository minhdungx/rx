import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MusicListViewController: UIViewController {
    private let bag = DisposeBag()
    
    private var musics: [Music] = []
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    private let musicsFileURL = cachedFileURL("musics.json")
    
    // MARK: - Properties
    private let urlMusic = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/songs.json"
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        loadAPI()
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: musicsFileURL), let musics = try? decoder.decode([Music].self, from: data) {
            self.musics = musics
        }
        
    }
    
    
    
    // MARK: - Private Methods
    
    static func cachedFileURL(_ fileName: String) -> URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .allDomainsMask)
            .first!
            .appendingPathComponent(fileName)
    }
    
    private func configUI() {
        title = "New Music"
        
        let nib = UINib(nibName: "MusicListTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func processMusics(newMusics: [Music]) {
        // update UI
        DispatchQueue.main.async {
            self.musics = newMusics
            self.tableView.reloadData()
        }
        
        // save to file
        let encoder = JSONEncoder()
        let musicData = try? encoder.encode(newMusics)
        try? musicData?.write(to: musicsFileURL)
    }
    
    private func loadAPI() {
        let observable = Observable.just(urlMusic)
            .map({urlString in
                return URL(string: urlString)!
            })
            .map({url in
                return URLRequest(url: url)
            })
            .flatMap({request in
                return URLSession.shared.rx.response(request: request)
            })
            .share(replay: 1)
        
        observable
            .filter { response, _ in
                return 200 ..< 300 ~= response.statusCode
            }
            .map { _, data -> [Music] in
                let decoder = JSONDecoder()
                let result = try? decoder.decode( FeedResults.self, from: data)
                return result?.feed.results ?? []
            }
            .filter { result in
                return !result.isEmpty
            }
            .subscribe(onNext: {musics in
                self.processMusics(newMusics: musics)
            })
            .disposed(by: bag)
        
    }
    
}

extension MusicListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musics.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MusicListTableViewCell
        
        let item = musics[indexPath.row]
        cell.nameLabel.text = item.name
        cell.artistNameLabel.text = item.artistName
        cell.thumbnailImageView.kf.setImage(with: URL(string: item.artworkUrl100))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
