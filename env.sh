#!/usr/bin/env bash

INTEL_FPGA_PATH="${HOME}/.intelFPGA_lite/23.1std"
QUARTUS_PATH="${INTEL_FPGA_PATH}/quartus/bin"
LICENSE_FILE="LR-158642_License.dat"
PROJECT_PATH="$(dirname "$(readlink -f "$0")")"

qactivate() {
    projectName="$1"
    topLevelFile="${PROJECT_PATH}/src/${projectName}.vhd"

    family=${2:-'MAX 10'}
    part=${3:-'10M50DAF484C7G'}

    PATH="${PATH}:$QUARTUS_PATH"
    PS1="(quartus ${projectName}) "$PS1
}

qinit() {
    mv src/quartusTemplate.vhd "$topLevelFile" &&
    mv test/quartusTemplate.vht "test/${projectName}.vht" &&
    mv quartusTemplate.qsf "${projectName}.qsf" &&

    sed -i "s/quartusTemplate/${projectName}/g" "$topLevelFile" &&
    sed -i "s/quartusTemplate/${projectName}/g" "test/${projectName}.vht" &&
    sed -i "s/quartusTemplate/${projectName}/g" "${projectName}.qsf" &&

    quartus_sh --set "NUM_PARALLEL_PROCESSORS=$(grep 'cpu cores' /proc/cpuinfo | uniq | cut -d' ' -f3)" "$projectName"
    /bin/rm -rf .git readme.md
}

questa() {
    LM_LICENSE_FILE="${INTEL_FPGA_PATH}/${LICENSE_FILE}" \
    quartus_sh -t "${INTEL_FPGA_PATH}/quartus/common/tcl/internal/nativelink/qnativesim.tcl" --rtl_sim "$projectName" "$projectName"
}

qprogram() {
    binary="$1"
    cable="$(quartus_pgm -l | sed -En -e 's/1\) (USB-Blaster \[[0-9]-[0-9]\])/\1/p')"

    if [ -z "$cable" ]
    then
        echo "No devices found!"
        exit 1
    fi

    quartus_pgm -c "$cable" -mJTAG -o "p;${binary}"
}

qbuild() {
    quartus_map "$projectName" --source="$topLevelFile" --family="$family" --part="$part"
    quartus_fit "$projectName" --part="$part" --pack_register=minimize_area
    quartus_asm "$projectName"
}

qanalysis() {
    quartus_sta "$projectName"
}

qide() {
    quartus "${PROJECT_PATH}/${projectName}.qpf"
}

qdeactivate() {
    unset qinit qprogram qbuild qanalysis qdeactivate qide
    PATH="$(echo "$PATH" | sed -e "s|:${QUARTUS_PATH}||")"
    PS1="$(echo "$PS1" | sed -E -e "s/^\(quartus ${projectName}\) //")"
}

qactivate "$1"
