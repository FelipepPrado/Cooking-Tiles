import SwiftUI
import UIKit
internal import Combine

struct StepsView: View {
    @Environment(ViewRouter.self) private var viewRouter
    
    var viewModel: StepsViewModel
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Group {
            if let frame = viewModel.cameraManager.currentFrame {
                ZStack {
                    // Feed da câmera como fundo
                    Image(frame, scale: 1, orientation: .up, label: Text("Camera Feed"))
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(x: -1, y: 1)
                    
                    // Overlay escuro para legibilidade
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .accessibilityHidden(true)
                    
                    // Conteúdo da receita
                    VStack(spacing: 16) {
                        if let message = viewModel.feedbackMessage {
                            Text(message)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .transition(.scale.combined(with: .opacity))
                                .accessibilityLabel(message)
                                .accessibilityAddTraits(.updatesFrequently)

                        }
                        
                        Spacer()
                        
                        RecipeStepComponent(
                            recipe: viewModel.recipe,
                            step: viewModel.currentStep,
                            totalSteps: viewModel.totalSteps,
                            detectedGesture: viewModel.currentGesture,
                            holdProgress: viewModel.holdProgress,
                            isFirstStep: viewModel.isFirstStep,
                            isLastStep: viewModel.isLastStep,
                            isCompleted: viewModel.isCompleted,
                            onFinish: {
                                viewRouter.removeLast()
                            },
                            onRegister: {
                                viewRouter.newMealView()
                            },
                            viewModel: viewModel
                        )
                    }
                }
            } else {
                ProgressView("Ligando câmera...")
                    .accessibilityLabel("Carregando camera, por favor aguarde")
            }
        }
        .onReceive(timer) { _ in
            checkGesture()
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.feedbackMessage)
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentStepIndex)
    }
    
    private func checkGesture() {
        let detected = viewModel.cameraManager.handAnalyzer.detectedPose
    
        let isActionGesture = (detected == .passar || detected == .voltar)
        

        if viewModel.isInCooldown { return }
        
        if isActionGesture && detected == viewModel.currentGesture {
          
            if let start = viewModel.gestureHoldStart {
                let elapsed = Date.now.timeIntervalSince(start)
                viewModel.holdProgress = min(elapsed / viewModel.holdDuration, 1.0)
                
                if elapsed >= viewModel.holdDuration {
                   
                    executeGestureAction(detected)
                }
            }
        } else if isActionGesture {
          
            viewModel.currentGesture = detected
            viewModel.gestureHoldStart = Date.now
            viewModel.holdProgress = 0.0
        } else {
         
            resetGesture()
        }
    }
    
    private func executeGestureAction(_ gesture: StepsEnum) {
        switch gesture {
        case .passar:
            if !viewModel.isCompleted {
                if viewModel.isLastStep {
                    viewModel.isCompleted = true
                    viewModel.feedbackMessage = "Receita completa"
                    UIAccessibility.post(
                        notification: .announcement,
                        argument: "Receita completa! Você pode finalizar ou registrar a receita."
                    )
                } else {
                    viewModel.nextStep()
                    viewModel.feedbackMessage = "Próxima etapa"
                    let step = viewModel.currentStep
                    UIAccessibility.post(
                        notification: .announcement,
                        argument: "Etapa \(step.order) de \(viewModel.totalSteps): \(step.instruction)"
                    )
                }
            }

        case .voltar:
            if viewModel.isCompleted {
                viewModel.isCompleted = false
                let step = viewModel.currentStep
                UIAccessibility.post(
                    notification: .announcement,
                    argument: "Voltou para etapa \(step.order) de \(viewModel.totalSteps): \(step.instruction)"
                )
                viewModel.feedbackMessage = "Etapa anterior"
            } else if !viewModel.isFirstStep {
                viewModel.previousStep()
                viewModel.feedbackMessage = "Etapa anterior"
                let step = viewModel.currentStep
                UIAccessibility.post(
                    notification: .announcement,
                    argument: "Etapa \(step.order) de \(viewModel.totalSteps): \(step.instruction)"
                )
            }

        default:
            break
        }
        
     
        resetGesture()
        viewModel.isInCooldown = true
        
   
        DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.cooldownDuration) {
            viewModel.isInCooldown = false
            viewModel.feedbackMessage = nil
        }
    }
    
    private func resetGesture() {
        viewModel.currentGesture = .noValue
        viewModel.gestureHoldStart = nil
        viewModel.holdProgress = 0.0
    }
}

//#Preview {
//    StepsView()
//}
