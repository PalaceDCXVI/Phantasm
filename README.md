# Phantasm

My GameDevelopmentWorkshop game from my third year at UOIT.

An asymmetrical cooperative survival game.

One player is a fairly standard first person shooter, called the agent. 
![alt text](https://github.com/PalaceDCXVI/Phantasm/blob/GamesCon/PreviewImages/AgentView.png)

While the other takes on an overseer role, called the hacker, viewing the game through cameras and guiding the agent through dangers and puzzles.

![alt text](https://github.com/PalaceDCXVI/Phantasm/blob/GamesCon/PreviewImages/HackerView.jpg)

I was responsible for the implementation of the following features within this project:

Gameplay:
  - Agent
    - Basic gameplay controls (movement, shooting)
    - Various UI elements (Compass, ammo)
  - Hacker
    - Basic gameplay controls (UI interaction)
    
Visual Effects:
  - Bloom
  - Temporal anti-aliasing
  
Networking: (entirely my reponsibility)
  - C++ networking dll through winsock2
  - Networking all relevant game data between clients
    - Networking done through a server-client model. No central server, but one of the players is the host.
  - Dead reckoning algorithm for network extrapolation.
    
    
