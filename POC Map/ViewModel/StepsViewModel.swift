
import Observation
import AVFoundation
internal import SpriteKit


@Observable
final class StepsViewModel{
    let recipe: Recipe
    let steps: [RecipeStep]
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self.steps = recipe.steps
    }
    
    var cameraManager = CameraManager()
    
    var currentGesture: StepsEnum = .noValue
    
    // Controle de gesto sustentado
    var gestureHoldStart: Date? = nil
    var isInCooldown: Bool = false
    
    // Feedback visual
    var holdProgress: Double = 0.0
    var feedbackMessage: String? = nil
    
    let holdDuration: TimeInterval = 1.5
    let cooldownDuration: TimeInterval = 1.0
    
    var currentStepIndex: Int = 0
    
    var isCompleted = false
    
    var currentStep: RecipeStep {
        steps[currentStepIndex]
    }
    
    var totalSteps: Int {
        steps.count
    }
    
    var isFirstStep: Bool {
        currentStepIndex == 0
    }
    
    var isLastStep: Bool {
        currentStepIndex == totalSteps - 1
    }

    
    func nextStep() {
        guard !isLastStep else { return }
        currentStepIndex += 1
    }
    

    
    func previousStep() {
        guard !isFirstStep else { return }
        currentStepIndex -= 1
    }

   
}
