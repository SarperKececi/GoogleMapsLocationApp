import UIKit
import MapKit

class DetailViewController: UIViewController {

    let places: PlaceAnnotation

    init(places: PlaceAnnotation) {
        self.places = places
        super.init(nibName: nil, bundle: nil)
    }

    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = .black
        return nameLabel
    }()

    let directionsLabel: UILabel = {
        let directionsLabel = UILabel()
        directionsLabel.translatesAutoresizingMaskIntoConstraints = false
        directionsLabel.textAlignment = .left
        directionsLabel.alpha = 0.7
        directionsLabel.font = UIFont.systemFont(ofSize: 16)
        directionsLabel.textColor = .darkGray
        return directionsLabel
    }()

    let directionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Directions", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
      
        return button
    }()

    let callButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
     
        return button
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupUI()
    }

    func setupUI() {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        let contactStackView = UIStackView()
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.axis = .horizontal
        contactStackView.spacing = UIStackView.spacingUseSystem

        nameLabel.text = places.name
        directionsLabel.text = places.adress
        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true

        directionsButton.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(directionsLabel)
        stackView.addArrangedSubview(contactStackView)
        contactStackView.addArrangedSubview(directionsButton)
        contactStackView.addArrangedSubview(callButton)

        view.addSubview(stackView)
    }

    @objc func directionsButtonTapped(sender: UIButton) {
        let placemark = MKPlacemark(coordinate: places.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = places.name
        mapItem.openInMaps(launchOptions: nil)
    }

    
}

