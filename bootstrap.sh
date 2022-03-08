#!/bin/bash

: '
        $OSTYPE return values
        linux-gnu :: linux
        darwin* :: Mac OSX
        cygwin :: Windows
        msys :: Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        win32 :: Windows 32
'

function dependencies() {
        echo ""
        case $OSTYPE in
               linux?)
                        echo "Detected Linux."
                        echo "Checking for valid virtualenv."
                        if ! [[ $(which virtualenv) ]]; then
                                echo "Installing virtualenv for python."
                        fi
                ;;
                darwin*)
                        echo "Detected MacOS."
                        echo ""
                        echo "Checking for valid homebrew installation."
                        if ! [[ $(which brew) ]]; then
                                echo "Installing homebrew."
                                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
                                echo "  homebrew successfully installed."
                        else
                                echo "  homebrew is present."
                        fi
                        echo "Checking for valid python3 and pip installation."
                        if ! [[ $(which python3) ]]; then
                                echo "Installing python3."
                                $(which brew) install python3
                                echo "  python3 successfully installed."
                        else
                                echo "  python3 is present."
                        fi
                        echo "Checking for valid pip3 installation."
                        if ! [[ $(which pip3) ]]; then
                                echo "Install pip3."
                                $(which python) -m pip3 install --upgrade pip
                                echo "  pip3 successfully installed."
                        else
                                echo "  pip3 is present."
                        fi
                        echo "Checking for valid pipx installation."
                        if ! [[ $(which pipx) ]]; then
                                echo "Installing pipx."
                                $(which brew) install pipx
                                echo "  pipx successfully installed."
                        else
                                echo "  pipx is present."
                        fi
                        echo "Checking for valid virtualenv installation."
                        if ! [[ $(which virtualenv) ]]; then
                                echo "Installing virtualenv for python."
                                $(which pipx) install virtualenv
                                echo "  pipx successfully installed."
                        else
                                echo "  virtualenv is present."
                        fi
                ;;
                *)
                        echo "OS not detected.  Please install python virtualenv manually."
                        exit;
        esac
        echo ""
}

function install_requirements() {
        echo ""
        echo "Checking for presence of virtualenv."
        if [ ! -d "./venv" ]; then
                echo "Creating a virtualenv in: ./venv"
                $(which python3) -m venv ./venv/
                echo "  The virtualenv has been created."
        else
                echo "  Virtualenv already exists at: ./venv"
        fi
        echo "Loading the virtualenv."
        source ./venv/bin/activate
        echo "  virtualenv loaded."
        echo ""
        echo "Installing required packages from: ./requirements.txt"
        $(which pip3) install -r requirements.txt
        echo "  Required packages installed"
}

function datadog_api_key() {
        echo ""
        echo "Checking for the presence of an DataDog API key."
        if [[ -z "${DATADOG_API_KEY}" ]]; then
                echo "DataDog API Key is not present as environment variable:"
                echo "  \$DATADOG_API_KEY"
                echo ""
                echo "You will be asked to set one in the next prompt.  You an admin can create one at this URL:"
                echo "  https://app.datadoghq.com/organization-settings/api-keys"
                echo ""
                echo "If you are not an admin please hit CTRL-C to stop this script, then create a ServiceNow ticket to request an API key."
                echo ""
                read -p "Enter your DataDog API key: " USER_API_KEY
                echo ""
                case $SHELL in
                        *zsh*)
                                echo ""
                                echo "  Detected shell: zsh"
                                echo ""
                                echo "echo 'DATADOG_API_KEY=${USER_API_KEY}' >> ${HOME}/.zshenv && source ${HOME}/.zshenv"
                                echo "Environment variable added to ~/.zshenv and exported."
                                echo ""
                        ;;
                        *bash*)
                                echo ""
                                echo "  Detected shell: bash"
                                echo ""
                                echo "echo 'DATADOG_API_KEY=${USER_API_KEY}' >> ${HOME}/.env && source ${HOME}/.env"
                                echo "Environment variable added to ~/.env and exported."
                                echo ""
                        ;;
                        *)
                                echo ""
                                echo "  ERROR: Unknown shell type.  Cannot proceed with setting environment var."
                                echo ""
                                echo "  Please manually set the following environment variable:"
                                echo "    \$DATADOG_API_KEY=YOUR_API_KEY_HERE"
                                echo ""
                esac
                echo "Your DATADOG_API_KEY is set to:"
                echo "  \$DATADOG_API_KEY=${DATADOG_API_KEY}"
        fi
}

function how_to_output() {
        echo ""
        echo "Your system has been bootstrapped."
        echo "Please make sure you are loading your virtualenv before using this code."
        echo "To load your virtualenv you will use the following command:"
        echo "  source ./venv/bin/activate"
        echo ""

}

function main() {
        dependencies
        install_requirements
        datadog_api_key
        #how_to_output
}

main;