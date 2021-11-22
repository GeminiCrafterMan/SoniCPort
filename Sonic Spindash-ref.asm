; ---------------------------------------------------------------------------
; Subroutine to check for starting to charge a spindash
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1AC3E:
Sonic_CheckSpindash:
		tst.b	obSpindash(a0)
		bne.w	Sonic_UpdateSpindash
		cmpi.b	#id_Duck,obAnim(a0)
		bne.w	@ret
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		beq.w	@ret
		move.b	#id_Spindash,obAnim(a0)
		addq.l	#4,sp
		move.b	#1,obSpindash(a0)
		move.w	#$80,obSpindashCounter(a0)

	@done:
		bsr.w	Sonic_LevelBound
		jsr	Sonic_AnglePos

	@ret:
		rts
; End of subroutine Sonic_CheckSpindash


; ---------------------------------------------------------------------------
; Subrouting to update an already-charging spindash
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1AC8E:
Sonic_UpdateSpindash:
		move.b	#id_Spindash,obAnim(a0)
		move.b	(v_jpadhold2).w,d0
		btst	#bitDn,d0
		bne.w	Sonic_ChargingSpindash
; Stopped here
		; unleash the charged spindash and start rolling quickly:
		move.b	#$E,obHeight(a0)
		move.b	#7,obWidth(a0)
		move.b	#id_Roll,obAnim(a0)
		addq.w	#5,y_pos(a0)	; add the difference between Sonic's rolling and standing heights
		move.b	#0,obSpindash(a0)
		moveq	#0,d0
		move.b	obSpindashCounter(a0),d0
		add.w	d0,d0
		move.w	SpindashSpeeds(pc,d0.w),obInertia(a0)

		move.b	obInertia(a0),d0
		subi.b	#$8,d0
		add.b	d0,d0
		andi.b	#$1F,d0
		neg.b	d0
		addi.b	#$20,d0
		move.b	d0,(v_cameralag).w
		btst	#0,status(a0)
		beq.s	@done2
		neg.w	obInertia(a0)
	@done2:
		bset	#2,status(a0)
; shit
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		muls.w	obInertia(a0),d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	obInertia(a0),d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)

		bra.w	Sonic_Spindash_ResetScr
; ===========================================================================
; word_1AD0C:
SpindashSpeeds:
		dc.w  $800	; 0
		dc.w  $880	; 1
		dc.w  $900	; 2
		dc.w  $980	; 3
		dc.w  $A00	; 4
		dc.w  $A80	; 5
		dc.w  $B00	; 6
		dc.w  $B80	; 7
		dc.w  $C00	; 8
; ===========================================================================
; loc_1AD30:
Sonic_ChargingSpindash:			; If still charging the dash...
		tst.w	obSpindashCounter(a0)
		beq.s	@done

		move.b	(v_jpadhold2).w,d0	; Mercury's "don't rev the spindash down..."
		andi.b	#btnABC,d0 ; "...but only if you're holding the button."
		bne.s	@done
	
		move.w	obSpindashCounter(a0),d0
		lsr.w	#5,d0
		sub.w	d0,obSpindashCounter(a0)

		cmpi.w	#$1F,obSpindashCounter(a0)
		bne.s	@skip
		move.w	#0,obSpindashCounter(a0)
		move.b	#0,obSpindash(a0)
		bra.s	@done
	
	@skip:
		bcc.s	@done
		move.w	#0,obSpindashCounter(a0)
	@done:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		beq.w	Sonic_Spindash_ResetScr
		move.w	#(id_Spindash<<8),obAnim(a0)
		addi.w	#$200,obSpindashCounter(a0)
		cmpi.w	#$800,obSpindashCounter(a0)
		blo.s	Sonic_Spindash_ResetScr
		move.w	#$800,obSpindashCounter(a0)

; loc_1AD78:
Sonic_Spindash_ResetScr:
		addq.l	#4,sp			; increase stack ptr
		cmpi.w	#$60,(v_lookshift).w
		beq.s	loc_1AD8C
		bcc.s	loc_1AD88
		addq.w	#4,(v_lookshift).w
 
loc_1AD88:
		subq.w	#2,(v_lookshift).w
 
loc_1AD8C:
		bsr.w	Sonic_LevelBound
		jsr	Sonic_AnglePos
		rts
; End of subroutine Sonic_UpdateSpindash