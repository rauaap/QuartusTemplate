# Quartus project template

A template and a command line enviroinment for Intel Quartus FPGA projects.

## Usage

Initializing a new project:
```bash
source env.sh [project name] && qinit
```

Commands:
- `qinit`: Initialize a new project.
- `qactivate`: Activate the enviroinment. Takes a single argument which is the name of the project.
- `qbuild`: Build the project.
- `qanalysis`: Perform timing analysis with `quartus_sta`.
- `questa`: Launch the Questa simulation program.
- `qprogram`: Program the device. Takes a single argument which is the image file to be programmed into the device.
- `qdeactivate`: Deactivate the enviroinment.
