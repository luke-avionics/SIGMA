////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// TSMC Library/IP Product
/// Filename: tcbn28hpcplusbwp30p140.v
/// Technology: CLN28HT
/// Product Type: Standard Cell
/// Product Name: tcbn28hpcplusbwp30p140
/// Version: 110a
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////
///  STATEMENT OF USE
///
///  This information contains confidential and proprietary information of TSMC.
///  No part of this information may be reproduced, transmitted, transcribed,
///  stored in a retrieval system, or translated into any human or computer
///  language, in any form or by any means, electronic, mechanical, magnetic,
///  optical, chemical, manual, or otherwise, without the prior written permission
///  of TSMC.  This information was prepared for informational purpose and is for
///  use by TSMC's customers only.  TSMC reserves the right to make changes in the
///  information at any time and without notice.
///
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`celldefine
module EDFCNQD1BWP30P140 (D, E, CP, CDN, Q);
    input D, E, CP, CDN;
    output Q;
    reg notifier;
    `ifdef NTC
        `ifdef RECREM
            wire CDN_d;
            buf (CDN_i, CDN_d);
        `else 
            buf (CDN_i, CDN);
        `endif 
        wire D_d, E_d, CP_d;
        pullup (SDN);
        tsmc_mux (DE, Q_buf, D_d, E_d);
        tsmc_dff (Q_buf, DE, CP_d, CDN_i, SDN, notifier);
        buf (Q, Q_buf);
    `else 
        pullup (SDN);
        buf (CDN_i, CDN);
        tsmc_mux (DE, Q_buf, D, E);
        tsmc_dff (Q_buf, DE, CP, CDN_i, SDN, notifier);
        buf (Q, Q_buf);
    `endif 

  `ifdef TETRAMAX
  `else
    tsmc_xbuf (CP_D_E_SDFCHK, CP_D_E, 1'b1);
    tsmc_xbuf (CP_D_nE_SDFCHK, CP_D_nE, 1'b1);
    tsmc_xbuf (CP_nD_E_SDFCHK, CP_nD_E, 1'b1);
    tsmc_xbuf (CP_nD_nE_SDFCHK, CP_nD_nE, 1'b1);
    tsmc_xbuf (nCP_D_E_SDFCHK, nCP_D_E, 1'b1);
    tsmc_xbuf (nCP_nD_E_SDFCHK, nCP_nD_E, 1'b1);
    tsmc_xbuf (nCP_D_nE_SDFCHK, nCP_D_nE, 1'b1);
    tsmc_xbuf (nCP_nD_nE_SDFCHK, nCP_nD_nE, 1'b1);
    tsmc_xbuf (CDN_D_E_SDFCHK, CDN_D_E, 1'b1);
    tsmc_xbuf (CDN_nD_E_SDFCHK, CDN_nD_E, 1'b1);
    tsmc_xbuf (CDN_E_SDFCHK, CDN_E, 1'b1);
    tsmc_xbuf (CDN_D_SDFCHK, CDN_D, 1'b1);
    tsmc_xbuf (CDN_nD_SDFCHK, CDN_nD, 1'b1);
    tsmc_xbuf (D_E_SDFCHK, D_E, 1'b1);
    not (nD, D);
    not (nE, E);
    not (nCP, CP);
    and (CP_D_E, CP, D, E);
    and (CP_D_nE, CP, D, nE);
    and (CP_nD_E, CP, nD, E);
    and (CP_nD_nE, CP, nD, nE);
    and (nCP_D_E, nCP, D, E);
    and (nCP_nD_E, nCP, nD, E);
    and (nCP_D_nE, nCP, D, nE);
    and (nCP_nD_nE, nCP, nD, nE);
    and (CDN_D_E, CDN, D, E);
    and (CDN_nD_E, CDN, nD, E);
    and (CDN_E, CDN, E);
    and (CDN_D, CDN, D);
    and (CDN_nD, CDN, nD);
    and (D_E, D, E);


  // Timing logics defined for default constraint check
    `ifdef NTC
      not  (E_int_not, E_d);
      and  (D_check, CDN_i, E_d);
    `else
      not  (E_int_not, E);
      and  (D_check, CDN_i, E);
    `endif
    and  (CP_check, CDN_i, D_check);
    buf  (E_check, CDN_i);
    tsmc_xbuf (CP_DEFCHK, CP_check, 1'b1);
    tsmc_xbuf (E_DEFCHK, E_check, 1'b1);
    tsmc_xbuf (D_DEFCHK, D_check, 1'b1);

  specify
    if (CP == 1'b1 && D == 1'b1 && E == 1'b1)
    (negedge CDN => (Q+:1'b0)) = (0, 0);
    if (CP == 1'b1 && D == 1'b1 && E == 1'b0)
    (negedge CDN => (Q+:1'b0)) = (0, 0);
    if (CP == 1'b1 && D == 1'b0 && E == 1'b1)
    (negedge CDN => (Q+:1'b0)) = (0, 0);
    if (CP == 1'b1 && D == 1'b0 && E == 1'b0)
    (negedge CDN => (Q+:1'b0)) = (0, 0);
    if (CP == 1'b0 && D == 1'b1 && E == 1'b1)
    (negedge CDN => (Q+:1'b0)) = (0, 0);
    if (CP == 1'b0 && D == 1'b0 && E == 1'b1)
    (negedge CDN => (Q+:1'b0)) = (0, 0);
    if (CP == 1'b0 && D == 1'b1 && E == 1'b0)
    (negedge CDN => (Q+:1'b0)) = (0, 0);
    if (CP == 1'b0 && D == 1'b0 && E == 1'b0)
    (negedge CDN => (Q+:1'b0)) = (0, 0);
    (posedge CP => (Q+:((E && D) || (!(E) && Q_buf)))) = (0, 0);
    $width (negedge CDN &&& CP_D_E_SDFCHK, 0, 0, notifier);
    $width (negedge CDN &&& CP_D_nE_SDFCHK, 0, 0, notifier);
    $width (negedge CDN &&& CP_nD_E_SDFCHK, 0, 0, notifier);
    $width (negedge CDN &&& CP_nD_nE_SDFCHK, 0, 0, notifier);
    $width (negedge CDN &&& nCP_D_E_SDFCHK, 0, 0, notifier);
    $width (negedge CDN &&& nCP_nD_E_SDFCHK, 0, 0, notifier);
    $width (negedge CDN &&& nCP_D_nE_SDFCHK, 0, 0, notifier);
    $width (negedge CDN &&& nCP_nD_nE_SDFCHK, 0, 0, notifier);
    $width (posedge CP &&& CDN_D_E_SDFCHK, 0, 0, notifier);
    $width (negedge CP &&& CDN_D_E_SDFCHK, 0, 0, notifier);
    $width (posedge CP &&& CDN_nD_E_SDFCHK, 0, 0, notifier);
    $width (negedge CP &&& CDN_nD_E_SDFCHK, 0, 0, notifier);
  `ifdef NTC
    `ifdef RECREM
      $setuphold (posedge CP &&& CDN_E_SDFCHK, posedge D , 0, 0, notifier,,, CP_d, D_d);
      $setuphold (posedge CP &&& CDN_E_SDFCHK, negedge D , 0, 0, notifier,,, CP_d, D_d);
      $setuphold (posedge CP &&& CDN_D_SDFCHK, posedge E , 0, 0, notifier,,, CP_d, E_d);
      $setuphold (posedge CP &&& CDN_D_SDFCHK, negedge E , 0, 0, notifier,,, CP_d, E_d);
      $setuphold (posedge CP &&& CDN_nD_SDFCHK, posedge E , 0, 0, notifier,,, CP_d, E_d);
      $setuphold (posedge CP &&& CDN_nD_SDFCHK, negedge E , 0, 0, notifier,,, CP_d, E_d);
      $recrem (posedge CDN &&& D_E_SDFCHK, posedge CP &&& D_E_SDFCHK, 0,0, notifier, , , CDN_d, CP_d);
    `else
      $setuphold (posedge CP &&& CDN_E_SDFCHK, posedge D , 0, 0, notifier,,, CP_d, D_d);
      $setuphold (posedge CP &&& CDN_E_SDFCHK, negedge D , 0, 0, notifier,,, CP_d, D_d);
      $setuphold (posedge CP &&& CDN_D_SDFCHK, posedge E , 0, 0, notifier,,, CP_d, E_d);
      $setuphold (posedge CP &&& CDN_D_SDFCHK, negedge E , 0, 0, notifier,,, CP_d, E_d);
      $setuphold (posedge CP &&& CDN_nD_SDFCHK, posedge E , 0, 0, notifier,,, CP_d, E_d);
      $setuphold (posedge CP &&& CDN_nD_SDFCHK, negedge E , 0, 0, notifier,,, CP_d, E_d);
      $recovery (posedge CDN &&& D_E_SDFCHK, posedge CP &&& D_E_SDFCHK, 0, notifier);
      $hold (posedge CP &&& D_E_SDFCHK, posedge CDN , 0, notifier);
    `endif
  `else
    $setuphold (posedge CP &&& CDN_E_SDFCHK, posedge D , 0, 0, notifier);
    $setuphold (posedge CP &&& CDN_E_SDFCHK, negedge D , 0, 0, notifier);
    $setuphold (posedge CP &&& CDN_D_SDFCHK, posedge E , 0, 0, notifier);
    $setuphold (posedge CP &&& CDN_D_SDFCHK, negedge E , 0, 0, notifier);
    $setuphold (posedge CP &&& CDN_nD_SDFCHK, posedge E , 0, 0, notifier);
    $setuphold (posedge CP &&& CDN_nD_SDFCHK, negedge E , 0, 0, notifier);
    $recovery (posedge CDN &&& D_E_SDFCHK, posedge CP &&& D_E_SDFCHK, 0, notifier);
    $hold (posedge CP &&& D_E_SDFCHK, posedge CDN , 0, notifier);
  `endif
  endspecify
  `endif
endmodule
`endcelldefine
