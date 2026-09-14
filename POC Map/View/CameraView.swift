import SwiftUI
import UIKit

@MainActor
struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var model = CameraModel()
    let onPhoto: (Data) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            
            let horizontalPadding: CGFloat = 12
            let cornerRadius: CGFloat = 28

            let previewWidth = max(
                geometry.size.width - (horizontalPadding * 2),
                1
            )

            let previewHeight = max(
                geometry.size.height * 0.68,
                1
            )
            
            VStack(spacing: 0) {
                topBar
                    .opacity(model.photoData == nil ? 1 : 0)
                
                viewfinder
                    .frame(
                        width: previewWidth,
                        height: previewHeight,
                        alignment: .center
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: cornerRadius,
                            style: .continuous
                        )
                    )
                    .frame(maxWidth: .infinity)
                
                bottomBar
                    .opacity(model.photoData==nil ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.black)
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
        .statusBarHidden()
        .onAppear { model.appear(isActive: scenePhase == .active) }
        .onDisappear { model.disappear() }
        .onChange(of: scenePhase) { _, phase in model.setActive(phase == .active) }
        .alert("Câmera", isPresented: Binding(
            get: { model.errorMessage != nil },
            set: { if !$0 { model.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { model.errorMessage = nil }
        } message: { Text(model.errorMessage ?? "") }
            .toolbar {
                if let data = model.photoData {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            model.retake()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .accessibilityLabel("Refazer")
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            onPhoto(data)
                            dismiss()
                        } label: {
                            Image(systemName: "checkmark")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green500)
                        .accessibilityLabel("Usar foto")
                    }
                }
            }
            .navigationBarBackButtonHidden(model.photoData != nil)
        
    }
    
    private var topBar: some View {
        HStack {
            Spacer()
            Button(action: {
                model.flash.toggle()
            }, label: {
                Image(systemName: model.flash.icon)
                    .foregroundStyle(model.flash == .off ? .white : .yellow)
            })
            .buttonStyle(.borderedProminent)
            .tint(.clear)
            .disabled(!model.state.supportsFlash || !model.canTakePhoto)
            .opacity(model.state.supportsFlash && model.photoData == nil ? 1 : 0)
            .accessibilityLabel("Flash: \(model.flash.title)")
        }
        .opacity(model.state.supportsFlash && model.photoData == nil ? 1 : 0)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    @ViewBuilder private var viewfinder: some View {
        if let image = model.photoImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .accessibilityLabel("Foto capturada")
        } else if model.accessDenied {
            ContentUnavailableView {
                Label("Permita o acesso à câmera", systemImage: "camera.fill")
            } description: {
                Text("Ative a permissão de câmera nos Ajustes para tirar uma foto.")
            } actions: {
                Button("Abrir Ajustes") {
                    if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
                }
            }
        } else {
            CameraPreview(
                session: model.session,
                isFront: model.state.isFront,
                zoom: model.state.zoom,
                onFocus: {
                    model.focus(at: $0)
                },
                onZoom: {
                    model.setZoom($0, animated: false)
                },
                onRotation: {
                    model.rotationAngle = $0
                }
            )
            .overlay {
                if model.isStarting {
                    ProgressView("Abrindo câmera…")
                } else if !model.state.isRunning && !model.state.isCapturing {
                    Button("Tentar novamente") { model.start() }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    @ViewBuilder private var bottomBar: some View {
        VStack(spacing: 18) {
            
            //Parte do zoom, caso for implementado depois
            let presets = model.zoomPresets.sorted()
            let zoom = model.displayedZoom

            let activeIndex = presets.lastIndex {
                $0 <= zoom
            } ?? presets.startIndex

            ZStack {
                ForEach(Array(presets.enumerated()), id: \.element) { index, factor in
                    let isActive = index == activeIndex
                    let displayedFactor = isActive ? zoom : factor

                    Button {
                        model.setZoom(factor)
                    } label: {
                        Text(
                            "\(displayedFactor.formatted(.number.precision(.fractionLength(0...1))))×"
                        )
                        .font(.subheadline.weight(.semibold))
                        .monospacedDigit()
                        .foregroundStyle(isActive ? .yellow : .white)
                        .frame(width: 44, height: 44)
                        .background(
                            .white.opacity(isActive ? 0.22 : 0),
                            in: Circle()
                        )
                        .minimumScaleFactor(0.8)
                        .contentShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(isActive ? 1.12 : 1)
                    .offset(x: CGFloat(index - activeIndex) * 56)
                    .animation(
                        .spring(response: 0.3, dampingFraction: 0.85),
                        value: activeIndex
                    )
                    .transition(.identity)
                    .accessibilityLabel("Selecionar zoom \(factor) vezes")
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .clipped()
            .disabled(!model.canTakePhoto)
            .opacity(model.state.isFront ? 0 : 1)
            .allowsHitTesting(!model.state.isFront)
            .accessibilityHidden(model.state.isFront)
            
            HStack {
                Color.clear.frame(width: 52, height: 52)
                Spacer()
                Button {
                    model.takePhoto()
                } label: {
                    ZStack {
                        Circle().stroke(.white, lineWidth: 4).frame(width: 76, height: 76)
                        Circle().fill(.white).frame(width: 64, height: 64)
                    }
                }
                .disabled(!model.canTakePhoto)
                .opacity(model.canTakePhoto || model.state.isCapturing ? 1 : 0.4)
                .accessibilityLabel("Tirar foto")
                Spacer()
                Button { model.switchCamera() } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .font(.title2)
                        .frame(width: 52, height: 52)
                        .background(.white.opacity(0.12), in: Circle())
                }
                .disabled(!model.canTakePhoto || !model.state.canSwitchCamera)
                .accessibilityLabel("Alternar câmera frontal e traseira")
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 12)
        
    }
}
