CC = gcc
CFLAGS ?= -O2 -Wall -Wextra -std=c11
INCLUDES = -Iapp/h_files -Iapp/calibration
SRC = app/calibration/calibration.c app/c_files/app.c app/c_files/engine.c app/main.c
BIN = ecm
PY = python

all: $(BIN)
$(BIN): $(SRC)
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $(SRC)

clean:
	- rm -f $(BIN)

test: $(BIN)
	@echo "# Testcase Run Summary" > testcase_run_summary.md
	@echo "" >> testcase_run_summary.md
	@echo "| Testcase | Result |" >> testcase_run_summary.md
	@echo "|----------|--------|" >> testcase_run_summary.md
	@echo "Running SCR000001 tests..."
	@./$(BIN) testcases/SCR000001/case1_ign_on_off.csv testcases/SCR000001/case1_ign_on_off_out.csv app/calibration/calibration.txt
	@$(PY) tools/compare_csvs.py testcases/SCR000001/case1_ign_on_off_golden.csv testcases/SCR000001/case1_ign_on_off_out.csv && \
	  echo "| case1_ign_on_off | PASS |" >> testcase_run_summary.md || \
	  echo "| case1_ign_on_off | FAIL |" >> testcase_run_summary.md
	@./$(BIN) testcases/SCR000001/case2_toggle.csv testcases/SCR000001/case2_toggle_out.csv app/calibration/calibration.txt
	@$(PY) tools/compare_csvs.py testcases/SCR000001/case2_toggle_golden.csv testcases/SCR000001/case2_toggle_out.csv && \
	  echo "| case2_toggle | PASS |" >> testcase_run_summary.md || \
	  echo "| case2_toggle | FAIL |" >> testcase_run_summary.md
	@./$(BIN) testcases/SCR000001/case3_noise_ignored.csv testcases/SCR000001/case3_noise_ignored_out.csv app/calibration/calibration.txt
	@$(PY) tools/compare_csvs.py testcases/SCR000001/case3_noise_ignored_golden.csv testcases/SCR000001/case3_noise_ignored_out.csv && \
	  echo "| case3_noise_ignored | PASS |" >> testcase_run_summary.md || \
	  echo "| case3_noise_ignored | FAIL |" >> testcase_run_summary.md
	@echo "Test summary written to testcase_run_summary.md"

