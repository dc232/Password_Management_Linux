#!/bin/bash
################################
# GLOBAL VARS
################################
USERNAME="test"
UNSALTED_PASSWORD="test"
SALTED_PASS=$(perl -e 'print crypt($ARGV[0], "password")' $UNSALTED_PASSWORD) #the word password in this case is what the original password is salted aginast
#the -e means expsire in this case it will froce expsire the password for the named account
PASS="echo $SALTED_PASS"
USERNAME_EXISTS=$(id -u $USERNAME > /dev/null 2>&1; echo $?)
UID=$(id -u $USERNAME)

overall_script () {
    username_exist_check
}

create_user () {
    cat << EOF
########################################
Creating the user $USERNAME and also
creating the salted password for the user
as well as setting up their home directory
########################################
EOF

sleep 2
   sudo useradd -m $USERNAME -p $PASS $USERNAME
   # -m means create the users home directory if it does not exist
   # -p means password to be passed in this case this id the salted password

cat << EOF
###########################################
Checking to see if the user been added to
the system or not
###########################################
EOF
if [ $USERNAME_EXISTS -eq 0 ]; then #as the last line returns a boolean value we need to equate the value to a 0 or 1 to ifind out if the user exists
echo "The Username exists as shown below"
grep -w $USERNAME /etc/passwd
else
echo "The username does not exists exiting script"
sleep 2
exit 0
fi

}
#more elegant solution 
#https://stackoverflow.com/questions/14810684/check-whether-a-user-exists
# id -u $$USERNAME > /dev/null 2>&1; echo $?
# the line above takes the output of the command id -u and passes to /dev/null where only the standarderror information is displayed 
# via standard out, the echo $? means echo the last argument
#$? is the return code of the last executed command
#https://www.unix.com/shell-programming-and-scripting/75297-what-does-echo-mean.html
#http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-3.html 3.5 Sample: stderr 2 stdout


username_exist_check () {
    #in linux user information is stored in /etc/passwd therefore we can grep aginast this file to find a user name
    USERCHECK=grep $USERNAME /etc/passwd
cat << EOF
########################################
Checking to see if the user $USERNAME
exists
########################################
EOF

sleep 2
    if [ "$USERNAME_EXISTS" -eq 0 ]; then #if the user does not exist then crete the user
    echo "The user $USERNAME exists and has a UID of $UID no need to continue with script"
    exit 0
    else
        create_user
    fi
}


cat << EOF
################################################
This scrript explores how to manage passwords
in a secure way
################################################
EOF

sleep 2

overall_script
