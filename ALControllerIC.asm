# Internal airlock controller
# Josefin Wall 2024-02-15
define MAXDP 360 # kPa 
define EQTOL 0.01 # 1%
define Sensor -1252983604
define Manual 1220484876
define StatusLight 1944485013
define PressureGauge 576516101
define SR0 HASH("Sensor 0")
define SR1 HASH("Sensor 1")
define SRL HASH("Airlock Sensor")
alias overrideLight d4
alias sensorIC d5                  
alias eqSide r11
alias isBAD r12
alias isOKEQ r13
alias isHIDP r14
alias state r15 # {ready, start, purge, eqlize, end}
s d2 On 0
s d3 On 0
main: #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
yield
jal checkAtmosphere
lb r0 Manual Open Maximum
s overrideLight On r0
seqz r0 r0
s d0 Mode r0
s d1 Mode r0
bnez r0 main
lbn r0 Sensor SR0 Pressure Average # P0
lbn r1 Sensor SR1 Pressure Average # P1
lbn r2 Sensor SRL Pressure Average # PL
move r7 0
move r10 0
loop0:                 # for ( i = 0, 1 ) {
seqz r10 r10                  # i
l r3 dr10 Setting            # si
l r4 dr10 Open               # oi
or r7 r7 r4
bnezal r3 setCycleStart
jal setDoors
bnez r10 loop0                          # }
mod state state 5
sub r7 state r7
blez r7 main
j pumpAirlock #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
checkAtmosphere: #_________________void f ( void ) {
l r0 sensorIC Setting # in { BAD, OK, OKEQ, HIDP }
seq isBAD r0 0      # BAD
seq isOKEQ r0 2     # OKEQ
seq isHIDP r0 3     # HIDP
select r0 isBAD 3 2 # orange/green
select r1 isBAD 4 5 # red/yellow
select r0 state r1 r0
select r0 isHIDP 0 r0 # /blue
sb StatusLight Color r0
select state isHIDP 3 state 
j ra #______________________________________return }
setCycleStart: #_______________f ( P0, P1, PL, i ) {
bnez isOKEQ ra                   # 0   1   2   10
bgt state 3 ra
beq state 1 ra
brna rr10 r2 EQTOL 2
beq r10 eqSide ra
add state state 1       
select eqSide state r10 eqSide
j ra #_______________________________state, eqSide }
setDoors: #___________________void f ( si, oi, i ) {
xor r8 r3 r4
select r4 state 0 r3                 # 3   4   10 
select r4 isHIDP 0 r4
brlt state 4 2
seq r4 r10 eqSide
s dr10 Lock isHIDP
s dr10 Setting r4
s dr10 Open r4
beqz isOKEQ ra
xor r10 r10 r8
bnez r8 setDoors
j ra #______________________________________return }
pumpAirlock: #_______________void f ( P0, P1, PL ) {
brne state 1 2 #                      0   1   2
select state isBAD 2 3
max r4 r0 r1 
div r4 r2 r4            
sb PressureGauge Setting r4 
move r10 0
loop1: #                      for ( i = 0, 1 ) {
bnezal isHIDP lockDown          #  10
beqzal isHIDP cycleAirlock
add r7 r10 2
s dr7 Mode r4
s dr7 On r5
s dr7 PressureExternal r6
seqz r10 r10
bnez r10 loop1 #                                } 
sap r7 r2 r6 EQTOL
add state state r7
j main #___________________________________________}
cycleAirlock: #_________________f( P0, P1, PL, i ) {
xor r4 r10 eqSide               #  0   1   2   10
select r6 eqSide r1 r0
sne r7 state 2
select r6 r7 r6 0
sgt r5 r6 r2
xor r5 r5 r4
sne r7 state 4
and r5 r5 r7                    #   4    5    6
j ra #_____________________return  Mode, On, P ext }
lockDown: #_____________________f( P0, P1, PL, i ) {
add r6 r0 r1                    #  0   1   2   10
div r6 r6 2     # mean P
sgt r4 r1 r0
xor r4 r4 r10    # ( P1 > P0 )^idx
seqz r5 r4
sgt r8 r2 r6    # PL > mean P
sub r7 r1 r0    
div r7 r7 MAXDP # ( P1 - P0 ) / MAXDP
abs r9 r7
sgt r9 r9 1
select r4 r9 r4 r8 # (>MAXDP){P1>P0^idx, PL>meanP}  
sub r8 r10 0.5
mul r8 r8 4
mul r7 r7 r8
add r6 r6 r7 # mean P + 4(idx - 0.5)(P1 - P0)/MAXDP
or r5 r5 r9     # !( P1 > P0 )^idx | DP > MAXDP
j ra #___________________________return r4, r5, r6 }
