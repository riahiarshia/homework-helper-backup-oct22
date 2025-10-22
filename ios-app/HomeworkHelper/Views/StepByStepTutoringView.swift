import SwiftUI

struct StepByStepTutoringView: View {
    @StateObject private var apiService = BackendAPIService.shared
    @State private var currentSession: TutoringSession?
    @State private var currentStep: TutoringStep?
    @State private var selectedAnswer: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showCompletion = false
    @State private var problemContext: String
    
    init(problemContext: String) {
        self._problemContext = State(initialValue: problemContext)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let session = currentSession {
                    VStack(spacing: 20) {
                        // Progress Header
                        ProgressHeaderView(
                            currentStep: session.currentStep,
                            totalSteps: session.totalSteps,
                            progress: session.progress
                        )
                        
                        // Current Step Content
                        if let step = currentStep {
                            StepContentView(
                                step: step,
                                selectedAnswer: $selectedAnswer,
                                onSubmit: submitAnswer
                            )
                        }
                        
                        Spacer()
                    }
                    .padding()
                } else {
                    VStack(spacing: 20) {
                        Text("Starting Step-by-Step Tutoring")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("We'll guide you through this problem one step at a time.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Start Learning") {
                            startTutoringSession()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(isLoading)
                    }
                    .padding()
                }
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Step-by-Step Learning")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if currentSession == nil {
                    startTutoringSession()
                }
            }
            .alert("Congratulations!", isPresented: $showCompletion) {
                Button("OK") {
                    // Handle completion
                }
            } message: {
                Text("You've completed all the steps! Great job learning through this problem.")
            }
        }
    }
    
    private func startTutoringSession() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let session = try await apiService.startTutoringSession(
                    problemContext: problemContext,
                    userGradeLevel: "elementary"
                )
                
                await MainActor.run {
                    self.currentSession = session
                    self.currentStep = session.step
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func submitAnswer() {
        guard let session = currentSession,
              !selectedAnswer.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let updatedSession = try await apiService.submitAnswer(
                    sessionId: session.sessionId,
                    studentAnswer: selectedAnswer,
                    userGradeLevel: "elementary"
                )
                
                await MainActor.run {
                    self.currentSession = updatedSession
                    self.currentStep = updatedSession.step
                    self.selectedAnswer = ""
                    self.isLoading = false
                    
                    if updatedSession.isCompleted {
                        self.showCompletion = true
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

struct ProgressHeaderView: View {
    let currentStep: Int
    let totalSteps: Int
    let progress: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Step \(currentStep) of \(totalSteps)")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(progress)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: Double(currentStep), total: Double(totalSteps))
                .progressViewStyle(LinearProgressViewStyle())
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StepContentView: View {
    let step: TutoringStep
    @Binding var selectedAnswer: String
    let onSubmit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(step.question)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(step.explanation)
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                ForEach(step.options, id: \.self) { option in
                    Button(action: {
                        selectedAnswer = option
                    }) {
                        HStack {
                            Text(option)
                                .font(.body)
                                .foregroundColor(selectedAnswer == option ? .white : .primary)
                            
                            Spacer()
                            
                            if selectedAnswer == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(
                            selectedAnswer == option ? 
                            Color.blue : Color(.systemGray6)
                        )
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            if let hint = step.hint, !hint.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("💡 Hint")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    
                    Text(hint)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
            
            Button("Submit Answer") {
                onSubmit()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(selectedAnswer.isEmpty)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    StepByStepTutoringView(problemContext: "Find the perimeter of a rectangle with width 163m and length 320m")
}
