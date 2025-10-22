import Foundation
import UIKit

// MARK: - Data Models

struct ImageVerificationResult: Codable {
    let isValidHomework: Bool
    let confidence: Double
    let subject: String?
    let readabilityScore: Double
}

struct ProblemAnalysis: Codable {
    let subject: String
    let difficulty: String
    let currentStep: StepData
    let totalSteps: Int
    let problemDescription: String
    let nextStepPreview: String
    let progress: String
    let finalAnswer: String
}

struct StepData: Codable {
    let question: String
    let explanation: String
    let options: [String]
    let correctAnswer: String
    let hint: String?
}


// MARK: - Backend API Service

class BackendAPIService: ObservableObject {
    static let shared = BackendAPIService()
    
    @Published var isLoading = false
    @Published var error: String?
    @Published var progressMessage: String = ""
    @Published var isAnalyzing = false
    
    // Update this URL to your deployed backend
    private let baseURL = Config.apiBaseURL
    private let session: URLSession
    private let keychain = KeychainHelper.shared
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Config.API.requestTimeout // Use Config timeout settings
        config.timeoutIntervalForResource = Config.API.resourceTimeout // Use Config timeout settings
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)
        
        // Device-specific debugging
        print("🔍 DEBUG BackendAPIService init:")
        print("   Device: \(UIDevice.current.model)")
        print("   iOS Version: \(UIDevice.current.systemVersion)")
        print("   Timeout settings: Request=\(config.timeoutIntervalForRequest)s, Resource=\(config.timeoutIntervalForResource)s")
    }
    
    // MARK: - Authentication Helper
    
    private func addAuthHeader(to request: inout URLRequest) {
        if let token = keychain.load(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔐 Added auth token to request")
        } else {
            print("⚠️ No auth token found in keychain")
        }
    }
    
    // MARK: - Device ID Helper
    
    private func getDeviceId() -> String {
        // Get or create a persistent device ID
        let deviceIdKey = "app_device_id"
        if let existingId = keychain.load(forKey: deviceIdKey) {
            return existingId
        }
        
        // Create new device ID using UIDevice identifier
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        _ = keychain.save(deviceId, forKey: deviceIdKey)
        return deviceId
    }
    
    // MARK: - Image Quality Validation
    
    func validateImageQuality(imageData: Data, userId: String? = nil) async throws -> ImageQualityValidation {
        await MainActor.run { isLoading = true }
        defer { 
            Task { @MainActor in
                isLoading = false
            }
        }
        
        let url = URL(string: "\(baseURL)/api/validate-image")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        addAuthHeader(to: &request)
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add userId if available
        if let userId = userId {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"userId\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(userId)\r\n".data(using: .utf8)!)
        }
        
        // Add deviceId
        let deviceId = getDeviceId()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"deviceId\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(deviceId)\r\n".data(using: .utf8)!)
        
        // Add image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"homework.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw BackendAPIError.noResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorMessage = errorData["error"] as? String {
                    throw BackendAPIError.serverError(errorMessage)
                } else {
                    throw BackendAPIError.serverError("Server error: \(httpResponse.statusCode)")
                }
            }
            
            let validation = try JSONDecoder().decode(ImageQualityValidation.self, from: data)
            return validation
            
        } catch {
            if error is BackendAPIError {
                throw error
            } else {
                throw BackendAPIError.networkError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Homework Analysis
    
    func analyzeHomework(imageData: Data?, problemText: String?, userGradeLevel: String, userId: String? = nil, teacherMethodImageData: Data? = nil) async throws -> ProblemAnalysis {
        print("🔍 DEBUG BackendAPIService.analyzeHomework:")
        print("   Image data provided: \(imageData != nil)")
        print("   Problem text provided: \(problemText != nil)")
        print("   Teacher method image provided: \(teacherMethodImageData != nil)")
        print("   User grade level: \(userGradeLevel)")
        print("   User ID: \(userId ?? "nil")")
        print("   Base URL: \(baseURL)")
        
        await MainActor.run {
            isLoading = true
            isAnalyzing = true
            progressMessage = "Starting analysis..."
        }
        
        defer { 
            Task { @MainActor in
                isLoading = false
                isAnalyzing = false
                progressMessage = ""
            }
        }
        
        let url = URL(string: "\(baseURL)/api/analyze-homework")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        addAuthHeader(to: &request)
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add userId if available
        if let userId = userId {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"userId\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(userId)\r\n".data(using: .utf8)!)
        }
        
        // Add deviceId
        let deviceId = getDeviceId()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"deviceId\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(deviceId)\r\n".data(using: .utf8)!)
        
        // Add image data if provided
        if let imageData = imageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"homework.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Add teacher method image data if provided
        if let teacherMethodImageData = teacherMethodImageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"teacherMethodImage\"; filename=\"teacher_method.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(teacherMethodImageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Add problem text if provided
        if let problemText = problemText {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"problemText\"\r\n\r\n".data(using: .utf8)!)
            body.append(problemText.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Add user grade level
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"userGradeLevel\"\r\n\r\n".data(using: .utf8)!)
        body.append(userGradeLevel.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Start progress updates every 30 seconds
        let progressTask = Task {
            await updateProgressMessages()
        }
        
        do {
            print("🔍 DEBUG BackendAPIService: Making request to \(url)")
            print("🔍 DEBUG BackendAPIService: Network connectivity check...")
            
            // Check network connectivity first
            let reachability = try await checkNetworkConnectivity()
            print("🔍 DEBUG BackendAPIService: Network reachable: \(reachability)")
            
            let (data, response) = try await session.data(for: request)
            
            // Cancel progress updates
            progressTask.cancel()
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ DEBUG BackendAPIService: No HTTP response received")
                throw BackendAPIError.noResponse
            }
            
            print("🔍 DEBUG BackendAPIService: HTTP Status Code: \(httpResponse.statusCode)")
            
            guard httpResponse.statusCode == 200 else {
                print("❌ DEBUG BackendAPIService: HTTP Error \(httpResponse.statusCode)")
                if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorMessage = errorData["error"] as? String {
                    print("❌ DEBUG BackendAPIService: Server error message: \(errorMessage)")
                    throw BackendAPIError.serverError(errorMessage)
                } else {
                    let responseString = String(data: data, encoding: .utf8) ?? "No response data"
                    print("❌ DEBUG BackendAPIService: Raw response: \(responseString)")
                    throw BackendAPIError.serverError("Server error: \(httpResponse.statusCode)")
                }
            }
            
            print("🔍 DEBUG BackendAPIService: Successfully received response data")
            let responseString = String(data: data, encoding: .utf8) ?? "No response data"
            print("🔍 DEBUG BackendAPIService: Response data: \(responseString)")
            
            let analysis = try JSONDecoder().decode(ProblemAnalysis.self, from: data)
            print("🔍 DEBUG BackendAPIService: Successfully decoded analysis:")
            print("   Subject: \(analysis.subject)")
            print("   Difficulty: \(analysis.difficulty)")
            print("   Total steps: \(analysis.totalSteps)")
            print("   Current step: \(analysis.currentStep.question)")
            print("   Progress: \(analysis.progress)")
            
            return analysis
            
        } catch {
            print("❌ DEBUG BackendAPIService: Request failed with error: \(error)")
            if error is BackendAPIError {
                throw error
            } else {
                throw BackendAPIError.networkError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Network Connectivity
    
    private func checkNetworkConnectivity() async throws -> Bool {
        guard let url = URL(string: "https://www.google.com") else {
            return false
        }
        
        do {
            let (_, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            return false
        } catch {
            print("❌ DEBUG BackendAPIService: Network connectivity check failed: \(error)")
            return false
        }
    }
    
    // MARK: - Progress Updates
    
    private func updateProgressMessages() async {
        let messages = [
            "Analyzing your homework...",
            "Still analyzing... Please wait.",
            "Almost done... Keep waiting.",
            "Final processing... Almost there!"
        ]
        
        for (index, message) in messages.enumerated() {
            // Wait 30 seconds between messages
            try? await Task.sleep(nanoseconds: 30_000_000_000)
            
            // Check if we're still analyzing
            guard isAnalyzing else { break }
            
            await MainActor.run {
                progressMessage = message
            }
            
            // Stop after 90 seconds (3 messages)
            if index >= 2 { break }
        }
    }
    
    // MARK: - Hint Generation
    
    func generateHint(for step: GuidanceStep, problemContext: String, userGradeLevel: String, userId: String? = nil) async throws -> String {
        await MainActor.run { isLoading = true }
        defer { 
            Task { @MainActor in
                isLoading = false
            }
        }
        
        let url = URL(string: "\(baseURL)/api/hint")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        addAuthHeader(to: &request)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var requestBody: [String: Any] = [
            "step": [
                "question": step.question,
                "explanation": step.explanation,
                "options": step.options,
                "correctAnswer": step.correctAnswer
            ],
            "problemContext": problemContext,
            "userGradeLevel": userGradeLevel
        ]
        
        // Add userId if available
        if let userId = userId {
            requestBody["userId"] = userId
        }
        
        // Add deviceId
        requestBody["deviceId"] = getDeviceId()
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw BackendAPIError.noResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorMessage = errorData["error"] as? String {
                    throw BackendAPIError.serverError(errorMessage)
                } else {
                    throw BackendAPIError.serverError("Server error: \(httpResponse.statusCode)")
                }
            }
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let hint = json["hint"] as? String {
                return hint
            } else {
                throw BackendAPIError.invalidResponse
            }
            
        } catch {
            if error is BackendAPIError {
                throw error
            } else {
                throw BackendAPIError.networkError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Answer Verification
    
    func verifyAnswer(answer: String, step: GuidanceStep, problemContext: String, userGradeLevel: String, userId: String? = nil) async throws -> AnswerVerification {
        await MainActor.run { isLoading = true }
        defer { 
            Task { @MainActor in
                isLoading = false
            }
        }
        
        let url = URL(string: "\(baseURL)/api/verify")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        addAuthHeader(to: &request)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var requestBody: [String: Any] = [
            "answer": answer,
            "step": [
                "question": step.question,
                "explanation": step.explanation,
                "options": step.options,
                "correctAnswer": step.correctAnswer
            ],
            "problemContext": problemContext,
            "userGradeLevel": userGradeLevel
        ]
        
        // Add userId if available
        if let userId = userId {
            requestBody["userId"] = userId
        }
        
        // Add deviceId
        requestBody["deviceId"] = getDeviceId()
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw BackendAPIError.noResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorMessage = errorData["error"] as? String {
                    throw BackendAPIError.serverError(errorMessage)
                } else {
                    throw BackendAPIError.serverError("Server error: \(httpResponse.statusCode)")
                }
            }
            
            let verification = try JSONDecoder().decode(AnswerVerification.self, from: data)
            return verification
            
        } catch {
            if error is BackendAPIError {
                throw error
            } else {
                throw BackendAPIError.networkError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Health Check
    
    func checkHealth() async throws -> HealthStatus {
        let url = URL(string: "\(baseURL)/health")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw BackendAPIError.noResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw BackendAPIError.serverError("Health check failed: \(httpResponse.statusCode)")
            }
            
            let health = try JSONDecoder().decode(HealthStatus.self, from: data)
            return health
            
        } catch {
            if error is BackendAPIError {
                throw error
            } else {
                throw BackendAPIError.networkError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Chat Response
    
    func generateChatResponse(messages: [ChatMessage], problemContext: String, userGradeLevel: String, userId: String? = nil) async throws -> String {
        await MainActor.run { isLoading = true }
        defer { 
            Task { @MainActor in
                isLoading = false
            }
        }
        
        let url = URL(string: "\(baseURL)/api/chat")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        addAuthHeader(to: &request)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var requestBody = ChatRequest(
            messages: messages,
            problemContext: problemContext,
            userGradeLevel: userGradeLevel
        )
        requestBody.userId = userId
        requestBody.deviceId = getDeviceId()
        
        let jsonData = try JSONEncoder().encode(requestBody)
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw BackendAPIError.noResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorMessage = errorData["error"] as? String {
                    throw BackendAPIError.serverError(errorMessage)
                } else {
                    throw BackendAPIError.serverError("Server error: \(httpResponse.statusCode)")
                }
            }
            
            let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
            return chatResponse.response
            
        } catch {
            if error is BackendAPIError {
                throw error
            } else {
                throw BackendAPIError.networkError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Homework Tracking
    
    func trackHomeworkSubmission(problem: HomeworkProblem) async throws {
        print("📝 Tracking homework submission to backend...")
        
        guard let url = URL(string: "\(baseURL)/api/homework/submit") else {
            throw BackendAPIError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeader(to: &request)
        
        let submissionData: [String: Any] = [
            "problemId": problem.id.uuidString,
            "subject": problem.subject ?? "Unknown",
            "problemText": problem.problemText ?? "",
            "imageFilename": problem.imageFilename ?? "",
            "totalSteps": problem.totalSteps,
            "completedSteps": problem.completedSteps,
            "skippedSteps": problem.skippedSteps,
            "status": problem.status.rawValue,
            "timeSpentSeconds": 0,
            "hintsUsed": 0
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: submissionData)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BackendAPIError.noResponse
        }
        
        if httpResponse.statusCode == 200 {
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let totalSubmissions = json["totalSubmissions"] as? Int {
                print("✅ Homework submission tracked! Total submissions: \(totalSubmissions)")
            }
        } else {
            print("⚠️ Failed to track homework submission: \(httpResponse.statusCode)")
        }
    }
    
    func updateHomeworkCompletion(problemId: UUID, completionData: [String: Any]) async throws {
        print("✅ Updating homework completion in backend...")
        
        guard let url = URL(string: "\(baseURL)/api/homework/complete/\(problemId.uuidString)") else {
            throw BackendAPIError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeader(to: &request)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: completionData)
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BackendAPIError.noResponse
        }
        
        if httpResponse.statusCode == 200 {
            print("✅ Homework completion updated in backend!")
        } else {
            print("⚠️ Failed to update homework completion: \(httpResponse.statusCode)")
        }
    }
    
    func getUserHomeworkStats() async throws -> HomeworkStats {
        print("📊 Fetching user homework stats...")
        
        guard let url = URL(string: "\(baseURL)/api/homework/stats") else {
            throw BackendAPIError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        addAuthHeader(to: &request)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BackendAPIError.noResponse
        }
        
        if httpResponse.statusCode == 200 {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let statsData = json["stats"] as? [String: Any] {
                let statsJsonData = try JSONSerialization.data(withJSONObject: statsData)
                let stats = try decoder.decode(HomeworkStats.self, from: statsJsonData)
                print("✅ Fetched homework stats: \(stats.totalSubmissions) total submissions")
                return stats
            }
        }
        
        throw BackendAPIError.invalidResponse
    }
    
    // MARK: - Step-by-Step Tutoring Methods
    
    func startTutoringSession(problemContext: String, userGradeLevel: String = "elementary") async throws -> TutoringSession {
        let url = URL(string: "\(baseURL)/api/tutoring/session/start")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = TutoringSessionRequest(
            userId: nil, // TODO: Add user ID when authentication is implemented
            deviceId: getDeviceId(),
            problemContext: problemContext,
            userGradeLevel: userGradeLevel
        )
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BackendAPIError.noResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw BackendAPIError.serverError("Server error: \(httpResponse.statusCode) - \(errorMessage)")
        }
        
        let tutoringSession = try JSONDecoder().decode(TutoringSession.self, from: data)
        return tutoringSession
    }
    
    func startTutoringSessionWithImage(imageData: Data, userGradeLevel: String = "elementary", teacherMethodImageData: Data? = nil) async throws -> TutoringSession {
        print("🔍 DEBUG BackendAPIService: Starting tutoring session with image")
        print("   Image data size: \(imageData.count) bytes")
        print("   User grade level: \(userGradeLevel)")
        print("   Has teacher method image: \(teacherMethodImageData != nil)")
        
        let url = URL(string: "\(baseURL)/api/tutoring/session/start-image")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create multipart form data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add image
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"homework.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add teacher method image if provided
        if let teacherMethodData = teacherMethodImageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"teacherMethodImage\"; filename=\"teacher_method.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(teacherMethodData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Add user grade level
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"userGradeLevel\"\r\n\r\n".data(using: .utf8)!)
        body.append(userGradeLevel.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add device ID
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"deviceId\"\r\n\r\n".data(using: .utf8)!)
        body.append(getDeviceId().data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add user ID (using nil for now since authentication is not implemented)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"userId\"\r\n\r\n".data(using: .utf8)!)
        body.append("anonymous".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BackendAPIError.noResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw BackendAPIError.serverError("Server error: \(httpResponse.statusCode) - \(errorMessage)")
        }
        
        let tutoringSession = try JSONDecoder().decode(TutoringSession.self, from: data)
        return tutoringSession
    }
    
    func getCurrentStep(sessionId: String) async throws -> TutoringSession {
        let url = URL(string: "\(baseURL)/api/tutoring/session/\(sessionId)/current-step")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BackendAPIError.noResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw BackendAPIError.serverError("Server error: \(httpResponse.statusCode) - \(errorMessage)")
        }
        
        let tutoringSession = try JSONDecoder().decode(TutoringSession.self, from: data)
        return tutoringSession
    }
    
    func submitAnswer(sessionId: String, studentAnswer: String, userGradeLevel: String = "elementary") async throws -> TutoringSession {
        let url = URL(string: "\(baseURL)/api/tutoring/session/\(sessionId)/answer")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = TutoringAnswerRequest(
            studentAnswer: studentAnswer,
            userGradeLevel: userGradeLevel
        )
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BackendAPIError.noResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw BackendAPIError.serverError("Server error: \(httpResponse.statusCode) - \(errorMessage)")
        }
        
        let tutoringSession = try JSONDecoder().decode(TutoringSession.self, from: data)
        return tutoringSession
    }
    
    func getSessionProgress(sessionId: String) async throws -> TutoringProgress {
        let url = URL(string: "\(baseURL)/api/tutoring/session/\(sessionId)/progress")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BackendAPIError.noResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw BackendAPIError.serverError("Server error: \(httpResponse.statusCode) - \(errorMessage)")
        }
        
        let progress = try JSONDecoder().decode(TutoringProgress.self, from: data)
        return progress
    }
    
    func completeSession(sessionId: String) async throws -> TutoringProgress {
        let url = URL(string: "\(baseURL)/api/tutoring/session/\(sessionId)/complete")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BackendAPIError.noResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw BackendAPIError.serverError("Server error: \(httpResponse.statusCode) - \(errorMessage)")
        }
        
        let progress = try JSONDecoder().decode(TutoringProgress.self, from: data)
        return progress
    }
}

