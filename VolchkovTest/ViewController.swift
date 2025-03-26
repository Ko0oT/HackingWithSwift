//
//  ViewController.swift
//  VolchkovTest
//
//  Created by Citylink on 25.01.2025.
//

import UIKit
import Stevia
import WebKit

final class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    //MARK: - Lifecycle
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit() //Вторая строка сообщает представлению прогресса о необходимости установить размер макета таким образом, чтобы он полностью соответствовал его содержимому.
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: [.new], context: nil)
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem //для iPad
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    //MARK: WebViewNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
        //замыкание дает перейти только на тот сайт, который есть в списке
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }

        decisionHandler(.cancel)
        
        /*Есть несколько простых моментов, но их перевешивают сложные моменты, поэтому давайте подробно рассмотрим каждую строку, чтобы убедиться:

        1.Сначала мы устанавливаем константу url, равную URLнавигации. Это просто для того, чтобы сделать код более понятным.
        2.Во-вторых, мы используем if letсинтаксис для разворачивания значения необязательного url.host. Помните, я говорил, что это URLделает много работы для вас при правильном разборе URL-адресов? Ну, вот хороший пример: эта строка говорит: «если есть хост для этого URL-адреса, вытащите его» — и под «хостом» подразумевается «домен веб-сайта», например apple.com. Примечание: нам нужно разворачивать это осторожно, потому что не все URL-адреса имеют хосты.
        3.В-третьих, мы проходим по всем сайтам в нашем безопасном списке, помещая название сайта в websiteпеременную.
        4.В-четвертых, мы используем contains()метод String, чтобы проверить, существует ли где-либо в имени хоста каждый безопасный веб-сайт.
        5.В-пятых, если веб-сайт найден, то мы вызываем обработчик решений с положительным ответом — мы хотим разрешить загрузку.
        6.В-шестых, если веб-сайт был найден, после вызова decisionHandlerмы используем returnоператор. Это означает «выйти из метода сейчас».
        7.Наконец, если хост не установлен или если мы прошли весь цикл и ничего не нашли, мы вызываем обработчик решений с отрицательным ответом: отменить загрузку.*/
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}


