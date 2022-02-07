//
//  POIVC.swift
//  添加地点VC
//
//  Created by 李胜 on 2022/1/26.
//

import UIKit

class POIVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension POIVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
