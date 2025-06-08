---
title: 'Train Departure Board'
description: An rgb dotmatrix display to find my quickest public transport to the city.
publishDate: 'June 08 2025'
repo: https://github.com/andrewmunro/dotmatrix
blog: /blog/train-sign
seo:
    image:
        src: '/train-sign/train-sign.webp'
        alt: Project preview
---

![Project preview](/train-sign/train-sign.webp)

I built a departure board to find my quickest public transport to the city. This was a fun side project to learn about dotmatrix displays and microcontrollers.
The panels are connected to a single ESP32 microcontroller via a custom PCB which drives everything. 

The microcontroller connects over wifi to a local server which streams bitmap data to the displays, turning them into a full colour dot matrix monitor.

## Features

- A 2 panel dotmatrix display to show the next bus, train times
- Shows the next bus and train times in real time (including capacity)
- Shows the current time and weather
- Shows the latest arrivals at Leeds Bradford Airport

## Tech

![Architecture](/train-sign/architecture.png)

### Frontend

- PIXI.js to render the dotmatrix display to a headless canvas.
- Allows for easy UI development and testing via a web browser.

### Backend

- Simple Node.js server to poll data from transport APIs
- Streams transport and weather data to the frontend via websockets
- Streams compressed bitmap data to the dotmatrix display via websockets
- Dumb ESP32 websocket clinet to recieve bitmap data and display it

### Hardware

- [2x 16x32 HUB75 RGB dotmatrix displays](https://www.aliexpress.com/item/1005006041886502.html)
- [ESP32 microcontroller](https://www.aliexpress.com/item/1005006456519790.html) - ensure compatibility with your PCB
- [PCB - ESP32 i2s Matrix Shield](https://github.com/witnessmenow/ESP32-i2s-Matrix-Shield)
- [5V, 8A power supply](https://www.aliexpress.com/item/1005007087317638.html)
- 3D printed case

## Outcome

Works well day to day but has a few issues:
- The 3D printed case reduces wifi signal significantly to the ESP32, so I had to move it closer to my router
- Due to the architecture, I have to run a headless browser [on my homelab](/projects/homelab) to display the UI, which is a bit of a hack
	- I still stand that streaming bitmap data works better than driving from the ESP32 to give more flexibility...