@ SkillTester - given ram data in r0 and skill number in r1, returns 1 for true or 0 for false
@ calls skill getter and checks if skill is in the list
@ skill 0 is always true, skill FF is always false.

@TODO: also check inventory for skill items?

.set GetUnitEquippedItem, 0x8016B28
.set ItemTable, SkillGetter+4
.set EquippedAccessoryGetter, ItemTable+4

.thumb

push {r4-r5,lr}
@r0 has unit data
mov r5, r0
cmp r1, #0
beq True
cmp r1, #0xFF
beq False

mov r4, r1 @skill to test
ldr r1, SkillGetter
mov lr, r1
.short 0xf800
@now r0 is the buffer to loop through
Loop:
ldrb r1, [r0]
cmp r1, #0 @list is over, now test if the equipped item has a skill
beq TestEquippedItem
cmp r1, r4
beq True
add r0, #1
b Loop

TestEquippedItem:
ldrh r0, [r5, #0x1E]
mov r1, #0xFF @get the item id
and r0, r1
cmp r0, #0
beq TestAccessory
mov r1, #36 @size of the item table
mul r0, r1
ldr r1, ItemTable
add r0, r1 
mov r1, #35 @last byte in the item table
ldrb r0, [r0, r1]
cmp r0, r4
beq True

TestAccessory:
mov r0,r5
ldr r1, EquippedAccessoryGetter
mov lr,r1
.short 0xF800
cmp r0, #0
beq False
mov r1, #36 @size of the item table
mul r0, r1
ldr r1, ItemTable
add r0, r1 
mov r1, #35 @last byte in the item table
ldrb r0, [r0, r1]
cmp r0, r4
beq True



False:
mov r0, #0
pop {r4-r5, pc}

True:
mov r0, #1
pop {r4-r5, pc}

.ltorg
.align
SkillGetter:
@POIN SkillGetter
