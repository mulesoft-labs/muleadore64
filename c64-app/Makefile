BUILD_DIR=build
MONITOR_CMD_INPUT=monitor_commands
MONITOR_CMD_OUTPUT=/tmp/monitor_commands
VICE_MONITOR_COMMANDS=/tmp/vice_monitor_commands

.PHONY: all
all: 
	@echo Building c64 binary...
	@mkdir -p "$(BUILD_DIR)"
	acme --outfile "$(BUILD_DIR)/app.prg" -l "$(BUILD_DIR)/labels.out" --format cbm --cpu 6510 main.asm
	#tools/pucrunch/pucrunch.out "$(BUILD_DIR)/app.prg" "$(BUILD_DIR)/app.prg"

run: all
	@/Applications/x64.app/Contents/MacOS/x64 -config vicerc "$(BUILD_DIR)/app.prg"

debug: all
	@echo Writing vice monitor input file...
	@echo 'll "$(BUILD_DIR)/labels.out"' > $(VICE_MONITOR_COMMANDS)
	@cat $(MONITOR_CMD_INPUT) >> $(VICE_MONITOR_COMMANDS)
	@x64 -remotemonitor -config vicerc -moncommands $(VICE_MONITOR_COMMANDS) "$(BUILD_DIR)/app.prg" &> /tmp/x64.out &
	@echo Connecting to remote monitor...
	sleep 1
	telnet 127.0.0.1 6510

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)/app.prg
