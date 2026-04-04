# Concept: The Digital Secure Base

## 1. Social Welfare and the Secure Base
Social welfare for neurodivergent people is primarily constructed by social workers who try to support them by respecting their fundamental human rights. These social workers physically communicate with these people. By communicating in such a way, disabled people get a **Secure Base** (as stated by John Bowlby)—a foundation of safety provided by family, home, school, the office, and so on. 

This app is trying to provide a **complementary secure base** while they go outside, extending that safety into the unpredictable public environment.

---

## 2. Visualization: Primary vs. Complementary
This diagram represents the user's landscape of safety. The **Primary Secure Bases** (Home, Social Workers) are fixed points of high-density support, while the **Complementary Secure Base** (the App) follows the user, providing a lighter but constant layer of safety.

```mermaid
graph TD
    %% Styling for Density
    classDef primary fill:#1a237e,stroke:#0d47a1,stroke-width:4px,color:#fff,font-weight:bold;
    classDef complementary fill:#bbdefb,stroke:#2196f3,stroke-width:1px,color:#0d47a1,stroke-dasharray: 8 4;
    classDef user fill:#ffd54f,stroke:#ff8f00,stroke-width:2px;
    classDef public fill:#f5f5f5,stroke:#eeeeee,color:#9e9e9e;

    %% Map Layout
    subgraph City_Map [The Outside World / Society]
        direction LR
        
        %% Anchors
        Home((Home)):::primary
        Office((Office)):::primary
        SW((Social Worker)):::primary
        
        %% The User's Journey
        subgraph Complementary_Base [Complementary Secure Base: APP]
            direction TB
            UserNode(User):::user
            Note["Guardian AI Active"]
        end
        
        %% Landmarks (The Outside)
        Unknown1[Busy Intersection]:::public
        Unknown2[Crowded Station]:::public
        Unknown3[New Cafe]:::public
    end

    %% Flow of Movement
    Home -- "Goes Outside" --> Complementary_Base
    Complementary_Base -- "Navigates" --> Unknown1
    Complementary_Base -- "Transitions" --> Unknown2
    Complementary_Base -- "Explores" --> Unknown3
    Unknown3 -- "Returns to Primary" --> Office

    %% Legend
    subgraph Legend
        L1((Strong Density)):::primary -- "Primary Base (Fixed)"
        L2((Weak Density)):::complementary -- "Complementary Base (Mobile)"
    end
```

## 3. The App's Role
- **Primary Base (Anchor)**: Provides long-term stability and human connection.
- **Complementary Base (Bridge)**: Provides real-time "Guardian" support, noise monitoring, and tactical advice, acting as a portable extension of the primary anchor when the user is in transition.