//
//  PermissionViewModel.swift
//  Proyecto1
//
//  Created by Renata Sánchez on 01/03/25.
//

import Foundation
import Photos
import AVFoundation

class PermissionsViewModel: ObservableObject {
    @Published var cameraGranted = false
    @Published var photoLibraryGranted = false
    
    var areAllPermissionsGranted: Bool {
        return cameraGranted && photoLibraryGranted
    }
    
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.cameraGranted = granted
            }
        }
    }
    
    func requestPhotoLibraryAccess() {
        let currentStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        if currentStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.photoLibraryGranted = (status == .authorized || status == .limited)
                }
            }
        } else {
            self.photoLibraryGranted = (currentStatus == .authorized || currentStatus == .limited)
        }
    }
}
