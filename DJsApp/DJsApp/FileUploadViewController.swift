import UIKit
import UniformTypeIdentifiers

/// Second screen: allows the user to upload a .txt file.
class FileUploadViewController: UIViewController {

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Upload File"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a .txt file to upload"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let fileIconImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .thin)
        imageView.image = UIImage(systemName: "doc.text", withConfiguration: config)
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let fileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "No file selected"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let fileContentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 8
        textView.isHidden = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose .txt File", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.systemRed, for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Upload File"
        setupLayout()
        setupActions()
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(fileIconImageView)
        view.addSubview(fileNameLabel)
        view.addSubview(fileContentTextView)
        view.addSubview(uploadButton)
        view.addSubview(clearButton)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),

            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),

            fileIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fileIconImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            fileIconImageView.widthAnchor.constraint(equalToConstant: 100),
            fileIconImageView.heightAnchor.constraint(equalToConstant: 100),

            fileNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fileNameLabel.topAnchor.constraint(equalTo: fileIconImageView.bottomAnchor, constant: 12),
            fileNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            fileNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            fileContentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fileContentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fileContentTextView.topAnchor.constraint(equalTo: fileNameLabel.bottomAnchor, constant: 16),
            fileContentTextView.heightAnchor.constraint(equalToConstant: 160),

            uploadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            uploadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            uploadButton.bottomAnchor.constraint(equalTo: clearButton.topAnchor, constant: -12),
            uploadButton.heightAnchor.constraint(equalToConstant: 50),

            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    // MARK: - Actions

    private func setupActions() {
        uploadButton.addTarget(self, action: #selector(didTapUpload), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
    }

    @objc private func didTapUpload() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.plainText], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }

    @objc private func didTapClear() {
        fileNameLabel.text = "No file selected"
        fileContentTextView.text = nil
        fileContentTextView.isHidden = true
        clearButton.isHidden = true

        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .thin)
        fileIconImageView.image = UIImage(systemName: "doc.text", withConfiguration: config)
        fileIconImageView.tintColor = .systemGray3
    }

    // MARK: - File Handling

    private func handleSelectedFile(at url: URL) {
        let fileName = url.lastPathComponent
        guard url.pathExtension.lowercased() == "txt" else {
            showAlert(message: "Please select a valid .txt file.")
            return
        }

        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            fileNameLabel.text = fileName
            fileContentTextView.text = content
            fileContentTextView.isHidden = false
            clearButton.isHidden = false

            let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .thin)
            fileIconImageView.image = UIImage(systemName: "doc.text.fill", withConfiguration: config)
            fileIconImageView.tintColor = .systemBlue
        } catch {
            showAlert(message: "Could not read file: \(error.localizedDescription)")
        }
    }

    // MARK: - Helpers

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIDocumentPickerDelegate

extension FileUploadViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        handleSelectedFile(at: url)
    }
}
