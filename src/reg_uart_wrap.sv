// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Paul Scheffler <paulsc@iis.ee.ethz.ch>
// Nicole Narr <narrn@student.ethz.ch>
// Christopher Reinwardt <creinwar@student.ethz.ch>
// Nils Wistoff <nwistoff@iis.ee.ethz.ch>

`include "apb/typedef.svh"

module reg_uart_wrap #(
  parameter int unsigned AddrWidth = -1,
  parameter type reg_req_t = logic,
  parameter type reg_rsp_t = logic
) (
  input  logic clk_i,
  input  logic rst_ni,

  // Regbus
  input  reg_req_t reg_req_i,
  output reg_rsp_t reg_rsp_o,

  // Physical interface
  output logic intr_o,
  output logic out1_no,
  output logic out2_no,
  output logic rts_no,
  output logic dtr_no,
  input  logic cts_ni,
  input  logic dsr_ni,
  input  logic dcd_ni,
  input  logic rin_ni,
  input  logic sin_i,   // RX
  output logic sout_o   // TX
);

  `APB_TYPEDEF_ALL(apb, logic [AddrWidth-1:0], logic [31:0], logic [3:0])
  apb_req_t  apb_req;
  apb_resp_t apb_rsp;

  reg_to_apb #(
    .reg_req_t ( reg_req_t ),
    .reg_rsp_t ( reg_rsp_t ),
    .apb_req_t ( apb_req_t ),
    .apb_rsp_t ( apb_resp_t )
  ) i_reg_to_apb (
    .clk_i,
    .rst_ni,
    .reg_req_i,
    .reg_rsp_o,
    .apb_req_o ( apb_req ),
    .apb_rsp_i ( apb_rsp )
  );

  apb_uart_wrap #(
    .apb_req_t ( apb_req_t ),
    .apb_rsp_t ( apb_resp_t )
  ) i_apb_uart_wrap (
    .clk_i     ( clk_i   ),
    .rst_ni    ( rst_ni  ),
    .apb_req_i ( apb_req ),
    .apb_rsp_o ( apb_rsp ),
    .intr_o    ( intr_o  ),
    .out1_no   ( out1_no ),
    .out2_no   ( out2_no ),
    .rts_no    ( rts_no  ),
    .dtr_no    ( dtr_no  ),
    .cts_ni    ( cts_ni  ),
    .dsr_ni    ( dsr_ni  ),
    .dcd_ni    ( dcd_ni  ),
    .rin_ni    ( rin_ni  ),
    .sin_i     ( sin_i   ),
    .sout_o    ( sout_o  )
  );

endmodule
