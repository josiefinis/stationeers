# Stationeers
## Airlock

                      ┏━━━━━━━━━━━━━━━━━━━━━━━┓
                 db ──┨ airlock controller IC ┃
                      ┗━┯━━━┯━━━┯━━━┯━━━┯━━━┯━┛
                        │   │   │   │   
                        d0  d1  d2  d3  
                        │   │   │   │   
                        │   │   │   │
                        │   │   │   │
                        │   │   │   db  ↑{ ERR, BAD, OK, OKEQ, HIDP }
                        │   │   │   │        
                        │   │   │   │        
                        │   │   │   │                     ┏━━━━━━━━━━━━━━━━━━━━━━━┓
                        │   │   │   └─────────────────────┨   AL gas sensor IC    ┃
                        │   │   │                         ┗━┯━━━┯━━━┯━━━┯━━━┯━━━┯━┛
                        │   │   │                           │   │   │  
                        │   │   │                           d0  d1  d2  
                        │   │   │                           │   │   │
                        │   │   │       gas sensor 0 ┠──────┘   │   │
                        │   │   │           gas sensor 1 ┠──────┘   │
                        │   │   │               gas sensor AL ┠─────┘
                        │   │   │       
                        │   │   │
                        │   │   │
                        │   │   db  ↓{  }
                        │   │   │
                        │   │   │
                        │   │   │     ┏━━━━━━━━━━━━━━━━━━━━━━━┓
                        │   │   └─────┨ AL door controller IC ┃
                        │   │         ┗━┯━━━┯━━━┯━━━┯━━━┯━━━┯━┛
                        │   │           │   │   │   
                        │   │           d0  d1  d2 
                        │   │           │   │   │
        door 0 ┠────────┴───│───────────┘   │   │
            door 1 ┠────────┴───────────────┘   │
                manual override light ┠─────────┘ 
        
### Airlock Gas Sensors
airlockGasSensors.asm

