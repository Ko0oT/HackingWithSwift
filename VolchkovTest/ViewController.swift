//
//  ViewController.swift
//  VolchkovTest
//
//  Created by Citylink on 25.01.2025.
//

import UIKit
import Stevia

final class ViewController: UITableViewController {
    
    //MARK: - Properties
    var petitions = [Petition]()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //Этот код не идеален, на самом деле далек от идеала. На самом деле, загрузка данных из интернета в viewDidLoad()нашем приложении заблокируется, пока все данные не будут переданы. Для этого есть решения, но во избежание сложности они не будут рассмотрены до проекта 9.
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        //Поскольку async()используются замыкания, вы можете подумать, что для начала следует [weak self] in убедиться в отсутствии случайных циклов сильных ссылок, но здесь это не нужно, потому что GCD выполняет код один раз, а затем отбрасывает его — он не сохранит используемые внутри данные.
        
        //Если вы хотите попробовать другие очереди QoS, вы также можете использовать .userInteractive, .utilityили .background.
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    // we're OK to parse!
                    self.parse(json: data)
                    return
                }
            }
            
            self.showError()
        }

        //showError()
        //Это изменение также внесло некоторую путаницу: showError()вызов будет вызван независимо от того, что делает загрузка. Да, returnв коде все еще есть вызов, но теперь он фактически ничего не делает — он возвращается из замыкания, которое выполнялось асинхронно, а не из всего метода.
        
        //Сочетание этих проблем означает, что независимо от того, будет ли загрузка успешной или нет, showError()будет вызвано.
        
    }
    
//    func showError() {
//        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
    //Но это создало вторую проблему: showError()создает и показывает UIAlertController — теперь у нас есть работа пользовательского интерфейса, выполняемая в фоновом потоке, что всегда является плохой идеей.
        
//    }
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    //На этом этапе этот код находится в лучшем положении: мы делаем всю медленную работу вне основного потока, а затем возвращаем работу обратно в основной поток, когда нам нужно выполнить работу пользовательского интерфейса. Этот скачок фона/переднего плана является обычным явлением, и вы снова увидите его в последующих проектах.
    
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
//            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        //добавляет шеврон справа
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.font = .systemFont(ofSize: 17, weight: .bold)
        content.text = petitions[indexPath.row].title
        content.secondaryText = petitions[indexPath.row].body
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

//Есть еще один способ использования GCP, и его стоит рассмотреть, потому что он намного проще в некоторых конкретных обстоятельствах. Он называется performSelector(), и у него есть два интересных варианта: performSelector(inBackground:)и performSelector(onMainThread:).

//Оба они работают одинаково: вы передаете ему имя метода для запуска, и он inBackgroundзапустит его в фоновом потоке, а затем onMainThreadзапустит его в потоке переднего плана. Вам не нужно беспокоиться о том, как он организован; GCD позаботится обо всем за вас. Если вы собираетесь запустить целый метод либо в фоновом потоке, либо в основном потоке, эти два являются самыми простыми.

/*
 override func viewDidLoad() {
 super.viewDidLoad()
 
 performSelector(inBackground: #selector(fetchJSON), with: nil)
 }
 
 @objc func fetchJSON() {
 let urlString: String
 
 if navigationController?.tabBarItem.tag == 0 {
 urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
 } else {
 urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
 }
 
 if let url = URL(string: urlString) {
 if let data = try? Data(contentsOf: url) {
 parse(json: data)
 return
 }
 }
 
 performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
 }
 
 func parse(json: Data) {
 let decoder = JSONDecoder()
 
 if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
     petitions = jsonPetitions.results
     tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
 } else {
     performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
 }
 
 @objc func showError() {
 let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
 ac.addAction(UIAlertAction(title: "OK", style: .default))
 present(ac, animated: true)
 }
 */
