function installed {
    command -v "$1" &> /dev/null
}

function installed_module {
    python3 -c "import $1" &> /dev/null
}

function install {
    echo -e "[+] Trying to install $1..."
    sudo apt install "$1"
}

function print {
    echo -e "$1"
}

function error {
    echo "$1"
    exit 255
}

function dir_exists {
    [ -d "$1" ]
}

function exit_if_error {
    if [ $? -ne 0 ]
    then
        error "$1"
    fi
}


USER_SHELL=$(ps -p $$ -o comm=)



if ! installed "python3"
then
    print "[!] Python is not installed"
    install "python3"

    exit_if_error "Failed to install python3."
fi



if ! installed "pip"
then
    print "[!] python3-pip is not installed"
    install "python3-pip"

    exit_if_error "Failed to install python3-pip"
fi



if ! installed_module "venv"
then
    print "[!] python3-venv is not installed."
    install "python3-venv"

    exit_if_error "Failed to install python3-venv"
fi



if ! dir_exists ".venv"
then
    print "[+] Creating .venv directory"
    python3 -m venv .venv

    exit_if_error "Unable to create virtual environment"
fi



if [[ "$USER_SHELL" = "zsh" || "$USER_SHELL" = "bash" ]]
then
    source .venv/bin/activate
elif [ "$USER_SHELL" = "fish" ]
then
    source .venv/bin/activate.fish
else
    source .venv/bin/activate.csh
fi

pip install numpy
exit_if_error "Failed to install numpy"

pip install pandas
exit_if_error "Failed to install pandas"

pip install matplotlib
exit_if_error "Failed to install matplotlib"

pip install scikit-learn
exit_if_error "Failed to install scikit-learn"

print "Setup successful."