#!/bin/bash
# A ssh team key menu driven script  
## ----------------------------------
# Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'

BASEDIR=/home/dyount
 
# ----------------------------------
# User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

sshdsetup(){
        echo "SSHD setup directory and config file for separate team key and need to restart service"

        #Need to check if team key has already been changed by search for authorized_team_keys
        #Make directory for original files. 
        if [ -f "$BASEDIR/sshteamkeys/orig" ]; then
         echo "Backup directory orig already exists"
        else
         mkdir $BASEDIR/sshteamkeys/orig/
         echo "Made backup directory..."
        fi 
  
        if [ -f "$BASEDIR/sshteamkeys/orig/sshd_config" ]; then
         echo "File exists in orig backup directory"
        else
        cp /etc/ssh/sshd_config $BASEDIR/sshteamkeys/orig/
         echo "Made backup of sshd config..."
        sed -i 's/.*AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys .ssh\/authorized_team_keys/' /etc/ssh/sshd_config 
        echo "Made change to sshd_connig file."
        fi 

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
         echo "Cant make softlinks programs directory needs to be made. "
        fi 

        pause
}

# function to display menus
show_menus() {
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~~~~"
        echo " SSH TEAM KEYS - M E N U"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "1. SSHD SETUP"
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
