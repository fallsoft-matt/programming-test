//
//  ViewController.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/10/22.
//

import UIKit
import Combine

class TerminalWeatherList: UIViewController {
    

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var settingsBarButton: UIBarButtonItem!
    
    private var subscription: AnyCancellable?
    
    private var weatherService = TerminalWeatherService()
    
    private var weatherReports: [WeatherReport] = [] {
        didSet {
            tableView.reloadSections([0], with: .fade)
        }
    }
    
    private var reportMap: [String: WeatherReport] = [:] {
        didSet {
            weatherReports = reportMap.values.sorted { $0.ident < $1.ident }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureSettingsButton()
        
        subscription = WeatherViewModel.shared.$weatherReports
            .receive(on: DispatchQueue.main)
            .assign(to: \.reportMap, on: self)
        
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as? WeatherDetailViewController
        detailVC?.targetAirportIdentifier = sender as? String ?? ""
    }
    
    @IBAction func addAirport() {
        let controller = UIAlertController(title: "Enter an Airpoint Code", message: nil, preferredStyle: .alert)
        
        controller.addTextField { textField in
            textField.placeholder = "Airport Code"
        }
                
        let action = UIAlertAction(title: "Submit", style: .default) { action in
            let text = controller.textFields?.first?.text ?? ""
            
            self.createNewAirpoint(text: text)
        }

        controller.addAction(action)
        controller.addAction(.init(title: "Cancel", style: .cancel))
        
        present(controller, animated: true)
    }
    
    private func configureSettingsButton() {
        let timerActionMinutes = UIAction(title: "1 Minute Updates") { action in
            TimerViewModel.shared.updateTimerSettings(isEnabled: true, duration: 60)
            TimerViewModel.shared.restartTimer()
        }
        
        let timerActionSeconds = UIAction(title: "30 Second Updates") { action in
            TimerViewModel.shared.updateTimerSettings(isEnabled: true, duration: 30)
            TimerViewModel.shared.restartTimer()
        }
        
        let noneAction = UIAction(title: "None") { action in
            TimerViewModel.shared.updateTimerSettings(isEnabled: false, duration: 60)
            TimerViewModel.shared.stopTimer()
        }
        
        let menu = UIMenu(title: "Weather Update Frequency", children: [noneAction, timerActionSeconds, timerActionMinutes])
        settingsBarButton.menu = menu
        settingsBarButton.primaryAction = nil
    }
    
    private func createNewAirpoint(text: String) {
        Task { [weak self] in
            do {
                let result = try await WeatherViewModel.shared.fetchOrCreate(ident: text)
                performSegue(withIdentifier: "show-detail", sender: result.ident)
                
            } catch {
                self?.showError(message: "We're unable to add that airport at this time")
            }
        }
    }
    
    private func loadData() {
        Task { [weak self] in
            do {
                try await WeatherViewModel.shared.loadReports()
                print("Loaded Reports")
            } catch {
                self?.showError(message: "We're unable to reach our services at this time")
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "We're Sorry", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}

extension TerminalWeatherList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weather-cell", for: indexPath)
        let weatherCell = cell as? WeatherListCell
        
        weatherCell?.model = weatherReports[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherReports.count
    }
    
}

extension TerminalWeatherList: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reportIdent = weatherReports[indexPath.row].ident
        
        performSegue(withIdentifier: "show-detail", sender: reportIdent)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, callback) in
            
            guard let reportId = self?.weatherReports[indexPath.row] else {
                return
            }
            
            Task { [weak self] in
                do {
                    try await WeatherViewModel.shared.delete(report: reportId)
                    
                } catch {
                    self?.showError(message: "We're not able to delete that right now")
                }
                callback(true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
