import Foundation
import SwiftUI
import Combine

final class CircleProgressViewModel: ObservableObject {
    @Published var progressValue: CGFloat = 0.0
    private var timerCount: CGFloat = 0.0
    private var cancellable: AnyCancellable?
    @Published var shouldResumeAnimation: Bool = false
    
    init() {
        startTimer()
    }
    
    func resumeAnimation() {
        guard shouldResumeAnimation else { return }
        startTimer()
    }
    
    private func startTimer() {
        cancellable = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.countProgress()
            }
    }
    
    private func countProgress() {
        if timerCount > 0.2 { cancellable?.cancel() 
            if shouldResumeAnimation {
                startTimer()
            }
        }
        timerCount = timerCount + 0.1
        progressValue = timerCount / 2
    }
}
