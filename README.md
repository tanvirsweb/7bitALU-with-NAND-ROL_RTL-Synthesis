# 🔧 RTL Synthesis using OpenLane

**by [Tanvir Anjom Siddique](https://tanvirsweb.github.io/)**

---

## 📺 Project Demo Video

[![Watch the Demo](https://img.youtube.com/vi/ylSGS9OKyuc/hqdefault.jpg)](https://youtu.be/ylSGS9OKyuc)

---

## 📌 Project Overview

This project demonstrates the full flow of RTL synthesis using the OpenLane toolchain on a custom Verilog-based ALU and controller design. It includes:

1. ✅ HDL Source Code
2. ✅ RTL Timing Diagrams
3. ✅ RTL Synthesis using Skywater 130nm PDK via OpenLane
4. ✅ Synthesis Summary Reports
5. ✅ Synthesized RTL Design Diagrams
6. ✅ Standard Cell Usage Report
7. ✅ Floorplan Visualization
8. ✅ Power Analysis
9. ✅ GDSII Layout View
10. ✅ Heatmap using OpenROAD GUI

---

## 🐳 Docker Installation (Ubuntu ≥ 22.07)

Create a Docker setup script:

```bash
gedit setup_docker.sh
```

Paste the following:

```bash
# Add Docker’s official GPG key
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker’s official repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo \"${UBUNTU_CODENAME:-$VERSION_CODENAME}\") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Test installation
sudo docker run hello-world
```

Then run:

```bash
chmod +x setup_docker.sh
./setup_docker.sh
```

---

## 🛠 Install IIC-OSIC-TOOLS

```bash
cd ~/Documents
git clone https://github.com/iic-jku/IIC-OSIC-TOOLS.git
cd IIC-OSIC-TOOLS
sudo ./start_x.sh
```

To launch later:

```bash
cd ~/Documents/IIC-OSIC-TOOLS
sudo ./start_x.sh
```

---

## 📁 Project Setup

Create project folder and files:

```bash
mkdir -p ~/OpenLane/designs/assignment
cd ~/OpenLane/designs/assignment
```

Then:

```bash
gedit ALU_OP1_NAND.v ALU.v CONTROLLER_tb.v ALU_OP2_ROL.v CONTROLLER.v ALU_tb.v config.json CT4_TOP.v TOP_tb.v instructions.sh
```

---

## ⚙️ Configuration File: `config.json`

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

---

## 📜 Shell Script: `instructions.sh`

```bash
#!/bin/bash

# Permission and environment setup
chmod 777 *.sh
unset PDK
unset SCL
export PDK=sky130A
export SCL=sky130_fd_sc_hd
export PDK_ROOT=/foss/pdks

# Open Verilog files
gedit *.v

# ALU simulation
iverilog -o alu_test.vvp ALU_tb.v ALU.v ALU_OP1_NAND.v ALU_OP2_ROL.v
vvp alu_test.vvp
gtkwave alu_test.vcd

# Controller simulation
iverilog -o controller_test.vvp CONTROLLER_tb.v CONTROLLER.v
vvp controller_test.vvp
gtkwave controller_test.vcd

# Top-level simulation
iverilog -o top_test.vvp TOP_tb.v CT4_TOP.v CONTROLLER.v ALU.v ALU_OP1_NAND.v ALU_OP2_ROL.v
vvp top_test.vvp
gtkwave top_test.vcd

# Clean up simulation files
rm *.vvp *.vcd

# Run OpenLane
openlane config.json

# Locate latest run
DESIGN_DIR=$(pwd)
RUN_DIR=$(ls -td "$DESIGN_DIR/runs/RUN_"*/ | head -1)
echo "Latest run directory: $RUN_DIR"

# View reports and diagrams
cd "$RUN_DIR/06-yosys-synthesis/reports"
gedit stat.rpt

cd "$RUN_DIR/06-yosys-synthesis"
xdot hierarchy.dot
xdot primitive_techmap.dot

cd "$RUN_DIR/13-openroad-floorplan"
gedit openroad-floorplan.log

cd "$RUN_DIR/54-openroad-stapostpnr/nom_tt_025C_1v80"
gedit power.rpt

cd "$RUN_DIR/final/gds"
klayout CT4_TOP.gds

cd "$RUN_DIR/final/odb"
openroad -gui
```

---

## 🚀 Running the Project

```bash
chmod +x instructions.sh
./instructions.sh
```

---

## 📂 Project Directory Structure

```
OpenLane/
└── designs/
    └── assignment/
        ├── ALU.v
        ├── ALU_tb.v
        ├── CONTROLLER.v
        ├── CONTROLLER_tb.v
        ├── CT4_TOP.v
        ├── TOP_tb.v
        ├── ALU_OP1_NAND.v
        ├── ALU_OP2_ROL.v
        ├── config.json
        └── instructions.sh
```

---

## 🧰 Tools & Technologies

- **OpenLane** – Full RTL to GDSII digital flow
- **Skywater 130nm (sky130A) PDK**
- **GTKWave** – Verilog waveform visualization
- **iverilog** – Verilog simulation tool
- **KLayout** – GDS layout viewer
- **xdot** – Graph-based schematic viewer
- **OpenROAD GUI** – Layout and heatmap visualization

---

## 👨‍💻 Author

**Tanvir Anjom Siddique**
CSE, RUET | RTL & Digital Design Enthusiast
🔗 [Portfolio](https://tanvirsweb.github.io/) | 🔗 [LinkedIn](https://bd.linkedin.com/in/tanvir-anjom-siddique)

---