// MARK: - Supporting Types

struct AnswerVerification: Codable {
    let isCorrect: Bool
    let verification: String
}

struct HealthStatus: Codable {
    let status: String
    let timestamp: String
    let version: String
}

struct ImageQualityValidation: Codable {
    let isGoodQuality: Bool
    let confidence: Double
    let issues: [String]
    let recommendations: [String]
}

struct ChatRequest: Codable {
    let messages: [ChatMessage]
    let problemContext: String
    let userGradeLevel: String
    var userId: String?
    var deviceId: String?
}

struct ChatResponse: Codable {
    let response: String
}

// MARK: - Step-by-Step Tutoring Models

struct TutoringSession: Codable {
    let sessionId: String
    let userId: String?
    let deviceId: String?
    let problemContext: String?
    let currentStep: Int
    let totalSteps: Int
    let subject: String?
    let difficulty: String?
    let steps: [TutoringStep?]?
    let studentAnswers: [String]?
    let createdAt: String?
    let lastActivity: String?
    let isCompleted: Bool
}

struct TutoringStep: Codable {
    let question: String
    let explanation: String
    let options: [String]
    let correctAnswer: String
    let hint: String?
}

struct TutoringProgress: Codable {
    let sessionId: String
    let currentStep: Int
    let totalSteps: Int
    let progress: String
    let isCompleted: Bool
    let stepsCompleted: Int
    let lastActivity: String
}

// MARK: - Tutoring Request Models

struct TutoringSessionRequest: Codable {
    let userId: String?
    let deviceId: String?
    let problemContext: String
    let userGradeLevel: String
}

struct TutoringAnswerRequest: Codable {
    let studentAnswer: String
    let userGradeLevel: String
}


// MARK: - Homework Stats Models

struct HomeworkStats: Codable {
    let totalSubmissions: Int
    let detailedSubmissionCount: Int
    let completedCount: Int
    let inProgressCount: Int
    let avgTimeSeconds: Int
    let avgHintsUsed: Int
}

// MARK: - Error Types

enum BackendAPIError: Error, LocalizedError {
    case noResponse
    case invalidResponse
    case networkError(String)
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .noResponse:
            return "No response from server"
        case .invalidResponse:
            return "Invalid response format"
        case .networkError(let message):
            return "Network error: \(message)"
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
}
