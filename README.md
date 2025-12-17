# Fake News Detection

Fake news detector that use local text classification model on react-native plataform with iOS native components.

<img width="375" height="757" alt="image" src="https://github.com/user-attachments/assets/cbb092f1-19b5-4429-a1e5-0ae984018310" />
<img width="372" height="756" alt="Captura de Tela 2025-12-17 às 05 31 51" src="https://github.com/user-attachments/assets/096d4634-529e-4e2a-85fb-6e40832d23a0" />
<img width="377" height="760" alt="Captura de Tela 2025-12-17 às 05 34 43" src="https://github.com/user-attachments/assets/d950636b-447e-401d-a759-8f102dbcd1ef" />

https://github.com/user-attachments/assets/70f8f82b-eeed-486a-839e-a69e27c21b1e

## How it works

The flow of taking user input from the hybrid platform to the local Swift model consists of:

1.  **Interaction Layer (React Native)**: The user initiates an action via the react-native interface
2.  **Native Bridge**: The app invokes a custom native module, passing data from react-native to the iOS Native layer (Swift)
3.  **Model Processing**: The Swift layer handles the heavy lifting, executing the locally text classification model with coreML
4.  **Data Return**: The processed results are returned asynchronously back to the react-native environment
5.  **Persistence**: The final output is structured and securely stored in the local SQLite database
6.  **UI Update**: The react-native state is updated to reflect the new data

## Tech Stack

- **CreateML** - Training model with kaggle personalized dataset
- **CoreML** - Inference on the model
- **React-Native** - UI plataform
- **SQLite** Local DB for persistence user sessions
- **Objective-C** Bridging swift to react-native environment
- **Swift** Native iOS components

## Requirements

- iOS 17.0+ (Android version coming soon)
- iPhone device
- VS Code and Xcode 16.0+
