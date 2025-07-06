#!/bin/bash

# ===================================
# Environment Setup & Permissions
# ===================================

# Make all shell scripts executable
chmod 777 *.sh

# Unset and set PDK variables
unset PDK
unset SCL

export PDK=sky130A
export SCL=sky130_fd_sc_hd
export PDK_ROOT=/foss/pdks

echo "PDK set to: $PDK"
echo "SCL set to: $SCL"

# ===================================
# Open All Verilog Source Files
# ===================================
gedit *.v $(ls *.v) 

# ===================================
# Simulation: ALU Module
# ===================================
iverilog -o alu_test.vvp ALU_tb.v ALU.v ALU_OP1_NAND.v ALU_OP2_ROL.v
vvp alu_test.vvp
gtkwave alu_test.vcd 

# ===================================
# Simulation: Controller Module
# ===================================
iverilog -o controller_test.vvp CONTROLLER_tb.v CONTROLLER.v
vvp controller_test.vvp
gtkwave controller_test.vcd 

# ===================================
# Simulation: Top Module
# ===================================
iverilog -o top_test.vvp TOP_tb.v CT4_TOP.v CONTROLLER.v ALU.v ALU_OP1_NAND.v ALU_OP2_ROL.v
vvp top_test.vvp
gtkwave top_test.vcd 


# clean .vvp and .vcd files
sudo rm *.vvp *.vcd
# ===================================
# Start OpenLane Flow
# ===================================
# openlane config.json

# ===================================
# Define Paths
# ===================================
DESIGN_DIR=$(pwd)
RUN_DIR=$(ls -td "$DESIGN_DIR/runs/RUN_"*/ | head -1)

echo "Using latest run directory: $RUN_DIR"

# ===================================
# View Project Folder Contents
# ===================================
cd "$DESIGN_DIR"
la

# ===================================
# RTL Synthesis Summary
# ===================================
cd "$RUN_DIR/06-yosys-synthesis/reports"
gedit stat.rpt 

# ===================================
# RTL Synthesised Design Figures
# ===================================
cd "$RUN_DIR/06-yosys-synthesis"
xdot hierarchy.dot 
xdot primitive_techmap.dot 

# ===================================
# Standard Cell Usage
# ===================================
cd "$RUN_DIR/06-yosys-synthesis/reports"
gedit stat.rpt 

# ===================================
# RTL Floorplan
# ===================================
cd "$RUN_DIR/13-openroad-floorplan"
gedit openroad-floorplan.log 

# ===================================
# RTL Power Report
# ===================================
cd "$RUN_DIR/54-openroad-stapostpnr/nom_tt_025C_1v80"
gedit power.rpt 

# ===================================
# GDS Layout
# ===================================
cd "$RUN_DIR/final/gds"
klayout CT4_TOP.gds

# ===================================
# Heatmap (ODB View)
# ===================================
cd "$RUN_DIR/final/odb"
openroad -gui 
