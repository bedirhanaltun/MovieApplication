
import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    //Variables and Arrays
    
    var response : Movie?
    var filteredMovies : [Search]?
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    let loadingView = UIView()
    
    //Segment
    
    var segmentType: SegmentType? {
        didSet {
            switch segmentType {
            case .all:
                filteredMovies = response?.search
                tableView.reloadData()
            case .movies:
                guard let movies = response?.search else {
                    return
                }
                
                filteredMovies = movies.filter { search in
                    search.type == "movie"
                }
                
                tableView.reloadData()
                
            case .series:
                guard let movies = response?.search else {
                    return
                }
                
                filteredMovies = movies.filter {
                    $0.type == "series"
                }
                
                tableView.reloadData()
                
            case .games:
                guard let movies = response?.search else {
                    return
                }
                
                filteredMovies = movies.filter{
                    $0.type == "game"
                }
                
                tableView.reloadData()
                
            default:
                break
            }
        }
    }
    
    //Label and TableView
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTableView()
        searchBar()
        
    }
    
    //TableView Settings
    
    func getTableView(){
        view.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .black
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "toDetailsVC")
        title = "Movie Paradise"
        
        //UserLabel Text Settings
        userLabel.text = "Search For Any Movies,Series,Games"
        userLabel.textColor = .white
    }
    
    //Search Bar Settings
    
    func searchBar(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchBar.placeholder = "Search Movies"
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.lightGray
        
        //Search Bar Scope Button Titles
        
        searchBar.scopeButtonTitles = [
            SegmentType.all.title,
            SegmentType.movies.title,
            SegmentType.series.title,
            SegmentType.games.title
        ]
        
        self.tableView.tableHeaderView = searchBar
        
    }
    
    //Search Bar Scope Button Change
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        segmentType = SegmentType.init(rawValue: selectedScope)
    }
    
    //Search Bar Text Change
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            userLabel.isHidden = false
            filteredMovies?.removeAll()
            response?.search?.removeAll()
            tableView.reloadData()
        }
    }
    
    //Search Button Clicked
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadingLabel.isHidden = false
        guard let searchText = searchBar.text else{
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){ [self] in
            getData(keyword: searchText.replacingOccurrences(of: " ", with: ""))
        }
        
        userLabel.isHidden = true
        setLoadingScreen()
    }
    
    //Getting Data From API(URL)
    
    func getData(keyword: String){
        setLoadingScreen()
        
        let urlString = "https://www.omdbapi.com/?s=\(keyword)&page=3&apikey=9893101c"
        guard let url = URL(string: urlString) else{
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else{
                    self.showError(message: "Error")
                    return
                }
                
                guard let decode = try? JSONDecoder().decode(Movie.self, from: data) else {
                    self.showError(message: "Error")
                    return
                }
                
                if let error = decode.error {
                    self.showError(message: error)
                    return
                }
                
                self.response = decode
                self.filteredMovies = decode.search
                
                self.tableView.reloadData()
                self.removeLoadingScreen()
            }
            
        }.resume()
        
    }
    
    //Error Function
    
    func showError(message : String?){
        DispatchQueue.main.async {
            let error = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            error.addAction(okButton)
            self.present(error, animated: true, completion: nil)
            
            //Hide Activity Indicator
            self.removeLoadingScreen()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = filteredMovies?[indexPath.row]
        performSegue(withIdentifier: "detailsMovies", sender: movie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Geri Dön"
        backItem.tintColor = .white
        backItem.style = .done
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "detailsMovies"{
            guard let movie = sender as? Search else{
                return
            }
            
            let destination = segue.destination as! toDetailsVC
            
            //API Variables == My Variables
            
            destination.selectedTitleLabel = movie.title
            destination.selectedYearLabel = movie.year
            destination.selectedTypeLabel = movie.type
            destination.selectedImdbLabel = movie.imdbID
            destination.selectedImage = movie.poster
            
            destination.selectedResults = response?.totalResults ?? ""
            destination.selectedResponse = response?.response ?? ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDetailsVC",for: indexPath)
        cell.textLabel?.text = filteredMovies?[indexPath.row].title
        return cell
    }
    
    //Spinner and Loading Label Settings
    
    func setLoadingScreen() {
        
        
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        
        loadingLabel.textColor = .black
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        spinner.style = .medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        spinner.color = .black
        
        
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        
    }
    
    //Removing Loading Label And Spinner From Center of TableView
    
    func removeLoadingScreen() {
        
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }
    
}


