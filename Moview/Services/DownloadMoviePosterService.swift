//
//  DownloadMoviePosterService.swift
//  Moview
//
//  Created by Mehti Ozkan on 4.05.2021.
//

import Foundation
import UIKit


class DownloadMoviePosterService: BaseService
{
    func getImageFromURL(path: String, _ completion: @escaping (_ success: Bool, _ image: UIImage?) -> Void)
    {
        requestWith(url: path, method: .get).response
        { response in
                let success = (response.data != nil && response.data != nil)
                var image: UIImage? = nil
            
                if success
                {
                    image = UIImage(data: response.data!)
                }
            
            completion(success, image)
        }
    }
}
