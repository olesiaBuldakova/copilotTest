import UIKit

/// Login screen with email/password fields, social login options, and navigation actions.
/// Implements programmatic UIKit UI with Auto Layout, supporting iOS 15+ and dark mode.
final class LoginViewController: UIViewController {

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.note.house.fill")
        imageView.tintColor = .systemPurple
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "DJ's App"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to continue"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.keyboardType = .emailAddress
        field.textContentType = .emailAddress
        field.returnKeyType = .next
        field.font = UIFont.preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.translatesAutoresizingMaskIntoConstraints = false
        field.accessibilityLabel = "Email address"
        return field
    }()

    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.textContentType = .password
        field.returnKeyType = .done
        field.font = UIFont.preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.translatesAutoresizingMaskIntoConstraints = false
        field.accessibilityLabel = "Password"
        return field
    }()

    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Log in button"
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let dividerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let leftLine = UIView()
        leftLine.backgroundColor = .separator
        leftLine.translatesAutoresizingMaskIntoConstraints = false

        let rightLine = UIView()
        rightLine.backgroundColor = .separator
        rightLine.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "or"
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(leftLine)
        container.addSubview(label)
        container.addSubview(rightLine)

        NSLayoutConstraint.activate([
            leftLine.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            leftLine.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            leftLine.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -12),

            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            rightLine.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 12),
            rightLine.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1),
            rightLine.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        return container
    }()

    private let appleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Continue with Apple"
        config.image = UIImage(systemName: "apple.logo")
        config.imagePadding = 8
        config.baseBackgroundColor = .label
        config.baseForegroundColor = .systemBackground
        config.cornerStyle = .medium
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Sign in with Apple"
        return button
    }()

    private let googleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.bordered()
        config.title = "Continue with Google"
        config.image = UIImage(systemName: "g.circle.fill")
        config.imagePadding = 8
        config.cornerStyle = .medium
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Sign in with Google"
        return button
    }()

    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Don't have an account? ",
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .subheadline),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        attributedTitle.append(NSAttributedString(
            string: "Sign Up",
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .subheadline),
                .foregroundColor: UIColor.systemPurple
            ]
        ))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip for now", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(.tertiaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Properties

    private var isLoading = false {
        didSet {
            updateLoadingState()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupActions()
        setupKeyboardHandling()
    }

    // MARK: - View Setup

    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.hidesBackButton = true
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(loginButton)
        contentView.addSubview(dividerView)
        contentView.addSubview(appleSignInButton)
        contentView.addSubview(googleSignInButton)
        contentView.addSubview(createAccountButton)
        contentView.addSubview(skipButton)

        loginButton.addSubview(activityIndicator)

        let horizontalPadding: CGFloat = 32

        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),

            // Title
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),

            // Subtitle
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),

            // Email Field
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            emailField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailField.heightAnchor.constraint(equalToConstant: 50),

            // Password Field
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.heightAnchor.constraint(equalToConstant: 50),

            // Forgot Password
            forgotPasswordButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 8),

            // Login Button
            loginButton.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 24),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),

            // Divider
            dividerView.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 32),
            dividerView.heightAnchor.constraint(equalToConstant: 20),

            // Apple Sign In
            appleSignInButton.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            appleSignInButton.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            appleSignInButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 24),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 50),

            // Google Sign In
            googleSignInButton.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            googleSignInButton.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            googleSignInButton.topAnchor.constraint(equalTo: appleSignInButton.bottomAnchor, constant: 12),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 50),

            // Create Account
            createAccountButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 32),

            // Skip
            skipButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            skipButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 16),
            skipButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    // MARK: - Actions

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(didTapSkip), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        appleSignInButton.addTarget(self, action: #selector(didTapAppleSignIn), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(didTapGoogleSignIn), for: .touchUpInside)

        emailField.delegate = self
        passwordField.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func didTapLogin() {
        guard validateInput() else { return }
        performLogin()
    }

    @objc private func didTapSkip() {
        navigateToFileUpload()
    }

    @objc private func didTapForgotPassword() {
        showAlert(title: "Forgot Password", message: "Password reset functionality coming soon.")
    }

    @objc private func didTapCreateAccount() {
        showAlert(title: "Create Account", message: "Account creation functionality coming soon.")
    }

    @objc private func didTapAppleSignIn() {
        showAlert(title: "Apple Sign In", message: "Apple Sign In functionality coming soon.")
    }

    @objc private func didTapGoogleSignIn() {
        showAlert(title: "Google Sign In", message: "Google Sign In functionality coming soon.")
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Validation

    private func validateInput() -> Bool {
        guard let email = emailField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email address.")
            emailField.becomeFirstResponder()
            return false
        }

        guard isValidEmail(email) else {
            showAlert(title: "Error", message: "Please enter a valid email address.")
            emailField.becomeFirstResponder()
            return false
        }

        guard let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter your password.")
            passwordField.becomeFirstResponder()
            return false
        }

        guard password.count >= 6 else {
            showAlert(title: "Error", message: "Password must be at least 6 characters.")
            passwordField.becomeFirstResponder()
            return false
        }

        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    // MARK: - Login

    private func performLogin() {
        isLoading = true
        dismissKeyboard()

        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            self?.navigateToFileUpload()
        }
    }

    private func updateLoadingState() {
        loginButton.isEnabled = !isLoading
        emailField.isEnabled = !isLoading
        passwordField.isEnabled = !isLoading

        if isLoading {
            loginButton.setTitle("", for: .normal)
            activityIndicator.startAnimating()
        } else {
            loginButton.setTitle("Log In", for: .normal)
            activityIndicator.stopAnimating()
        }
    }

    // MARK: - Keyboard Handling

    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    // MARK: - Navigation

    private func navigateToFileUpload() {
        let fileUploadVC = FileUploadViewController()
        navigationController?.pushViewController(fileUploadVC, animated: true)
    }

    // MARK: - Helpers

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapLogin()
        }
        return true
    }
}
