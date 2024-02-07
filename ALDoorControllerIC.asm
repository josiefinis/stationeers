# Door controller for internal airlock
# Josefin Wall 2024-02-07
# Open/close doors on command from AL controller.
# Send door open/close requests to AL controller.
define Manual 1220484876
alias comIn r14
define SEND_RQ 0 # Commands from AL Controller
define CL1_CL0 1   #  
define CL1_OP0 2   # 
define OP1_CL0 3   # 
define OP1_OP0 4   # 
define LOCK_DOWN 5 # 
alias comOut r15
define ACKNOWLEDGE -1 # Messages to AL Controller
define RQ_CLOSE0 -4   # 
define RQ_CLOSE1 -5   # 
define RQ_OPEN0 -6    # 
define RQ_OPEN1 -7    # 
define MAN_OVR -8     # 
define INPUT_ERR -2
define NO_INPUT -3
alias door0 d0
alias door1 d1
alias overrideLight d2
reset:
jal setLogic
move comIn CL1_CL0
jal setDoors
main: # ==========================================
lb r0 Manual Open Maximum
l comIn db Setting
beqz r0 else0           # if ( override )
s d0 Mode 0 
s d1 Mode 0
bneal comIn MAN_OVR setManual
j main
else0:                  # else
s d0 Mode 1
s d1 Mode 1
beqal comIn MAN_OVR setLogic
blez comIn else1  # if ( command )
jal setDoors
move comOut ACKNOWLEDGE
j break1
else1:          # else
jal pollDoors
pop r0
beq r0 INPUT_ERR reset
beq r0 NO_INPUT main
move comOut r0
break1:
seq r0 comOut ACKNOWLEDGE
seq r1 comIn SEND_RQ
or r0 r0 r1
beqz r0 main
s db Setting comOut
j main
# ===============================================
setManual: 
s db Setting MAN_OVR
s overrideLight On 1
s d1 Lock 0          
s d0 Lock 0          
j ra
setLogic: 
s db Setting ACKNOWLEDGE
s overrideLight On 0
j ra
setDoors: # f ( comIn: command )
move r0 0
move r1 0
move r2 0
move r3 0
beq comIn LOCK_DOWN lockDown # switch ( command )
beq comIn CL1_CL0 close1close0
beq comIn CL1_OP0 close1open0
beq comIn OP1_CL0 open1close0
beq comIn OP1_OP0 open1open0
j ra # _____________________________________return
lockDown:
move r3 1
move r2 1
j endSwitch # _______________________________break
close1close0:
j endSwitch # _______________________________break
close1open0:
move r1 0
move r0 1
j endSwitch # _______________________________break
open1close0:
move r1 1
move r0 0
j endSwitch # _______________________________break
open1open0:
move r1 1
move r0 1
j endSwitch # _______________________________break
endSwitch: # ___________________________end switch
s d1 Setting r1
s d0 Setting r0
s d1 Open r1
s d0 Open r0
s d1 Lock r3
s d0 Lock r2
j ra # _____________________________________return
pollDoors: # f () = door input
l r3 d1 Open
l r2 d0 Open
l r1 d1 Setting 
l r0 d0 Setting 
sne r5 r1 r3 # input side
seq r4 r0 r2 # input side again
select r10 r5 INPUT_ERR NO_INPUT
select r7 r1 RQ_OPEN1 RQ_CLOSE1
select r6 r0 RQ_OPEN0 RQ_CLOSE0
select r11 r5 r7 r6
seq r8 r5 r4
select r0 r8 r11 r10
push r0
j ra # ____________________________________ return
