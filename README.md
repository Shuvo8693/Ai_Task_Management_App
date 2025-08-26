# ai_task_management_app

# TaskFlow AI - Intelligent Task Management App

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![GetX](https://img.shields.io/badge/State%20Management-GetX-green.svg)
![Sqflite](https://img.shields.io/badge/Database-Sqflite-orange.svg)

A modern Flutter-based task management application with AI-powered features for enhanced productivity. Built with clean architecture and offline-first approach.

## 🎯 Features

- **🔐 Authentication** - Secure email/password login with token-based authentication
- **📋 Task Management** - Create, edit, delete tasks with priorities and due dates
- **📁 Project Organization** - Group tasks into customizable projects

- **⚡ Smart Rescheduling** - AI-powered time suggestions for overdue tasks
- **📱 Offline Support** - Full functionality without internet connection
- **🔄 Sync Capability** - Mock API integration with loading states and error handling

## 📸 Screenshots

<div align="center">
  <img src="https://github.com/user-attachments/assets/ef43d68e-78d3-4144-b5a8-ea1c893af6ab" width="200" alt="Login Screen">
  <img src="https://github.com/user-attachments/assets/56ba68a5-fa8b-4ec3-bc03-d3c501745762" width="200" alt="Login Screen">
  <img src="https://github.com/user-attachments/assets/f52ab4be-a77b-44fd-8602-c3586ebc7368" width="200" alt="Login Screen">
  <img src="https://github.com/user-attachments/assets/3905a710-51f1-4ce3-aa95-11a7a6752f8f" width="200" alt="Login Screen">
  <img src="https://github.com/user-attachments/assets/47f39948-a18b-4312-8de0-9bf9028b8314" width="200" alt="Login Screen">
  <img src="https://github.com/user-attachments/assets/fc133e7c-a06c-4efd-bd32-74e84f873252" width="200" alt="Login Screen">
  <img src="https://github.com/user-attachments/assets/946ac8e4-a82d-48fd-aa06-a337ecb35f38" width="200" alt="Login Screen">
  <img src="https://github.com/user-attachments/assets/9e328e63-6c1e-4eb8-9c28-6287f714210e" width="200" alt="Login Screen">
  <img src="https://github.com/user-attachments/assets/6cadcf76-7497-4838-baca-f8d5078170d1" width="200" alt="Login Screen">
</div>

## 🏗️ Architecture

### Tech Stack
- **Flutter 3.x** with Null Safety
- **GetX** - State management, dependency injection, and navigation
- **Sqflite** - Local database for offline persistence
- **Shared Preferences** - Secure storage for authentication tokens
- **Google Gemini AI** - Intelligent task generation and rescheduling

### Project Structure
lib/
├── core/ # Constants, utilities, values
│ ├── constants/ # App constants
│ ├── utils/ # Helper functions
│ └── values/ # String values
├── data/ # Data layer
│ ├── models/ # Data models (Task, Project)
│ ├── repositories/ # Repository implementations
│ └── datasources/ # Local and remote data sources
├── domain/ # Business logic layer
│ ├── entities/ # Business entities
│ └── repositories/ # Repository interfaces
└── presentation/ # UI layer
├── auth/ # Authentication screens
├── dashboard/ # Main dashboard
├── tasks/ # Task management
├── projects/ # Project management
├── ai_assistant/ # AI features
└── widgets/ # Reusable components


## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or later
- Dart 3.0.0 or later
- Google Gemini API key (optional for AI features)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Shuvo8693/Ai_Task_Management_App.git
   
2. flutter pub get
### Change the environment template
cp .env_example .env
3. flutter run

## 🤖 AI Integration
### Prompt Examples
The AI assistant understands natural language prompts like:

"Plan my week with 3 work tasks and 2 wellness tasks"

"Create a shopping list for healthy meals"

"Tasks for completing my mobile app project"

"Daily routine tasks for productivity"

### Response Format
The AI is configured to return:

Clean bulleted list of tasks

No additional explanations or text

Maximum 5 tasks per request

### Fallback Strategies
No API Key - Uses intelligent mock data based on prompt keywords

Network Issues - Falls back to local mock responses seamlessly

API Errors - Graceful error handling with user feedback

Rate Limiting - Built-in awareness of API limitations



