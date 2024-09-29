
# PickUpWatch

This project aims to enhance school security by using artificial intelligence (AI) for facial recognition and a web platform for teachers to monitor students being picked up by authorized guardians. The system uses Python for the AI algorithm and Flutter for the web interface.

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Installation and Setup](#installation-and-setup)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [Future Improvements](#future-improvements)
- [License](#license)

## Project Overview

The main goal of this project is to automate the process of identifying authorized guardians during school pickups using facial recognition technology. This project consists of:
- An AI-based facial recognition system that captures images of guardians and compares them to a database of authorized individuals.
- A web interface that allows teachers to remotely view the list of students whose guardians have been identified, ensuring a smoother and safer pickup process.

## Features
- **Facial Recognition**: Automatically identifies authorized guardians using a webcam and facial recognition algorithm.
- **Database Logging**: Updates a database with information about which guardians have been recognized.
- **Teacher Web Interface**: Displays real-time data on students ready for pickup, with details of the identified guardian.
- **Security Alerts**: Detects unauthorized individuals and notifies school staff if necessary.
- **Remote Access**: Teachers can monitor and verify pickup authorizations without leaving their classrooms.

## Technology Stack

### Backend (AI and Database)
- **Python**: Used for the AI algorithm.
- **OpenCV**: Library for real-time computer vision and image processing.
- **Face Recognition**: Python library for facial recognition.
- **Supabase (online database service)**: Database for storing guardian and student information.

### Frontend (Web Interface)
- **Flutter**: Used to build the web interface for the teachers.
- **Dart**: Programming language used with Flutter.

## Installation and Setup

To set up and run this project locally, follow these steps:

### Backend Setup (Python and AI Algorithm)
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/school-security-system.git
   cd school-security-system
   ```

2. Set up a virtual environment (optional but recommended):
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Configure your `.env` file (this file should not be shared, it contains sensitive information):
   ```bash
   DB_TOKEN=your_database_token
   DB_URL=your_database_url
   ```

5. Run the AI facial recognition algorithm:
   ```bash
   python main.py
   ```

### Frontend Setup (Flutter Web)
1. Ensure you have Flutter installed. If not, follow the installation guide on [Flutter's official website](https://flutter.dev/docs/get-started/install).

2. Navigate to the `web/ia_web` directory:
   ```bash
   cd web/ia_web
   ```

3. Run the web interface locally:
   ```bash
   flutter run
   ```

## Usage

- The Python script captures images through a webcam and runs the facial recognition algorithm, checking against the database of authorized individuals.
- The web interface allows teachers to view the list of students ready for pickup and see details about which guardian has arrived.
- If an unauthorized individual is detected, the system will log an alert in the database for further review.

## Project Structure

```plaintext
.
├── Rec Facial y BD             # AI and database logic
│   ├── imageAugmentation.py    # Augmentation scripts for training data
│   ├── main.py                 # Main script to run facial recognition
│   ├── simple_facerec.py       # Face recognition utility functions
│   └── requirements.txt        # Python dependencies
├── Web                         # Web interface built with Flutter
│   └── ia_web                  # Contains all Flutter project files
├── README.md                   # Project documentation
├── TDR final.pdf               # Full project report (in PDF)
└── .env                        # Environment variables (do not upload)
```

## Contributing

If you'd like to contribute, please follow these steps:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.

## Future Improvements

- **Expand Security Features**: Implement more detailed logging and alert systems for enhanced security.
- **Mobile App**: Build a mobile app version for teachers to monitor pickups on-the-go.
- **Multi-language Support**: Add support for multiple languages in the web interface.

## License

This project is licensed under the MIT License.
