debImport "-f" "test.f"
verdiWindowResize -win $_Verdi_1 "1920" "23" "1920" "1017"
wvCreateWindow
schCreateWindow -delim "." -win $_nSchema1 -scope "test_LVDSTS28HPCPBI1B"
schCloseWindow -win $_nSchema3
srcAddBookMark -win $_nTrace1 "test_LVDSTS28HPCPBI1B.v" 38
srcHBSelect "test_LVDSTS28HPCPBI1B" -win $_nTrace1
srcSetScope -win $_nTrace1 "test_LVDSTS28HPCPBI1B" -delim "."
srcHBSelect "test_LVDSTS28HPCPBI1B" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rxda_v" -line 143 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 \
           {/home/zy34/FlatCam_chip/rtl_11_26/tb/rtl_sim/LVDSIO_verilog/test.rtl.fsdb}
srcDeselectAll -win $_nTrace1
srcSelect -signal "rxda_v" -line 143 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomAll -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rxda_h" -line 177 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "PAD_N_h" -line 155 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoom -win $_nWave2 2986334586.466166 3341353383.458647
wvZoom -win $_nWave2 3050843014.490950 3085321657.056009
debExit
