.thumb
@draws the stat screen

.set NoAltIconDraw, 1 @ 

.include "mss_defs.s"
.set SkillGetter, IconGraphic+4
.set SkillTester, SkillGetter+4
.set SaviorID, SkillTester+4
.set CelerityID, SaviorID+4
.set SS_SkillsText, CelerityID+4
.set SS_TalkText, SS_SkillsText+4
.set Display_Growths_options, SS_TalkText+4
.set Growth_Getters_Table, Display_Growths_options+4
.set Get_Palette_Index, Growth_Getters_Table+4
.set GetCharge, Get_Palette_Index+4
.set MagClassTable, GetCharge+4
.set GetLeadershipStarCount, MagClassTable+4
.set AccessorySkillGetter, GetLeadershipStarCount+4
.set ItemTable, AccessorySkillGetter+4

page_start

@load the growth getters onto the stack, if needed
.set growth_getters_table_loc, (Growth_Getters_Table - . - 6)
ldr		r0, =growth_getters_table_loc
add		r0,pc
ldr		r0,[r0]
str		r0,[sp,#0xC]
.set growths_options_loc, (Display_Growths_options - . - 6)
ldr		r0, =growths_options_loc
add		r0,pc
ldr		r0,[r0]
mov		r1,#0x10		@set if stat name color should reflect growth
and		r0,r1
mov		r1,r8
ldrb	r1,[r1,#0xB]
mov		r2,#0xC0
tst		r1,r2
beq		IsPlayerUnit
mov		r0,#0
IsPlayerUnit:
str		r0,[sp,#0x14]

draw_textID_at 13, 3, textID=0x4fe, growth_func=2 @str
draw_textID_at 22, 3, textID=0x4ff, growth_func=3 @mag
draw_textID_at 13, 5, textID=0x4EC, growth_func=4 @skl
draw_textID_at 22, 5, textID=0x4ED, growth_func=5 @spd
draw_textID_at 13, 7, textID=0x4ef, growth_func=7 @def
draw_textID_at 22, 7, textID=0x4f0, growth_func=8 @res
draw_textID_at 13, 9, textID=0x4ee, growth_func=6 @luck

b 	NoRescue
.ltorg 
NoRescue:

ldr		r0,=StatScreenStruct
sub		r0,#1
mov		r1,r8
ldrb	r1,[r1,#0xB]
mov		r2,#0xC0
tst		r1,r2
beq		Label2
ldrb	r1,[r0]
mov		r2,#0xFE
and		r1,r2
strb	r1,[r0]			@don't display enemy growths
Label2:
ldrb	r0,[r0]
mov		r1,#1
tst		r0,r1
beq		ShowStats
b		ShowGrowths

ShowStats:
b		ShowStats2


ShowGrowths:
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#4]		@str growth getter
draw_growth_at 18, 3
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#8]		@mag growth getter
draw_growth_at 27, 3
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#12]		@skl growth getter
draw_growth_at 18, 5
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#16]		@spd growth getter
draw_growth_at 27, 5
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#20]		@luk growth getter
draw_growth_at 18, 9
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#24]		@def growth getter
draw_growth_at 18, 7
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#28]		@res growth getter
draw_growth_at 27, 7
ldr		r0,[sp,#0xC]
ldr		r0,[r0]			@hp growth getter (not displaying because there's no room atm)
draw_growth_at 27, 9
draw_textID_at 22, 9, textID=0x4E9, growth_func=1 @hp name
b		NextColumn
.ltorg

ShowStats2:
b		ShowStats3

NextColumn:

draw_textID_at 13, 11, textID=0x4f7 @con
draw_con_bar_with_getter_at 16, 11


draw_textID_at 22, 11, textID=0x4f8 @aid
draw_number_at 26, 11, 0x80189B8, 2 @aid getter
draw_aid_icon_at 27, 11

draw_status_text_at 13, 13

@draw_textID_at 21, 9, textID=0x4f1 @affin

draw_affinity_icon_at 1, 10


draw_icon_at 23, 15, 0xCD
draw_icon_at 23, 17, 0xCE


.set ss_skillloc, (SS_SkillsText - . - 6)
  ldr r0, =ss_skillloc
  add r0, pc
  ldr r0, [r0]
draw_textID_at 13, 16, colour=White @skills
mov r0, r8
mov 	r1,#0x47
ldrb	r0,[r0,r1]
mov r1,#0x10
and r1,r0
cmp r1,#0x10
bne Nexty
draw_charge_at 27, 13, colour=Green @ChargeGetter

Nexty:

b skipliterals
.ltorg

ShowStats3:
draw_str_bar_at 16, 3

draw_skl_bar_at 16, 5
draw_spd_bar_at 25, 5
draw_luck_bar_at 16, 9
draw_def_bar_at 16, 7
draw_res_bar_at 25, 7
draw_textID_at 22, 9, 0x4f6 @move
draw_move_bar_with_getter_at 25, 9
draw_mag_bar_at 25, 3

b		NextColumn
.ltorg

skipliterals:

mov r0, r8
ldr r1, SkillGetter
mov lr, r1
.short 0xf800 @skills now stored in the skills buffer

mov r6, r0
ldrb r0, [r6] 
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 16, 15

ldrb r0, [r6,#1]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 18, 15

ldrb r0, [r6, #2]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 20, 15

ldrb r0, [r6, #3]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 16, 17

ldrb r0, [r6, #4]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 18, 17

ldrb r0, [r6, #5]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 20, 17

SkillEnd:

@now check equipped weapon skill
mov r0, r8
ldrh r0, [r0, #0x1E]
cmp r0, #0
bne CheckForging
b AccessorySkill

CheckForging:
mov r2, #0
mov r1, #0x80
lsl r1, #7
and r1, r0
cmp r1, #0
beq ContinueItemSkill
mov r2, #1

ContinueItemSkill:
mov r1, #0xFF @get the item id
and r0, r1
mov r1, #36 @size of the item table
mul r0, r1
ldr r1, ItemTable
add r0, r1 
mov r1, #35 @last byte in the item table
sub r1, r2 @ Get Either the forged skill or the normal skill
ldrb r0, [r0, r1]
cmp r0, #0
beq AccessorySkill
draw_skill_icon_at 25, 15

AccessorySkill:
mov r0, r8
ldr r3, AccessorySkillGetter
mov lr, r3
.short 0xF800
cmp r0, #0
beq Move
mov r1, #36 @size of the item table
mul r0, r1
ldr r1, ItemTable
add r0, r1 
mov r1, #35 @last byte in the item tables
ldrb r0, [r0, r1]
cmp r0,#0
beq Move
draw_skill_icon_at 25, 17

Move:

@ draw_textID_at 13, 15, textID=0x4f6 @move
@ draw_move_bar_at 16, 15

draw_textID_at 22, 13, textID=0x0028
mov		r0, r8
ldr		r3, GetLeadershipStarCount
sub		r3, #1 @get rid of unnecessary thumb bit
mov		lr, r3
.short 0xF800
push	{r0}
draw_number_at 26, 13
pop 	{r0}
cmp		r0,#0xFF
beq		DontDrawIcon
cmp		r0,#0
beq		DontDrawIcon
draw_icon_at 27, 13, 0xCA @change this to the ID you put the icon in
DontDrawIcon:



@blh DrawBWLNumbers

ldr		r0,=StatScreenStruct
sub		r0,#0x2
ldrb	r0,[r0]
cmp		r0,#0x0
beq		DoNotUpdate
ldr		r0,=BgBitfield
ldrb	r1,[r0]
mov		r2,#0x5
orr		r1,r2
strb	r1,[r0]
ldr		r0,=CopyToBG
mov		r14,r0
ldr		r0,=Const_2003D2C
ldr		r1,=Const_2022D40
mov		r2,#0x12
mov		r3,#0x12
.short	0xF800
ldr		r0,=CopyToBG
mov		r14,r0
ldr		r0,=Const_200472C
ldr		r1,=Const_2023D40
mov		r2,#0x12
mov		r3,#0x12
.short	0xF800
ldr		r0,=StatScreenStruct
sub		r0,#0x2
mov		r1,#0x0
strb	r1,[r0]
b DoNotUpdate
.ltorg

DoNotUpdate:
page_end

.ltorg

Restore_Palette:
@r0=thing to store back, r1=0 if we can skip this
cmp		r1,#0
beq		RestoreDone
cmp		r0,#0
beq		RestoreDone
ldr		r1,Const2_2028E70
ldr		r1,[r1]
strh	r0,[r1,#0x10]
RestoreDone:
bx		r14

.align
Const2_2028E70:
.long 0x02028E70

.include "Get Talkee.asm"

.ltorg
IconGraphic:
@POIN SkillIcons at the end here
@POIN SkillGetter after that
@POIN SkillTester after THAT
@WORD SaviorID lol
