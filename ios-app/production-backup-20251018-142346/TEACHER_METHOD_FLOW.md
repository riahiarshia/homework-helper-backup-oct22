# Teacher Method Feature - Visual Flow Diagram

## Complete User Journey

```
┌─────────────────────────────────────────────────────────────────┐
│                         START: Home Screen                        │
│                                                                   │
│  [Camera Button]  [Photo Library Button]                         │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              Student Captures/Selects Problem Image              │
│                                                                   │
│  📸 Camera or 📚 Photo Library                                   │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Image Cropper (Problem)                        │
│                                                                   │
│  ✂️ Student crops to focus on specific problem                   │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                  🦉 TEACHER METHOD PROMPT 🦉                      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  "Does your teacher want you to use a specific method   │   │
│  │   to solve this problem?"                               │   │
│  │                                                          │   │
│  │  [✓ Yes, show me how to take a photo]                   │   │
│  │                                                          │   │
│  │  [✗ No, use any method]                                 │   │
│  └─────────────────────────────────────────────────────────┘   │
└────────────┬──────────────────────────────┬─────────────────────┘
             │                              │
      (User selects NO)            (User selects YES)
             │                              │
             ▼                              ▼
┌─────────────────────────┐   ┌──────────────────────────────────┐
│  Proceed to Analysis    │   │   Image Source Selection         │
│  (No Teacher Method)    │   │                                  │
│                         │   │  Choose:                         │
│  • Problem image only   │   │  • 📸 Camera                     │
│  • Standard AI method   │   │  • 📚 Photo Library              │
└────────┬────────────────┘   │  • ✗ Cancel (go to analysis)    │
         │                    └──────────┬───────────────────────┘
         │                               │
         │                               ▼
         │              ┌─────────────────────────────────────────┐
         │              │   Capture/Select Teacher Method Image   │
         │              │                                         │
         │              │   📸 Camera or 📚 Photo Library         │
         │              └──────────┬──────────────────────────────┘
         │                         │
         │                         ▼
         │              ┌─────────────────────────────────────────┐
         │              │   Image Cropper (Teacher Method)        │
         │              │                                         │
         │              │   ✂️ Crop teacher's method example     │
         │              └──────────┬──────────────────────────────┘
         │                         │
         └─────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    🔄 PROCESSING ANALYSIS                         │
│                                                                   │
│  • Converting images to JPEG                                     │
│  • Validating image quality                                      │
│  • Sending to backend API                                        │
│                                                                   │
│  [🦉 Spinning owl animation]                                     │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                       BACKEND PROCESSING                          │
│                                                                   │
│  1. Receive problem image + optional method image                │
│  2. Fetch OpenAI API key from Azure Key Vault                    │
│  3. Prepare AI prompt with instructions                          │
│  4. Send images to OpenAI Vision API                             │
│  5. AI analyzes both images (if method provided)                 │
│  6. AI generates steps following teacher's method                │
│  7. Return structured response with steps                        │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    AI ANALYSIS COMPLETE ✅                        │
│                                                                   │
│  • Problem analyzed                                              │
│  • Steps generated (following teacher's method if provided)      │
│  • Subject and difficulty identified                             │
│  • Steps saved to DataManager                                    │
│  • Images saved locally                                          │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                  STEP GUIDANCE VIEW 🎓                            │
│                                                                   │
│  Step 1: Following your teacher's method...                      │
│  • Question with multiple choice options                         │
│  • Hints available                                               │
│  • Answer verification                                           │
│                                                                   │
│  [Next Step] → Continue through all steps                        │
└─────────────────────────────────────────────────────────────────┘
```

## State Management Flow

```
┌──────────────────────────────────────────────────────────────┐
│                    HomeView State Variables                    │
├──────────────────────────────────────────────────────────────┤
│                                                                │
│  Problem Image Flow:                                          │
│    selectedImage: UIImage?                                    │
│    showImagePicker: Bool                                      │
│    showCamera: Bool                                           │
│    showImageCropper: Bool                                     │
│    tempImageForCropping: UIImage?                             │
│                                                                │
│  Teacher Method Flow:                                         │
│    showTeacherMethodPrompt: Bool       ← Triggers prompt      │
│    teacherMethodImage: UIImage?        ← Stores method image  │
│    showTeacherMethodCamera: Bool       ← Shows camera sheet   │
│    showTeacherMethodImagePicker: Bool  ← Shows picker sheet   │
│    showTeacherMethodCropper: Bool      ← Shows cropper sheet  │
│    tempTeacherMethodImage: UIImage?    ← Temp storage         │
│    isCapturingTeacherMethod: Bool      ← Shows source alert   │
│                                                                │
│  Processing:                                                  │
│    isProcessing: Bool                                         │
│    processingMessage: String                                  │
│                                                                │
│  Navigation:                                                  │
│    navigateToGuidance: Bool                                   │
│    currentProblemId: UUID?                                    │
└──────────────────────────────────────────────────────────────┘
```

## Backend API Flow

