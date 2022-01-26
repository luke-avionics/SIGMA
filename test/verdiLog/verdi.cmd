debImport "-sv" "-f" "tb_ctr_f.f"
srcTBInvokeSim
srcTBRunSim
srcTBSimReset
srcDeselectAll -win $_nTrace1
srcSelect -signal "LOG2_W_ROW_SIZE" -line 10 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcTBStepIn
srcTBRunSim
srcTBSimReset
srcTBRunSim
debExit
