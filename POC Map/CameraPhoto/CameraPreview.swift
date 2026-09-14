import AVFoundation
import SwiftUI
import UIKit

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    let isFront: Bool
    let zoom: Double
    let onFocus: (CGPoint) -> Void
    let onZoom: (Double) -> Void
    let onRotation: (CGFloat) -> Void

    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer.session = session
        updateUIView(view, context: context)
        return view
    }

    func updateUIView(_ view: CameraPreviewUIView, context: Context) {
        view.isFront = isFront
        view.currentZoom = zoom
        view.onFocus = onFocus
        view.onZoom = onZoom
        view.onRotation = onRotation
        view.setNeedsLayout()
    }

    static func dismantleUIView(_ view: CameraPreviewUIView, coordinator: ()) {
        view.previewLayer.session = nil
    }
}

final class CameraPreviewUIView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    var isFront = false
    var currentZoom = 1.0
    var onFocus: ((CGPoint) -> Void)?
    var onZoom: ((Double) -> Void)?
    var onRotation: ((CGFloat) -> Void)?
    private var pinchStartZoom = 1.0
    private let focusIndicator = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        clipsToBounds = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinched(_:))))
        focusIndicator.layer.borderColor = UIColor.systemYellow.cgColor
        focusIndicator.layer.borderWidth = 1.5
        focusIndicator.isUserInteractionEnabled = false
        focusIndicator.alpha = 0
        addSubview(focusIndicator)
    }

    required init?(coder: NSCoder) { fatalError("Use init(frame:)") }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let connection = previewLayer.connection else {
            return
        }

        let angle: CGFloat

        switch window?.windowScene?.interfaceOrientation {
        case .landscapeLeft:
            angle = 0

        case .landscapeRight:
            angle = 180

        case .portraitUpsideDown:
            angle = 270

        default:
            angle = 90
        }

        if connection.isVideoRotationAngleSupported(angle),
           connection.videoRotationAngle != angle {
            connection.videoRotationAngle = angle
        }

        if connection.isVideoMirroringSupported {
            if connection.automaticallyAdjustsVideoMirroring {
                connection.automaticallyAdjustsVideoMirroring = false
            }

            if connection.isVideoMirrored != isFront {
                connection.isVideoMirrored = isFront
            }
        }

        onRotation?(angle)
    }

    @objc private func tapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let devicePoint = previewLayer.captureDevicePointConverted(fromLayerPoint: location)
        guard (0...1).contains(devicePoint.x), (0...1).contains(devicePoint.y) else { return }
        onFocus?(devicePoint)
        focusIndicator.layer.removeAllAnimations()
        focusIndicator.frame = CGRect(x: location.x - 32, y: location.y - 32, width: 64, height: 64)
        focusIndicator.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0.8, options: .beginFromCurrentState) {
            self.focusIndicator.alpha = 0
        }
    }

    @objc private func pinched(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began { pinchStartZoom = currentZoom }
        if gesture.state == .began || gesture.state == .changed {
            onZoom?(pinchStartZoom * Double(gesture.scale))
        }
    }
}
