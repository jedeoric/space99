
_sedoric		; invoke a SEDORIC command using black magic
			; Watch it! I have reasons to believe this is broken
        ldy #$0         ; grab string pointer
        lda (sp),y
        sta tmp
        iny
        lda (sp),y
        sta tmp+1
        dey

sedoricloop1            ; copy the string to #35..#84
        lda (tmp),y
        sta $35,y
        iny
        ora #$0
        bne sedoricloop1

        sta $ea         ; update the line start pointer
        lda #$35;
        sta $e9

        jsr $00e2       ; get next token
        jmp ($02f5)     ; call the ! command handler


;;;;;;;;;;;;;;;; Routines to manage disk...

#ifdef0
_dbug
	lda #0
dbug
	beq dbug
	rts
#endif




_switch_eprom
    lda $0314
    and #%01111101
    sta $0314
	rts




diskcntrl .byt $86

telestrat_bank .byt $06 ; for telestrat compatibility : Jede 27/03/2017
_switch_ovl 
.(
	php
	pha
	sei
	lda diskcntrl
	eor #2
	sta diskcntrl
	sta $0314
  
  ; for telestrat compatibility : Jede 27/03/2017
  lda telestrat_bank
  bne switch_to_ram_overlay
  lda #$06 ; switch into atmos rom in stratoric cardridge
  
  jmp store
switch_to_ram_overlay
  lda #$00
store  
  sta $321
  sta telestrat_bank
  ;end of telestrat compatibility
  
	pla
	plp
	rts
.)


_reboot_oric
.(
    lda $0314
    and #%01111101
    sta $0314
    ; ; for telestrat compatibility : Jede 27/03/2017
    lda #$07 ; switch into atmos rom in stratoric cardridge
    sta $321
    ; end of telestrat compatibility
    
    
    ldx #0
    txs

    jmp $eb7e 

.)


