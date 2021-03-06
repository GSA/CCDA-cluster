### ARGUMENTS
## $1: The message you want to print
## $2: The name of the script from which the message originated

### DESCRIPTION
## Prints the inputted message with the current time and text formatting. 
log(){
    echo -e "\e[92m$(date +"%r")\e[0m: \e[4;32m$2\e[0m : $1"
}

help_print(){
    nl=$'\n'
    echo -e "${nl}\e[4m$2\e[0m${nl}${nl}   $1" 
}