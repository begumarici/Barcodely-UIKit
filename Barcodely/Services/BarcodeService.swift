//
//  BarcodeService.swift
//  Barcodely
//
//  Created by Begüm Arıcı on 31.10.2025.
//

import AVFoundation
import UIKit

class BarcodeService: NSObject {
    
    // MARK: - Properties
    private let captureSession: AVCaptureSession
    private let previewLayer: AVCaptureVideoPreviewLayer
    
    var onBarcodeDetected: ((String) -> Void)?
    
    // MARK: - Initialization
    override init() {
        captureSession = AVCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        super.init()
    }
    
    // MARK: - Setup
    func setup(on view: UIView) {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("no camera found")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("camera input error: \(error)")
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("input cannot added")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .upce]
        } else {
            print("metadata cannot added")
            return
        }
        
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
    }
    
    // MARK: - Public Methods
    func startScanning() {
        guard !captureSession.isRunning else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func stopScanning() {
        guard captureSession.isRunning else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.stopRunning()
        }
    }
    
    func updatePreviewLayerFrame(_ frame: CGRect) {
        previewLayer.frame = frame
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension BarcodeService: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first else { return }
        
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                
        guard let barcode = readableObject.stringValue else { return }
        
        onBarcodeDetected?(barcode)
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
