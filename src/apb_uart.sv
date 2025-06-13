// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Nils Wistoff <nwistoff@iis.ee.ethz.ch>

`include "apb/typedef.svh"

/// A legacy APB wrapper of the OBI UART.
module apb_uart(
  input  wire         CLK,
  input  wire         RSTN,
  input  wire         PSEL,
  input  wire         PENABLE,
  input  wire         PWRITE,
  input  wire  [2:0]  PADDR,
  input  wire  [31:0] PWDATA,
  output logic [31:0] PRDATA,
  output logic        PREADY,
  output logic        PSLVERR,
  output logic        INT,
  output logic        OUT1N,
  output logic        OUT2N,
  output logic        RTSN,
  output logic        DTRN,
  input  wire         CTSN,
  input  wire         DSRN,
  input  wire         DCDN,
  input  wire         RIN,
  input  wire         SIN,
  output logic        SOUT
);

  `APB_TYPEDEF_ALL(apb, logic [4:0], logic [31:0], logic [3:0])
  apb_req_t  apb_req;
  apb_resp_t apb_rsp;

  assign apb_req = '{
    paddr:   {PADDR, 2'b0},
    pprot:   '0, // confirm
    psel:    PSEL,
    penable: PENABLE,
    pwrite:  PWRITE,
    pwdata:  PWDATA,
    pstrb:   '1
  };

  assign PREADY  = apb_rsp.pready;
  assign PRDATA  = apb_rsp.prdata;
  assign PSLVERR = apb_rsp.pslverr;

  apb_uart_wrap #(
    .apb_req_t ( apb_req_t  ),
    .apb_rsp_t ( apb_resp_t )
  ) i_apb_uart_wrap (
    .clk_i     ( CLK     ),
    .rst_ni    ( RSTN    ),
    .apb_req_i ( apb_req ),
    .apb_rsp_o ( apb_rsp ),
    .intr_o    ( INT     ),
    .out1_no   ( OUT1N   ),
    .out2_no   ( OUT2N   ),
    .rts_no    ( RTSN    ),
    .dtr_no    ( DTRN    ),
    .cts_ni    ( CTSN    ),
    .dsr_ni    ( DSRN    ),
    .dcd_ni    ( DCDN    ),
    .rin_ni    ( RIN     ),
    .sin_i     ( SIN     ),
    .sout_o    ( SOUT    )
  );

endmodule
