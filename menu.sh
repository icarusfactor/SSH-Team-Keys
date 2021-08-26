#!/bin/bash
# A ssh team key menu driven script  
## ----------------------------------
# Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'


USERDIR=dyount
BASEDIR=/home/$USERDIR
 
# ----------------------------------
# User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}



#This will check for need of setup in etc directory.
sshdsetup_root() { 

                #Check for root exit if not.
                if [[ $EUID -ne 0 ]]; then
                  echo "This script section must be run as root" 
                  exit 1
                fi

                if [ -f "/etc/ssh/sshd_config.orig" ]; then
                   echo "Backup file exists in etc directory"
                else
                   cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
                   echo "Made backup of sshd config..."
                   sed -i 's/.*AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys .ssh\/authorized_team_keys/' /etc/ssh/sshd_config 
                   echo "Made change to sshd_config file."
                   service sshd restart
                   echo "Restarted sshd service."
                fi 
                 }


#this will be for user directory setup.
sshdsetup(){
        echo "SSHD setup user directories"

        if [ -d "$BASEDIR/programs" ]; then
         echo "programs Directory exists in $BASEDIR directory"
        else
        mkdir $BASEDIR/programs
         echo "Made $BASEDIR/programs directory used by rbash."
        fi 

        if [ -d "$BASEDIR/git-shell-commands" ]; then
         echo "git-shell-commands directory exists in $BASEDIR directory"
        else
        mkdir $BASEDIR/git-shell-commands
         echo "Made $BASEDIR/git-shell-commands directory used by git."
        fi 


        pause
}
 
sshadd(){
        echo "sshadd() called"
        pause
}
 
sshremove(){
        echo "sshremove() called"
        pause
}

sshclearall(){
        echo "sshclearall() called"
        pause
}


sshsetlogin(){
        echo "sshsetlogin() called"
        pause
}

sshsetgit(){
        echo "sshsetgit() called"
        pause
}

sshsetscp(){
        echo "sshsetscp() called"
        pause
}

sshsetrbash(){
        echo "sshsetrbash() called"
        pause
}

accesscomposer(){
        echo "accesscomposer() called"
        pause
}

accessnode(){
        echo "accessnode() called"
        pause
}

accessbasic(){
        echo "accessbasic() called"

        if [ -d "$BASEDIR/programs" ]; then
         echo "programs directory exists in $BASEDIR directory making soft links"
         ln -s /bin/ls  $BASEDIR/programs
         ln -s /bin/kill $BASEDIR/programs
         ln -s /bin/ps $BASEDIR/programs
        else
         echo "Cant make softlinks programs directory needs to be made."
        fi 

        pause
}

# function to display menus
show_menus() {
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~~~~"
        echo " SSH TEAM KEYS - M E N U"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "r. ROOT SSHD SETUP"
        echo "1. USER SSHD SETUP"
        echo "2. ADD KEY"
        echo "3. REMOVE KEY"
        echo "4. CLEAR ALL TEAM KEYS"

        echo "5. SET LOGIN DIR"
        echo "6. SET KEY FOR GIT"
        echo "7. SET KEY FOR SCP"
        echo "8. SET KEY FOR RBASH"

        echo "9. ACCESS FOR COMPOSER"
        echo "0. ACCESS FOR NODE"
        echo "a. ACCESS FOR BASIC COMMANDS"

        echo "q. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
        local choice
        read -p "Enter choice [1 2 3 4 5 6 7 8 9 0 a q] " choice
        case $choice in
                r) sshdsetup_root ;;
                1) sshdsetup ;;
                2) sshadd ;;
                3) sshremove ;;
                4) sshclearall ;;
                5) sshsetlogin ;;
                6) sshsetgit ;;
                7) sshsetscp ;;
                8) sshsetrbash ;;
                9) accesscomposer ;;
                0) accessnode ;;
                a) accessbasic ;;
                q) exit 0;;

                *) echo -e "${RED}Error...${STD}" && sleep 2
        esac
}
 
# ----------------------------------------------
# Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP
 
# -----------------------------------
# Main logic - infinite loop
# ------------------------------------
while true
do
 
        show_menus
        read_options
done
