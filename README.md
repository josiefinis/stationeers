# Stationeers
## Airlock
### Network connections
´´´
                      ┏━━━━━━━━━━━━━━━━━━━━━━━┓
                 db ──┨ airlock controller IC ┃
                      ┗━┯━━━┯━━━┯━━━┯━━━┯━━━┯━┛
                        │   │   │   │   │   │   
                        d0  d1  d2  d3  d4  d5  
                        │   │   │   │   │   │   
    door 0 ┠────────────┘   │   │   │   │   │
        door 1 ┠────────────┘   │   │   │   │
            vent 0 ┠────────────┘   │   │   │
                vent 1 ┠────────────┘   │   │
                    override light ┠────┘   │
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
                                                
                                
´´´
        
### Operation

#### Manual override
* Manual override is set by setting any of the manual override levers.
* It is indicated by a flashing light.

Automatic operation depends on the atmosphere either side of the airlock, as determined by the Airlock gas sensor IC.
There are four possible atmospheric conditions: BAD, OK, OKEQ and HIDP.

#### Atmospheres OK and Equalised ( OKEQ )
´´´
                    ┃           ┃                       ┃           ┃
                    ┃           ┃                       ┃           ┃   
                    ┣━━━━━━━━━━━┫                       ┣━━━━━━━━━━━┫   
                    │           │                                    
                    │           │                                    
              ^_^   │           │                           = ^_^
                    │           │                                    
                    │           │                                    
           press -> ┣━▤▤━━━━━▤▤━┫                       ┣━▤▤━━━━━▤▤━┫
                    ┃           ┃                       ┃           ┃   
                    ┃           ┃                       ┃           ┃
´´´
* OKEQ is active when the atmospheres on each side of the airlock have equal pressure and temperature, are breathable, and have acceptably low levels of volatiles, pollutant and nitrous oxide. 
* It is indicated by a green status light.
* Both doors open and close together.

#### Atmospheres are OK but not equalised ( OK )
´´´
                    ┃  P0 < P1  ┃               ┃           ┃               ┃           ┃               ┃           ┃               ┃           ┃
                    ┃           ┃               ┃           ┃               ┃           ┃               ┃           ┃               ┃           ┃
                    ┣━━━━━━━━━━━┫               ┣━━━━━━━━━━━┫               ┣━━━━━━━━━━━┫               ┣━━━━━━━━━━━┫               ┣━━━━━━━━━━━┫
                    │                           │           │                  press -> │               │           │               │            
                    │                           │           │                           │               │           │               │            
              ^_^   │                     ^_^   │           │                    ^_^    │               │    ^_^    │               │               ^_^
                    │                           │           │                           │               │           │               │            
                    │                           │        ↓↓ │                           │               │        ↑↑ │               │            
           press -> ┣━▤▤━━━━━▤▤━┫               ┣━▤▤━━━━━▤▤━┫               ┣━▤▤━━━━━▤▤━┫               ┣━▤▤━━━━━▤▤━┫               ┣━▤▤━━━━━▤▤━┫
                    ░           ░               ░           ░->>            ░           ░               ░           ░<<-            ░           ░
                    ┃           ┃               ┃           ┃               ┃           ┃               ┃           ┃               ┃           ┃
´´´
* OK is active when the atmospheres on each side of the airlock are breathable and have acceptably low levels of volatiles, pollutant and nitrous oxide, but differ in pressure or temperature.
* It is indicated by a green status light, or a yellow status light when the airlock is cycling.
* When a door control button is pressed, the pressure in the airlock will be equalised with the atmosphere facing that door.
* To lower pressure in the airlock, gas is vented to the opposite side to the controlled door.
* To raise pressure in the airlock, gas is vented from the same side as the controlled door.
* The door will open automatically when the the pressure is equalised.
* If either door control is pressed mid-cycle the door will open immediately ( with no safety checks ).

