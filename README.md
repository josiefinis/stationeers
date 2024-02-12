# Stationeers
## Airlock

                      ┏━━━━━━━━━━━━━━━━━━━━━━━┓
                 db ──┨ airlock controller IC ┃
                      ┗━┯━━━┯━━━┯━━━┯━━━┯━━━┯━┛
                        │   │   │   │   │   │   
                        d0  d1  d2  d3  d4  d5  
                        │   │   │           │   
    door 0 ┠────────────┘   │   │           │
        door 1 ┠────────────┘   │           │
            override light ┠────┘           │
                                            │
                                            │   db  ↑{ ERR, BAD, OK, OKEQ, HIDP }
                                            │        
                                            │        
                                            │                     ┏━━━━━━━━━━━━━━━━━━━━━━━┓
                                            └─────────────────────┨   AL gas sensor IC    ┃
                                                                  ┗━┯━━━┯━━━┯━━━┯━━━┯━━━┯━┛
                                                                    │   │   │  
                                                                    d0  d1  d2  
                                                                    │   │   │
                                                gas sensor 0 ┠──────┘   │   │
                                                    gas sensor 1 ┠──────┘   │
                                                        gas sensor AL ┠─────┘
                                                
                                



        
### Airlock Gas Sensors
airlockGasSensors.asm

