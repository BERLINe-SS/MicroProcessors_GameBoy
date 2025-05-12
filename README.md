# GameBoy Advance Emulator on STM32


A retro gaming platform built using ARM assembly language and STM32 microcontroller. This project implements several classic arcade games displayed on a TFT screen, creating a portable gaming experience similar to the original GameBoy.

## 📋 Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Games](#games)
  - [Main Menu](#main-menu)
  - [Snake Game](#snake-game)
  - [Ping Pong](#ping-pong)
  - [Brick Breaker](#brick-breaker)
  - [Tic-Tac-Toe](#tic-tac-toe)
  - [Flappy Bird](#flappy-bird)
- [Hardware Requirements](#hardware-requirements)
- [Software Requirements](#software-requirements)
- [Installation](#installation)
- [Team Members](#team-members)
- [License](#license)

## 🎮 Project Overview

This project is an implementation of a GameBoy-inspired gaming console using the STM32 microcontroller and a TFT display. The games are written in ARM assembly language for optimal performance and low-level hardware control. The system features multiple classic arcade games that can be selected from a main menu interface.

## ✨ Features

- Custom-built game engine for STM32
- TFT display interface with vibrant colors
- Multiple classic arcade games
- Intuitive menu navigation system
- Efficient assembly language implementation

## 🎯 Games

### Main Menu

The central hub for game selection, featuring colorful icons for each available game.

![Main Menu]("(https://i.imgur.com/MSO2JDV.jpeg)")

### Snake Game

Navigate a growing snake to collect food while avoiding collisions with walls and its own tail.

![Snake Game 1](https://i.imgur.com/wkV8HZw.jpg)
![Snake Game 2](https://i.imgur.com/ZqfjXCZ.jpg)

### Ping Pong

The classic table tennis simulation where players control paddles to hit a ball back and forth.

![Ping Pong 1](https://i.imgur.com/V79DFJM.jpg)
![Ping Pong 2](https://i.imgur.com/3UOq1mS.jpg)

### Brick Breaker

Use a paddle to direct a bouncing ball to break all the bricks in a level.

![Brick Breaker 1](https://i.imgur.com/lkn4M92.jpg)
![Brick Breaker 2](https://i.imgur.com/6JwIiQZ.jpg)

### Tic-Tac-Toe

The classic paper-and-pencil game implemented digitally with X's and O's.

![Tic-Tac-Toe](https://i.imgur.com/iiOeIeR.jpg)

### Flappy Bird

Navigate a bird through pipes by tapping to make it flap its wings and gain altitude.

![Flappy Bird](https://i.imgur.com/xZGW4G1.jpg)

## 🔧 Hardware Requirements

- STM32 Microcontroller
- TFT Display
- Input Buttons/Controller
- Breadboard and Jumper Wires
- Power Supply

## 💻 Software Requirements

- ARM Assembly Development Environment
- STM32CubeIDE or equivalent
- Serial Communication Tools

## 📥 Installation

1. Clone the repository:
```bash
git clone https://github.com/BERLINe-SS/MicroProcessors_GameBoy.git
```

2. Open the project in STM32CubeIDE or your preferred ARM development environment.

3. Compile the code and flash it to your STM32 microcontroller.

4. Connect the TFT display and control inputs according to the pin configuration in the code.

5. Power on and enjoy the games!

## 👥 Team Members

Our project was developed by a dedicated team of engineers:

- [Ibrahim Abohola](https://github.com/Ibrahim-Abohola)
- [Ahmed Gamal Seif](https://github.com/ahmedgamalseif)
- [Ahmed Essam](https://github.com/AhmedEssam005)
- [MSH-20](https://github.com/MSH-20)
- [Ibrahim-357](https://github.com/Ibrahim-357)
- [Saiko](https://github.com/saiko-git)
- [BERLINe-SS](https://github.com/BERLINe-SS)
- [Ebraam Ashraf](https://github.com/Ebraam-Ashraf)

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <img src="https://raw.githubusercontent.com/BERLINe-SS/readme-assets/main/GameBoy-Footer.jpg" alt="GameBoy Footer" width="300">
</p>

<p align="center">
  Made with ❤️ by the STM32 GameBoy Team
</p>
