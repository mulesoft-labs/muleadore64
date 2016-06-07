!zone heartbeat

.frame_counter !byte 60
.str_heartbeat !text "hb~", 0

heartbeat_reset
		lda #255
		sta .frame_counter
		rts

heartbeat_frame_counter
		dec .frame_counter
		bne .done

		+set16im .str_heartbeat, $fb
		jsr rs232_send_string
		jsr heartbeat_reset
.done
		rts
