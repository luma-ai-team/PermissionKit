//
//  PhotoLibraryPermission.swift
//
//
//  Created by Roi Mulia on 18/11/2022.
//

import Photos
import UIKit

public class PhotoLibraryPermission {
    
    public typealias PermissionHandler = (PHAuthorizationStatus) -> Void
    
    // MARK: - Public Methods
    
    public static func currentStatus(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus(for: accessLevel)
    }

    public static func requestPermission(for accessLevel: PHAccessLevel, completion: @escaping PermissionHandler) {
        PHPhotoLibrary.requestAuthorization(for: accessLevel) { status in
            DispatchQueue.main.async {
                handlePermissionRequest(for: accessLevel, with: status, completion: completion)
            }
        }
    }

    public static func redirectToSettings() {
        DispatchQueue.main.async {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Private Methods
    
    private static func handlePermissionRequest(for accessLevel: PHAccessLevel, with status: PHAuthorizationStatus, completion: @escaping PermissionHandler) {
        switch status {
        case .notDetermined:
            requestPermission(for: accessLevel, completion: completion)
        default:
            completion(status)
        }
    }
}

// MARK: - PHAuthorizationStatus Extension

public extension PHAuthorizationStatus {
    var isAuthorized: Bool {
        switch self {
        case .authorized, .limited:
            return true
        default:
            return false
        }
    }
}
