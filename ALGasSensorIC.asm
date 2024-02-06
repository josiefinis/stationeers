# Basic atmosphere checker for internal airlock.
# Josefin Wall 2024-02-06
# Collate and classify gas sensor data.
# Output on db { ERR, BAD, OK, OKEQ, HIDP }
define N_SENSORS 3 # 1 in airlock & 2 either side
define ERR -1 # sensor connections != 3
define BAD 0  # any lo O2|hi H2|hi X|hi N2O
define OK 1   # not BAD
define OKEQ 2 # all OK & equal
define HIDP 3 # high delta P
define MAX_DELTA_P 190 # kPa
define MAX_H2 0.005 # 0.5 %
define MAX_X 0.005 # 0.5 %
define MAX_N2O 0.005 # 0.5 %
define MIN_P_O2 16 # kPa
define MAX_rdP 0.1  # relative difference
define MAX_rdT 0.02 # relative difference
define MAX_rdO2 0.1 # relative difference
define MAX_rdN2 0.1 # relative difference
alias ICHousing db
alias atmStatus r14
main: # ================================
s db Setting atmStatus
yield
jal checkDeviceCount
beq atmStatus ERR main
jal checkHIDP
beq atmStatus HIDP main
jal checkOK
beq atmStatus BAD main
jal checkEQ
j main # ===============================

checkDeviceCount: # check device count == 3
move atmStatus ERR
move r0 N_SENSORS
sub r0 r0 1
bdns dr0 ra
brgtz r0 -2
move atmStatus 0
j ra # ________________return 
checkHIDP: # check delta P won't break door
move atmStatus HIDP
move r2 0
move r1 N_SENSORS   
loop0:          # do {
sub r1 r1 1     #     --r1
push ra
jal isHIDP      #     f( r1, r2 )
pop r0
pop ra
bnez r0 ra
bgtz r1 loop0   # } while ( r1 > 0 )
move atmStatus 0 
j ra # __________________________return 
checkOK: # Check all atm OK
move atmStatus BAD
move r1 N_SENSORS
loop1:          # do {
sub r1 r1 1     #     --r1
push ra
jal isNotOK     #     f( r1 )
pop r0
pop ra
bnez r0 ra
bgtz r1 loop1  # } while ( r1 > 0 )
move atmStatus OK 
j ra # __________________________return 
checkEQ: # Check all atm equal
move atmStatus OK
move r2 0
move r1 N_SENSORS   
loop2:          # do {
sub r1 r1 1     #     --r1
push ra
jal isNotEQ     #     f( r1, r2 )
pop r0
pop ra
bnez r0 ra
bgtz r1 loop2 # } while ( r1 > 0 )
move atmStatus OKEQ 
j ra # __________________________return 
isHIDP: # sensor_r1, sensor_r2 )
l r0 dr1 Pressure
l r3 dr2 Pressure
sub r0 r0 r3
abs r0 r0
sgt r0 r0 MAX_DELTA_P 
push r0
j ra # __________________________return r0
isNotOK: # ( sensor_r1 )
push 1
l r0 dr1 RatioVolatiles
bgt r0 MAX_H2 ra
l r0 dr1 RatioPollutant
bgt r0 MAX_X ra
l r0 dr1 RatioNitrousOxide
bgt r0 MAX_N2O ra
l r0 dr1 RatioOxygen
l r2 dr1 Pressure
mul r0 r0 r2
blt r0 MIN_P_O2 ra
pop r0
push 0
j ra # __________________________return 0
isNotEQ: # ( sensor_r1, sensor_r2 )
push 1
l r0 dr1 Pressure
l r3 dr2 Pressure
bna r0 r3 MAX_rdP ra
l r0 dr1 Temperature
l r3 dr2 Temperature
bna r0 r3 MAX_rdT ra
l r0 dr1 RatioOxygen
l r3 dr2 RatioOxygen
bna r0 r3 MAX_rdO2 ra
l r0 dr1 RatioNitrogen
l r3 dr2 RatioNitrogen
bna r0 r3 MAX_rdN2 ra
pop r0
push 0
j ra # __________________________return 0