#### Unbreathable or dangerous ( BAD )
´´´
                    ┃  P0 < P1  ┃               ┃           ┃               ┃           ┃               ┃           ┃
                    ┃           ┃               ┃           ┃               ┃           ┃               ┃           ┃
                    ┣━━━━━━━━━━━┫               ┣━━━━━━━━━━━┫               ┣━━━━━━━━━━━┫               ┣━━━━━━━━━━━┫
                    │                           │  P -> 0   │               │  P -> P0  │                  press -> │
                    │                           │           │               │           │                           │
             (^_^)  │                    (^_^)  │           │         (^_^) │           │                   (^_^)   │
                    │                           │           │               │           │                           │
                    │                           │        ↓↓ │               │ ↑↑        │                           │
           press -> ┣━▤▤━━━━━▤▤━┫               ┣━▤▤━━━━━▤▤━┫               ┣━▤▤━━━━━▤▤━┫               ┣━▤▤━━━━━▤▤━┫
                    ░           ░               ░           ░->>         ->>░           ░               ░           ░
                    ┃           ┃               ┃           ┃               ┃           ┃               ┃           ┃



                    ┃           ┃               ┃           ┃               ┃           ┃
                    ┃           ┃               ┃           ┃               ┃           ┃
                    ┣━━━━━━━━━━━┫               ┣━━━━━━━━━━━┫               ┣━━━━━━━━━━━┫
                    │  P -> 0   │               │  P -> P1  │               │            
                    │           │               │           │               │            
                    │   (^_^)   │               │   (^_^)   │               │               (^_^)    
                    │           │               │           │               │            
                    │ ↓↓        │               │        ↑↑ │               │            
                    ┣━▤▤━━━━━▤▤━┫               ┣━▤▤━━━━━▤▤━┫               ┣━▤▤━━━━━▤▤━┫
                 <<-░           ░               ░           ░<<-            ░           ░
                    ┃           ┃               ┃           ┃               ┃           ┃
´´´
* BAD is active when any of the three gas sensors detects insufficient oxygen ( < 16 kPa partial pressure ), or excessive levels of volatiles, pollutant or nitrous oxide. 
* It is indicated by an orange status light, or a red status light when the airlock is cycling.
* The airlock functions the same as for OK, but the airlock will be purged before equalising.
* The airlock is purged by venting all atmosphere to the opposite side to the controlled door until a vacuum is reached.
* The airlock will then proceed to equalise as for OK.
* If either door control is pressed mid-purge the airlock will skip ahead and proceed to equalise the airlock.

#### High differential pressure ( HIDP )
´´´
                    ┃ P0 << P1  ┃                   ┃           ┃               
                    ┃           ┃                   ┃           ┃               
                    ┣━━━━━━━━━━━┫                   ┣━━━━━━━━━━━┫               
                    │  P ->     │                   │  P ->     │               
                    │ (P1-P0)/2 │                   │ (P1-P0)/2 │               
                    │           │        or         │           │               
                    │           │                   │           │               
                    │        ↓↓ │                   │        ↑↑ │               
                    ┣━▤▤━━━━━▤▤━┫                   ┣━▤▤━━━━━▤▤━┫               
                    ░           ░->>                ░           ░<<-            
                    ┃           ┃                   ┃           ┃               
´´´
* HIDP is active when the differential pressure between atmosphere 0 and 1 is close to exceeding what a single door can withstand.
* It is indicated by a blue status light.
* The threshold limit is defined by HIGH_DELTA_P in ALGasSensorIC.asm.
* The airlock will close and lock both doors until the pressure differential is reduced or manual override is set.
* It will protect itself by maintaining pressure within the airlock halfway between the two pressures either side so that the total pressure differential is divided equally over both doors.
* Separation of the two atmospheres is (almost) maintained by only venting to and from one side of the airlock.
* It will always use the vent facing the higher pressure side as it is impossible to vent from the low side if it is a vacuum. 
* If the airlock contained atmosphere from the now low pressure side it may be vented to the opposite side ( hence 'almost' ).

#### Extreme differential pressure ( HIDP and ΔP > max ΔP )
´´´
                    ┃ P0 << P   ┃               
                    ┃           ┃               
                    ┣━━━━━━━━━━━┫               
                    │  P ->     │               
                    │ (P1-P0)/2 │               
                    │           │               
                    │           │               
                    │ ↓↓     ↑↑ │               
                    ┣━▤▤━━━━━▤▤━┫               
                 <<-░           ░<<-            
                    ┃           ┃               
´´´
* This occurs when the differential pressure is close to exceeding what two doors can withstand together.
* The limit is defined by MAXDP in ALControllerIC.asm.
* It is indicated by a blue status light.
* The airlock will protect itself by venting gas from one atmosphere to the other through the airlock.
* This can contaminate the lower pressure atmosphere.

                    
### Airlock Gas Sensors
airlockGasSensors.asm

