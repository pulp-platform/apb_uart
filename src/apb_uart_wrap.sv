// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Paul Scheffler <paulsc@iis.ee.ethz.ch>
// Nils Wistoff <nwistoff@iis.ee.ethz.ch>

`include "obi/typedef.svh"

// A UART with APB struct ports.
module apb_uart_wrap #(
  parameter type apb_req_t = logic,
  parameter type apb_rsp_t = logic
) (
  input  logic clk_i,
  input  logic rst_ni,

  // APB
  input  apb_req_t apb_req_i,
  output apb_rsp_t apb_rsp_o,

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

  localparam obi_pkg::obi_cfg_t ObiCfg = obi_pkg::obi_default_cfg(
      $bits(apb_req_i.paddr),
      32,
      1,
      obi_pkg::ObiMinimalOptionalConfig
  );

  `OBI_TYPEDEF_DEFAULT_ALL(obi, ObiCfg)
  obi_req_t obi_req;
  obi_rsp_t obi_rsp;

  apb_to_obi #(
    .ObiCfg    ( ObiCfg    ),
    .apb_req_t ( apb_req_t ),
    .apb_rsp_t ( apb_rsp_t ),
    .obi_req_t ( obi_req_t ),
    .obi_rsp_t ( obi_rsp_t )
  ) i_apb_to_obi (
    .clk_i     ( clk_i     ),
    .rst_ni    ( rst_ni    ),
    .apb_req_i ( apb_req_i ),
    .apb_rsp_o ( apb_rsp_o ),
    .obi_req_o ( obi_req   ),
    .obi_rsp_i ( obi_rsp   )
  );

  obi_uart #(
    .ObiCfg    ( ObiCfg    ),
    .obi_req_t ( obi_req_t ),
    .obi_rsp_t ( obi_rsp_t )
  ) i_obi_uart (
    .clk_i     ( clk_i   ),
    .rst_ni    ( rst_ni  ),
    .obi_req_i ( obi_req ),
    .obi_rsp_o ( obi_rsp ),
    .irq_o     ( intr_o  ),
    .irq_no    (         ),
    .rxd_i     ( sin_i   ),
    .txd_o     ( sout_o  ),
    .cts_ni    ( cts_ni  ),
    .dsr_ni    ( dsr_ni  ),
    .ri_ni     ( rin_ni  ),
    .cd_ni     ( dcd_ni  ),
    .rts_no    ( rts_no  ),
    .dtr_no    ( dtr_no  ),
    .out1_no   ( out1_no ),
    .out2_no   ( out2_no )
  );

endmodule
