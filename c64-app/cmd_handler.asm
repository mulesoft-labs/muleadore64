!zone command_handler

CMD_TWITTER = "1"
CMD_BORDER = "2"
CMD_BG = "3"
CMD_PLAY = "5"
CMD_HEARTBEAT = "6"
CMD_WEATHER = "7"
CMD_VISITORS = "8"
CMD_VISITOR_CHECKIN = "9"

heartbeat_tick !byte 0

; ----------------------------------------------------------------------
; Looks at cmd_buffer and executes matching command
; ----------------------------------------------------------------------
command_handler
                lda cmd_buffer
                cmp #CMD_TWITTER
                bne .test_border_cmd
                ; handle tweet
                +set16im cmd_buffer + 1, $fb
                +set16im twitter_buffer, $fd
                jsr string_copy
                jsr main_screen_update_twitter
                rts

.test_border_cmd
                cmp #CMD_BORDER
                bne .test_bg_cmd
                lda cmd_buffer + 1
                sta $d020       ; border color
                rts

.test_bg_cmd
                cmp #CMD_BG
                bne .test_play_cmd
                lda cmd_buffer + 1
                sta $d021       ; background color
                rts

.test_play_cmd
                cmp #CMD_PLAY
                bne .test_heartbeat_cmd
                rts

.test_heartbeat_cmd
                cmp #CMD_HEARTBEAT
                bne .test_weather_cmd
                ldx #0
                ldy #39
                clc
                jsr PLOT
                lda heartbeat_tick
                eor #1
                sta heartbeat_tick
                bne .test_heartbeat_print_tick
                lda #COLOR_WHITE
                jsr CHROUT
                lda #32                 ; print " "
                jsr CHROUT
                rts
.test_heartbeat_print_tick
                lda #COLOR_WHITE
                jsr CHROUT
                lda #186                ; print "{tick}"
                jsr CHROUT
                rts

.test_weather_cmd
                cmp #CMD_WEATHER
                bne .test_visitors
                +set16im cmd_buffer + 1, $fb
                +set16im weather_buffer, $fd
                jsr string_copy
                jsr main_screen_update_weather
                rts

.test_visitors
                cmp #CMD_VISITORS
                bne .test_visitor_checkin
                +set16im cmd_buffer + 1, $fb
                +set16im visitors_buffer, $fd
                jsr string_copy
                jsr main_screen_update_visitors
                rts

.test_visitor_checkin
                cmp #CMD_VISITOR_CHECKIN
                bne .done
                ; do some checkin screen
                rts

.done
                rts