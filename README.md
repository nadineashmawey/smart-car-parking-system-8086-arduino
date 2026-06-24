# Smart Car Parking System 🚗

A Smart Car Parking System developed for the Computer Organization course using **8086 Assembly Language (EMU8086)** and **Arduino Uno**.

The project demonstrates how low-level software can interact with real-world hardware by combining assembly-based I/O control with Arduino-powered sensors and actuators. The system manages vehicle entry and exit, monitors parking slot availability, controls parking gates, and displays parking status in real time.

---

## Project Overview

The system consists of two integrated parts:

### 1. Software Layer (EMU8086)

The assembly program:

- Handles user interaction through a menu-driven interface
- Processes vehicle entry and exit operations
- Reads and updates virtual I/O ports
- Tracks parking slot occupancy
- Controls gate operations through port signals
- Displays parking status information

### 2. Hardware Layer (Arduino)

The Arduino acts as an interface between the assembly program and physical hardware devices.

It controls:

- IR sensors
- Servo motors
- LCD display
- LED indicators
- Buzzer alerts

---

## Features

✅ Vehicle Entry Detection

✅ Vehicle Exit Detection

✅ Automatic Gate Control

✅ Real-Time Parking Slot Monitoring

✅ LCD Display for Available Spaces

✅ LED Indicators for Slot Status

✅ Assembly-Based Port Communication

✅ Arduino Hardware Integration

---

## System Workflow

### Vehicle Entry

1. User selects **Entry** from the assembly menu.
2. Entrance gate opens.
3. Vehicle enters the parking area.
4. User chooses a parking slot.
5. The system checks slot availability using IR sensors.
6. If available:
   - Slot is marked occupied.
   - LED status is updated.
7. Gate closes automatically.

### Vehicle Exit

1. User selects **Leave** from the menu.
2. Exit gate opens.
3. User chooses the occupied slot.
4. Slot is marked as free.
5. LED indicators are updated.
6. Available parking count is refreshed.
7. Exit gate closes automatically.

---

## Hardware Components

| Component | Purpose |
|------------|------------|
| Arduino Uno | Main hardware controller |
| IR Sensors | Vehicle and slot detection |
| Servo Motors | Entrance and exit gates |
| LCD Display | Parking information display |
| LEDs | Slot availability indication |
| Buzzer | Audio notification |
| HC-05 Bluetooth Module | Wireless communication |
| Voltage Regulator | Power management |
| Resistors | Circuit protection |

---

## Arduino Pin Configuration

| Device | Pin |
|----------|----------|
| Slot IR Sensors | 2, 3, 4, 5 |
| LEDs | A0, A1, A2, A3 |
| Entrance IR Sensor | 7 |
| Exit IR Sensor | 9 |
| Entrance Servo | 6 |
| Exit Servo | 8 |
| LCD Display | A4, A5 |
| Buzzer | 10 |

---

## Technologies Used

- 8086 Assembly Language
- EMU8086 Emulator
- Arduino C/C++
- Arduino Uno
- Embedded Systems
- Computer Organization Concepts

---

## Repository Structure

```text
Smart-Car-Parking-System/
│
├── Arduino_Code/
├── Assembly_Code/
├── Demo/
├── Presentation/
├── CO Documentation.docx
└── README.md
```

---

## Learning Outcomes

Through this project, I gained practical experience in:

- Assembly language programming
- 8086 architecture
- I/O port communication
- Embedded systems development
- Hardware-software integration
- Sensor interfacing
- Servo motor control
- System design and debugging

---


## Authors

**Nadine Ashmawey**
**Zina Shady**
**Jana Farouk**
**Raghad Kamal**
**Habiba Habib**

Computer Science Student  
Misr International University (MIU)
