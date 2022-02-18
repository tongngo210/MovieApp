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
    @IBOutlet private weak var movieFavoriteButton: UIButton!
    @IBOutlet private weak var genresCollectionView: UICollectionView!
    @IBOutlet private weak var actorsCollectionView: UICollectionView!
    
    var viewModel: MovieDetailViewControllerViewModel!
    var coordinator: MovieDetailViewControllerCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkIfMovieIsFavorited()
    }
    
    @IBAction func didTapMovieFavoriteButton(_ sender: UIButton) {
        viewModel.didTapFavorite()
        animateMovieFavoriteButton()
    }
    
    private func animateMovieFavoriteButton() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            self.movieFavoriteButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                self.movieFavoriteButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    @IBAction func didTapBookNowButton(_ sender: UIButton) {
        guard let url = URL(string: APIURLs.bookMovie) else { return }
        UIApplication.shared.open(url)
    }
}
//MARK: - Configure UI
extension MovieDetailViewController {
    private func configViewModel() {
        //This reload func has already been in DispatchQueue.main in viewmodel
        viewModel?.reloadCollectionView = { [weak self] in
            self?.genresCollectionView.reloadData()
            self?.actorsCollectionView.reloadData()
        }
        
        viewModel?.showIndicator = { [weak self] bool in
            DispatchQueue.main.async {
                self?.showIndicator(bool)
            }
        }
        
        viewModel?.fillData = { [weak self] movieDetail in
            self?.fillData(with: movieDetail)
        }
        
        viewModel?.updateFavoriteButton = { [weak self] isliked in
            DispatchQueue.main.async {
                self?.movieFavoriteButton.tintColor = isliked ? AppColor.heartRed : .white
            }
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
        
        movieFavoriteButton.backgroundColor = AppColor.sunglow
        movieFavoriteButton.layer.cornerRadius = movieFavoriteButton.frame.height / 2
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
                cell.viewModel = genreCellViewModel
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withClass: ActorItemCollectionViewCell.self,
                                                      for: indexPath)
        if let numberOfActors = viewModel?.numberOfMovieActorsCells,
           0..<numberOfActors ~= indexPath.item {
            let actorCellViewModel = viewModel?.getMovieActorCellViewModel(at: indexPath)
            cell.viewModel = actorCellViewModel
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
