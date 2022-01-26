import UIKit

final class MovieDetailViewController: UIViewController {
    
    @IBOutlet private weak var bookNowButton: UIButton!
    @IBOutlet private weak var movieBackgroundImage: UIImageView!
    @IBOutlet private weak var moviePosterImage: UIImageView!
    @IBOutlet private var movieRateStarImageViews: [UIImageView]!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieRateLabel: UILabel!
    @IBOutlet private weak var movieLanguageLabel: UILabel!
    @IBOutlet private weak var movieDurationLabel: UILabel!
    @IBOutlet private weak var movieSynopsisLabel: UILabel!
    @IBOutlet private weak var genresCollectionView: UICollectionView!
    @IBOutlet private weak var actorsCollectionView: UICollectionView!
    
    private let dispatchGroup = DispatchGroup()
    
    var movieId: Int?
    var movieDetail: MovieDetail?
    var movieActors: [Actor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        fetchMovieInfoData()
    }
    
    private func fetchMovieInfoData() {
        showIndicator(true)
        dispatchGroup.enter()
        APIService.shared.getMovieDetail(id: movieId ?? 0) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let movieDetail = data {
                        self.movieDetail = movieDetail
                        self.fillData(with: movieDetail)
                        self.genresCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
        dispatchGroup.leave()
        
        dispatchGroup.enter()
        APIService.shared.getMovieActors(id: movieId ?? 0) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let movieActors = data {
                        self.movieActors = movieActors.cast
                        self.actorsCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.showIndicator(false)
        }
    }
    
    @IBAction func didTapBookNowButton(_ sender: UIButton) {
        guard let url = URL(string: APIURLs.bookMovie) else { return }
        UIApplication.shared.open(url)
    }
}
//MARK: - Configure UI
extension MovieDetailViewController {
    private func configView() {
        configButton()
        configImageView()
        configCollectionView()
    }
    
    private func configButton() {
        bookNowButton.tintColor = .white
        bookNowButton.backgroundColor = AppColor.orangePeel
        bookNowButton.layer.cornerRadius = bookNowButton.frame.height / 2
    }
    
    private func configImageView() {
        moviePosterImage.layer.cornerRadius = 15
        movieRateStarImageViews.forEach { $0.tintColor = .orange }
    }
    
    private func configCollectionView() {
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
        genresCollectionView.registerNib(cellName: GenreItemCollectionViewCell.className)
        
        actorsCollectionView.delegate = self
        actorsCollectionView.dataSource = self
        actorsCollectionView.registerNib(cellName: ActorItemCollectionViewCell.className)
    }
    
    private func fillData(with movie: MovieDetail?) {
        moviePosterImage.getImageFromURL(APIURLs.Image.original + (movie?.poster ?? ""))
        movieBackgroundImage.getImageFromURL(APIURLs.Image.original + (movie?.backgroundPoster ?? ""))
        movieNameLabel.text = movie?.title
        movieLanguageLabel.text = movie?.languages?.map { $0.name }.joined(separator: " ,")
        movieDurationLabel.text = "\((movie?.duration ?? 0) / 60)h \((movie?.duration ?? 0) % 60)m"
        movieSynopsisLabel.text = movie?.synopsis
        
        if var movieRate = movie?.voteRate {
            movieRateLabel.text = "\(movieRate)"
            for index in movieRateStarImageViews.indices {
                if movieRate >= 2 {
                    movieRateStarImageViews[index].image = UIImage(systemName: Name.SystemImage.filledStar)
                    movieRate -= 2
                } else if movieRate >= 1 {
                    movieRateStarImageViews[index].image = UIImage(systemName: Name.SystemImage.halfStar)
                    movieRate -= 1
                } else {
                    movieRateStarImageViews[index].image = UIImage(systemName: Name.SystemImage.unfilledStar)
                }
            }
        }
    }
}
//MARK: - CollectionView Delegate, DataSource
extension MovieDetailViewController: UICollectionViewDelegate,
                                     UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == genresCollectionView {
            return movieDetail?.genres?.count ?? 0
        }
        return movieActors.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genresCollectionView {
            let cell = collectionView.dequeueReusableCell(withClass: GenreItemCollectionViewCell.self,
                                                          for: indexPath)
            if let genreList = movieDetail?.genres,
               genreList.indices ~= indexPath.item {
                cell.fillData(with: genreList[indexPath.item])
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withClass: ActorItemCollectionViewCell.self,
                                                      for: indexPath)
        if movieActors.indices ~= indexPath.item {
            cell.fillData(with: movieActors[indexPath.item])
        }
        return cell
    }
}
//MARK: - CollectionView FlowLayout Delegate
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genresCollectionView {
            let size = CGSize(width: genresCollectionView.frame.width / 3 - 4,
                              height: genresCollectionView.frame.height / 2 - 2)
            return size
        }
        let size = CGSize (width: actorsCollectionView.frame.width / 4,
                           height: actorsCollectionView.frame.height - 10)
        return size
    }
}
