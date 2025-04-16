//
//  PokeDexDetailVC.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/11/25.
//

import UIKit


class PokeDexDetailVC: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Top labels: Name & Number
    private lazy var pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Venusaur"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pokemonNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "003"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Main Pokémon Image
    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        // Example placeholder
        imageView.image = UIImage(named: "venusaur_placeholder")
        imageView.backgroundColor = UIColor.systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Constrain width/height so it has a square shape
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 240),
            imageView.heightAnchor.constraint(equalToConstant: 240)
        ])
        return imageView
    }()
    
    // Segmented Control
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Forms", "Detail", "Types", "Stats", "Weakness"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return control
    }()
    
    private let segmentTitles = ["Forms", "Detail", "Types", "Stats", "Weakness"]

    // MARK: - Collection View for Segments
    private lazy var segmentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SegmentCell.self, forCellWithReuseIdentifier: SegmentCell.reuseIdentifier)
        return collectionView
    }()
    
    // Horizontal forms scroll (or stack)
    private lazy var formsScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var formsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Title & Description below forms
    private lazy var formTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mega Evolution"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var formDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "In order to support its flower, which has grown larger due to Mega Evolution, its back and legs have become stronger."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .justified
        return label
    }()
    
    private let viewModel: PokeDexDetailVM
    
    weak var delegate: PokeDexDetailDelegate?
    
    init(viewModel: PokeDexDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        configureForms() // Example: populate the forms area
    }
    
    // MARK: - Setup Layout
    
    private func setupNavigationBar() {
        title = "Venusaur"
        view.backgroundColor = #colorLiteral(red: 0.9553839564, green: 0.9852878451, blue: 0.9847680926, alpha: 1)
        navigationItem.largeTitleDisplayMode = .never
        let leftBarButtonItemAction: Selector = #selector(didTapBackButton)
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                style: .plain,
                                                target: self,
                                                action: leftBarButtonItemAction)
        leftBarButtonItem.tintColor = PokemonBackgroundColor.black.color
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setupLayout() {
        // 1. Add scrollView to the view
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // 2. Add contentStackView inside the scrollView
        scrollView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)  // match width to scrollView
        ])
        
        // 3. Add subviews to contentStackView
        contentStackView.addArrangedSubview(pokemonNameLabel)
        contentStackView.addArrangedSubview(pokemonNumberLabel)
        contentStackView.addArrangedSubview(pokemonImageView)
//        contentStackView.addArrangedSubview(segmentedControl)
        
        contentStackView.addArrangedSubview(segmentsCollectionView)
        NSLayoutConstraint.activate([
            segmentsCollectionView.heightAnchor.constraint(equalToConstant: 40),
            segmentsCollectionView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            segmentsCollectionView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor)
        ])
        
        // The forms area can be optional if we only show it for certain segments
        // but for simplicity, let's always add it:
        contentStackView.addArrangedSubview(formsScrollView)
        
        // Constrain formsScrollView width to contentStackView so it doesn't scroll horizontally in an odd way
        NSLayoutConstraint.activate([
            formsScrollView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            formsScrollView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            // Set a fixed height for forms row or let the images define it
            formsScrollView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Add formsStackView inside formsScrollView
        formsScrollView.addSubview(formsStackView)
        NSLayoutConstraint.activate([
            formsStackView.topAnchor.constraint(equalTo: formsScrollView.topAnchor),
            formsStackView.leadingAnchor.constraint(equalTo: formsScrollView.leadingAnchor, constant: 16),
            formsStackView.trailingAnchor.constraint(equalTo: formsScrollView.trailingAnchor, constant: -16),
            formsStackView.bottomAnchor.constraint(equalTo: formsScrollView.bottomAnchor),
            // No fixed width so it can grow horizontally
        ])
        
        // 4. Add form title + description
        contentStackView.addArrangedSubview(formTitleLabel)
        
        // Constrain the width so it doesn’t stretch beyond the safe area
        formTitleLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 16).isActive = true
        formTitleLabel.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: -16).isActive = true
        
        contentStackView.addArrangedSubview(formDescriptionLabel)
        formDescriptionLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 16).isActive = true
        formDescriptionLabel.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: -16).isActive = true
    }
    
    // MARK: - Example: Populate the Forms Stack
    
    private func configureForms() {
        // For demonstration, create a few placeholder images
        let sampleForms = ["venusaur_placeholder", "mega_venusaur", "gmax_venusaur"]
        
        for formImageName in sampleForms {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.backgroundColor = .systemGray5
            if let img = UIImage(named: formImageName) {
                imageView.image = img
            }
            
            // Add a fixed width/height for each form image
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 64),
                imageView.heightAnchor.constraint(equalToConstant: 64)
            ])
            
            formsStackView.addArrangedSubview(imageView)
        }
    }
    
    // MARK: - Actions
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Handle switching between "Forms", "Detail", "Types", "Stats", "Weakness"
        // For simplicity, we won't implement the actual UI changes here.
        print("Switched to segment index \(sender.selectedSegmentIndex)")
    }
    
    @objc func didTapBackButton() {
        delegate?.didTapBackButton()
    }
}

class SegmentCell: UICollectionViewCell {
    static let reuseIdentifier = "SegmentCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            // Change background or text color on selection
            contentView.backgroundColor = isSelected ? UIColor.systemPurple : UIColor.clear
            titleLabel.textColor = isSelected ? UIColor.white : UIColor.darkGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemPurple.cgColor
        contentView.clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

extension PokeDexDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentCell.reuseIdentifier, for: indexPath) as? SegmentCell else {
            return UICollectionViewCell()
        }
        let title = segmentTitles[indexPath.item]
        cell.configure(with: title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle selection of a segment.
        print("Selected segment: \(segmentTitles[indexPath.item])")
        // Implement your logic to update the view (e.g., switching subviews, updating content, etc.)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Optional: handle deselection if you need to update UI.
    }
}
