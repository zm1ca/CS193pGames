//
//  ThemeChooserVC.swift
//  Concentration
//
//  Created by Źmicier Fiedčanka on 17.12.20.
//

import UIKit

class ThemeChooserVC: UIViewController, UISplitViewControllerDelegate  {
    
    // FIX: Make it a simple table view. Stack view may not fit at small screens
    @IBOutlet weak var themesStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAButtonForEachThemeSample()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    // MARK: - Managing SplitVC
    var splitViewDetailConcentrationViewController: ConcentrationVC? {
        return splitViewController?.viewControllers.last?.contents as? ConcentrationVC
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

    
    // MARK: - Navigation
    private var lastSeguedToConcentrationVC: ConcentrationVC?
    
    
    private func addAButtonForEachThemeSample() {
        for theme in Theme.samples {
            let themeButton = UIButton()
            themeButton.setTitle(theme.name, for: .normal)
            themeButton.setTitleColor(.label, for: .normal)
            themeButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).withSize(30)
            themeButton.addTarget(self, action: #selector(changeTheme), for: .touchUpInside)
            themesStackView.addArrangedSubview(themeButton)
        }
    }
    
    
    @objc func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = Theme.themeSample(named: themeName) {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationVC {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = Theme.themeSample(named: themeName) {
                cvc.theme = theme
            }
            let cvcNavigationController = UINavigationController(rootViewController: cvc)
            navigationController?.pushViewController(cvcNavigationController, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = Theme.themeSample(named: themeName) {
                if let cvc = segue.destination.contents as? ConcentrationVC {
                    cvc.theme = theme
                    lastSeguedToConcentrationVC = cvc
                }
            }
        }
    }
}


extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
