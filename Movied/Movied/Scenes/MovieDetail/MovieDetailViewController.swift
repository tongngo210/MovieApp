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
    
    var viewModel: MovieDetailViewControllerViewModel!
    var coordinator: MovieDetailViewControllerCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configView()
    }
    
    @IBAction func didTapBookNowButton(_ sender: UIButton) {
        guard let url = URL(string: APIURLs.bookMovie) else { return }
        UIApplication.shared.open(url)
    }
}
//MARK: - Configure UI
extension MovieDetailViewController {
    private func configViewModel() {
        viewModel?.reloadCollectionView = { [weak self] in
            self?.genresCollectionView.reloadData()
            self?.actorsCollectionView.reloadData()
        }
        
        viewModel?.showIndicator = { [weak self] bool in
            self?.showIndicator(bool)
        }
        
        viewModel?.fillData = { [weak self] movieDetail in
            self?.fillData(with: movieDetail)
        }
    }
    
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
            return viewModel?.numberOfMovieGenresCells ?? 0
        }
        return viewModel?.numberOfMovieActorsCells ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genresCollectionView {
            let cell = collectionView.dequeueReusableCell(withClass: GenreItemCollectionViewCell.self,
                                                          for: indexPath)
            if let numberOfGenres = viewModel?.numberOfMovieGenresCells,
               0..<numberOfGenres ~= indexPath.item {
                let genreCellViewModel = viewModel?.getMovieGenreCellViewModel(at: indexPath)
                cell.genreNameLabel.text = genreCellViewModel?.genreNameText
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withClass: ActorItemCollectionViewCell.self,
                                                      for: indexPath)
        if let numberOfActors = viewModel?.numberOfMovieActorsCells,
           0..<numberOfActors ~= indexPath.item {
            let actorCellViewModel = viewModel?.getMovieActorCellViewModel(at: indexPath)
            cell.actorNameLabel.text = actorCellViewModel?.actorNameText
            cell.actorImageView.getImageFromURL(APIURLs.Image.original + (actorCellViewModel?.actorImageURLString ?? ""))
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
