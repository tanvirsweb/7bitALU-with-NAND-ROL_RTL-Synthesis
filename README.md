# RTL Systhesis using OpenLane
by `Tanvir Anjom Siddique`

# Install Docker in Ubuntu >= 22.07 version

`setup_docker.sh`

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update



sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
```

```bash
gedit setup_docker.sh
# copy paste above code

chmod 777 setup_docker.sh

# Install Docker in ubuntu
./setup_docker.sh
```

# Install IIC-OSIC-TOOLS
```bash
cd ~
cd Documents
git clone https://github.com/iic-jku/IIC-OSIC-TOOLS.git
cd IIC-OSIC-TOOLS/
sudo ./start_x.sh
# s
```

# Open IIC-OSIC-TOOLS Terminal
```bash
cd ~/Documents/IIC-OSIC-TOOLS
sudo ./start_x.sh
```

# Make Project (in IIC-OSIC-TOOLS Terminal)
```bash
cd ~
mkdir OpenLane
cd OpenLane
mkdir designs
cd designs
mkdir assignemt
cd assignment
```

```bash
cd ~/OpenLane/designs/assignment

gedit ALU_OP1_NAND.v ALU.v CONTROLLER_tb.v instructions.sh ALU_OP2_ROL.v CONTROLLER.v ALU_tb.v config.json  CT4_TOP.v TOP_tb.v
# then in editor write / copy paste the code

la
```

```bash
# open all .v and .sh files in gedit
gedit $(ls *.v *.sh)
```

# RTL Systhesis using Openlane & See Outputs
```bash

openlane config.json

chmod 777 *.sh
./instructions.sh

```
# config.json
```json
{
  "DESIGN_NAME": "CT4_TOP",
  "VERILOG_FILES": [
    "dir::ALU_OP1_NAND.v",
    "dir::ALU_OP2_ROL.v",
    "dir::ALU.v",
    "dir::CONTROLLER.v",
    "dir::CT4_TOP.v"
  ],
  "CLOCK_PORT": "clk",
  "CLOCK_PERIOD": 10.0,
  "FP_CORE_UTIL": 60,
  "FP_SIZING": "absolute",
  "DIE_AREA": "0 0 100 100",
  "PL_TARGET_DENSITY": 0.65,
  "PDK": "sky130A",
  "STD_CELL_LIBRARY": "sky130_fd_sc_hd"
}

```
# instructions.sh

```bash
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

```