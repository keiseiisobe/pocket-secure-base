# Concept: The Digital Secure Base

## 1. Social Welfare and the Secure Base
Social welfare for neurodivergent people is primarily constructed by social workers who try to support them by respecting their fundamental human rights. These social workers physically communicate with these people. By communicating in such a way, disabled people get a **Secure Base** (as stated by John Bowlby)—a foundation of safety provided by family, home, school, the office, and so on. 

This app is trying to provide a **complementary secure base** while they go outside, extending that safety into the unpredictable public environment.

---

## 2. Visualization: Primary vs. Complementary
This diagram represents the user's landscape of safety. The **Primary Secure Bases** (Home, Social Workers) are fixed points of high-density support, while the **Complementary Secure Base** (the App) follows the user, providing a lighter but constant layer of safety.

```mermaid
graph LR
    %% Styling for Density
    classDef primary fill:#1a237e,stroke:#0d47a1,stroke-width:4px,color:#fff,font-weight:bold;
    classDef complementary fill:#bbdefb,stroke:#2196f3,stroke-width:1px,color:#0d47a1,stroke-dasharray: 8 4;
    classDef user fill:#ffd54f,stroke:#ff8f00,stroke-width:2px;
    classDef public fill:#f5f5f5,stroke:#eeeeee,color:#9e9e9e;

    %% Fixed Primary Anchors
    Home((Home)):::primary
    SocialWorker((Social Worker)):::primary

    %% The Outside World Journey
    subgraph Society [The Outside World]
        Intersection[Busy Intersection]:::public
        Station[Crowded Station]:::public
        Cafe[New Cafe]:::public
        
        subgraph App_Bubble [Complementary Secure Base: APP]
            UserNode(User):::user
        end
    end

    %% Flow of Movement
    Home -- "Leaves Home" --> App_Bubble
    App_Bubble -- "Navigates" --> Intersection
    Intersection -- "Transitions" --> Station
    Station -- "Explores" --> Cafe
    Cafe -- "Safety Check" --> SocialWorker

    %% Legend
    subgraph Legend
        P[Strong Density: Primary Base]:::primary
        C[Weak Density: Complementary Base]:::complementary
    end
```

## 3. The App's Role
- **Primary Base (Anchor)**: Provides long-term stability and human connection.
- **Complementary Base (Bridge)**: Provides real-time "Guardian" support, noise monitoring, and tactical advice, acting as a portable extension of the primary anchor when the user is in transition.