```
┌────────────────────────────────────────────────────────────┐
│  iOS App (BackendAPIService)                               │
│                                                            │
│  func analyzeHomework(                                     │
│    imageData: Data?,                                       │
│    problemText: String?,                                   │
│    userGradeLevel: String,                                 │
│    userId: String?,                                        │
│    teacherMethodImageData: Data? ← NEW!                    │
│  ) async throws -> ProblemAnalysis                         │
└─────────────────────┬──────────────────────────────────────┘
                      │
                      │ HTTPS POST
                      │ multipart/form-data
                      ▼
┌────────────────────────────────────────────────────────────┐
│  Backend API (imageAnalysis.js)                            │
│                                                            │
│  POST /api/analyze-homework                                │
│    Fields:                                                 │
│      • image: File (required)                              │
│      • teacherMethodImage: File (optional) ← NEW!          │
│      • problemText: String                                 │
│      • userGradeLevel: String                              │
│      • userId: String                                      │
│      • deviceId: String                                    │
└─────────────────────┬──────────────────────────────────────┘
                      │
                      ▼
┌────────────────────────────────────────────────────────────┐
│  OpenAI Service (openaiService.js)                         │
│                                                            │
│  async analyzeHomework({                                   │
│    imageData,                                              │
│    problemText,                                            │
│    teacherMethodImageData, ← NEW!                          │
│    userGradeLevel,                                         │
│    apiKey,                                                 │
│    userId,                                                 │
│    deviceId                                                │
│  })                                                        │
└─────────────────────┬──────────────────────────────────────┘
                      │
                      │ HTTPS POST
                      │ JSON with base64 images
                      ▼
┌────────────────────────────────────────────────────────────┐
│  OpenAI Vision API                                         │
│                                                            │
│  Model: gpt-4-vision-preview                               │
│  Messages:                                                 │
│    1. System prompt (with teacher method instructions)     │
│    2. User prompt with context                             │
│    3. Problem image (detail: "high")                       │
│    4. Teacher method image (detail: "high") ← NEW!         │
│                                                            │
│  Returns: JSON with steps following teacher's method       │
└────────────────────────────────────────────────────────────┘
```

## Data Storage

```
Local Device Storage (Documents Directory):
┌──────────────────────────────────────────────────────────┐
│                                                          │
│  Problem Images:                                         │
│    {problemId}.jpg                 (e.g., "abc-123.jpg") │
│                                                          │
│  Teacher Method Images:                                  │
│    {problemId}_method.jpg  (e.g., "abc-123_method.jpg")  │
│                                                          │
│  Metadata (in HomeworkProblem):                          │
│    imageFilename: "abc-123.jpg"                          │
│    teacherMethodImageFilename: "abc-123_method.jpg"      │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

## AI Prompt Flow

```
When Teacher Method Image is PROVIDED:
┌─────────────────────────────────────────────────────────────┐
│  System Prompt:                                             │
│    • Standard homework mentor instructions                  │
│    • ⚠️ CRITICAL: Follow teacher's exact method             │
│    • Use same terminology and notation                      │
│    • Reference teacher's approach in explanations           │
│                                                             │
│  User Content (Multi-part):                                 │
│    1. Text: Instructions to analyze both images            │
│    2. Image: Problem image (high detail)                    │
│    3. Text: "Here is the teacher's example..."             │
│    4. Image: Teacher method image (high detail)             │
│                                                             │
│  AI Response:                                               │
│    • Studies both images                                    │
│    • Identifies teacher's specific method                   │
│    • Generates steps mirroring that method                  │
│    • Uses phrases like "As your teacher showed..."          │
└─────────────────────────────────────────────────────────────┘

When Teacher Method Image is NOT PROVIDED:
┌─────────────────────────────────────────────────────────────┐
│  System Prompt:                                             │
│    • Standard homework mentor instructions                  │
│    • Use any appropriate solving method                     │
│                                                             │
│  User Content:                                              │
│    1. Text: Instructions to analyze problem                 │
│    2. Image: Problem image (high detail)                    │
│                                                             │
│  AI Response:                                               │
│    • Standard analysis                                      │
│    • Uses best pedagogical approach for grade level         │
└─────────────────────────────────────────────────────────────┘
```

## Error Handling

```
┌────────────────────────────────────────────────────────────┐
│  Potential Issues & Solutions:                             │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ✗ User cancels teacher method capture                    │
│    → Continue with problem image only                      │
│                                                            │
│  ✗ Teacher method image fails to upload                   │
│    → Graceful degradation, use problem image only          │
│                                                            │
│  ✗ AI cannot interpret teacher's method                   │
│    → Falls back to standard solving approach               │
│    → Warns student in response                             │
│                                                            │
│  ✗ Image quality issues (either image)                    │
│    → Show quality alert with retry option                  │
│    → Allow "Analyze Anyway" option                         │
│                                                            │
│  ✗ Network/backend errors                                 │
│    → Show clear error message                              │
│    → Allow retry                                           │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

## Success Metrics

```
✅ Feature Completeness:
   • User can optionally add teacher method image
   • AI analyzes both images when provided
   • Steps follow teacher's specific approach
   • Seamless integration with existing flow

✅ Code Quality:
   • No linter errors
   • Comprehensive error handling
   • Clear state management
   • Well-documented

✅ User Experience:
   • Beautiful, intuitive UI
   • Clear instructions at each step
   • Optional feature (not forced)
   • Consistent with app theme

✅ Technical Implementation:
   • iOS and backend fully integrated
   • Proper data storage
   • Efficient image handling
   • Scalable architecture
```

---

**Ready for Production Testing** ✨



