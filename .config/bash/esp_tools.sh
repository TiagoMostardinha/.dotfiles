#!/bin/bash

ESPSetup=false

function esp_tools() {
    local targetESP="esp32c3"

    # Corrected the function declaration syntax
    hasESPSetup() {
        if [[ "$ESPSetup" == "false" ]]; then
            echo "ESP Setup not completed. Please run with -c option first."            
            return  1
        fi
        return  0
    }

    while getopts "hcbfm:" opt; do
        case $opt in
        h)
            echo -e "Help\n\t-h: Help\n\t-c: Sets up your environment and variables to develop\n\t-b: Compile and Build your app/project\n\t-f: Flash your built binaries into the ESP32C3\n\t-m: Shows the terminal of your ESP32C3 through the monitor"
            ;;
        c)
            echo -e "\e[32mSetting up ESP environment...\e[0m"
            . "$HOME/esp/esp-idf/export.sh"
            idf.py set-target $targetESP
            ESPSetup=true
            ;;
        b)
            if hasESPSetup; then
                echo -e "\e[32mBuilding app...\e[0m"
                idf.py build
            fi
            ;;
        f)
            if hasESPSetup; then
                echo -e "\e[32mFlashing app to /dev/ttyUSB0...\e[0m"
                idf.py -p /dev/ttyUSB0 flash
            fi
            ;;
        m)
            if hasESPSetup; then
                echo "\e[32mOpening Monitor in /dev/ttyUSB0...\e[0m"
                idf.py -p /dev/ttyUSB0 monitor
            fi
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
        esac
    done
    OPTIND=1
}

# Alias
alias get_idf='. $HOME/esp/esp-idf/export.sh'
