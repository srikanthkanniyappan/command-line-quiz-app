#!/bin/bash
signin(){
    clear
    echo 
    echo 
    echo -e "\e[1;31mWelcome to My Command Line :)\e[0m "
    sleep 0.5
    echo -e "\e[1;36mSign In\e[0m "   
    sleep 0.3
    printf "\033[95m"
    read -p "User Name: " uname
    if grep -xq $uname Users.txt
    then
        read -sp "Password: " pw
        printf "\033[0m"
        if grep -xq $uname$pw Password.txt
        then
            operation $uname
        else
            echo
            echo -e "\e[1;31mIncorrect Password :(\e[0m "
            sleep 1
            echo -e "\e[1;31mPlease Try Again..\e[0m "
            sleep 2
            signin
        fi
    else
        echo -e "\e[1;31mAccount Not Found :(\e[0m "
        sleep 1
        echo -e "\e[1;31mPlease Enter Valid User Name..\e[0m "
        sleep 2
        signin
    fi
}
create(){
    clear
    echo
    echo
    echo -e "\e[1;31mWelcome to My Command Line :)\e[0m "
    sleep 0.5
    echo -e "\e[1;36mCreate Account\e[0m "   
    sleep 0.3
    printf "\033[95m"
    read -p "User Name: " uname
    if grep -xq $uname Users.txt
    then
        printf "\033[91m"
        echo "User Already Exist :("
        sleep 1
        echo "Please Enter Another User Name.."
        printf "\033[0m"
        sleep 2
        create 
    else
        read -sp "Password: " pw
        echo $uname >> Users.txt
        echo $uname$pw >> Password.txt
        clear
        printf "\033[1;92m"
        echo
        echo
        echo "Account Created Successfully :)"
        printf "\033[0m"
        sleep 1.5
        operation $uname 
    fi
    printf "\033[0m"
}
invalid(){
    printf "\033[91m"
    echo "Please Enter Correct Choice.."
    printf "\033[0m"
    sleep 1.2
    index
}
invalid2(){
    printf "\033[91m"
    echo "Please Enter Correct Choice.."
    printf "\033[0m"
    sleep 1.2
    operation
}
operation(){
    clear
    echo
    echo
    echo -e "\e[1;31mWelcome $1 :)\e[0m"
    sleep 0.5
    echo -e "\e[1;36mPlease Select Your Choice..\e[0m "
    sleep 0.2
    printf "\033[93m"
    echo "1.Take a Test "
    sleep 0.2
    echo "2.View Results"
    sleep 0.2
    echo "3.Exit"
    sleep 0.2
    printf "\033[0m"
    printf "\033[95m"
    read -p "Enter Your Choice: " choice
    printf "\033[0m"
    case "$choice" in
    1) taketest $1
    ;;
    2) result $1
    ;;
    3) echo -e "\e[1;31mBye Bye..\e[0m "
    sleep 1
    exit
    ;;
    *)
    invalid2
    ;;
    esac
}
taketest(){
    if [ -f $1.txt ]
    then 
        rm $1.txt
    fi
    touch $1.txt
    clear
    echo
    echo
    printf "\033[96m"
    echo "All the Best $1 :)"
    printf "\033[0m"
    cnt=5
    printf "\033[95m"
    until [ $cnt -eq 0 ]
    do 
        printf "\rYour Quiz will start in $cnt seconds..."
        sleep 1
        cnt=$(expr $cnt - 1)
    done
    printf "\033[0m"
    score=0
    tot_questions=0
    while IFS='#' read -r question choices answer
    do 
        clear
        echo
        echo
        echo -e "\e[1;34m$question \e[0m" 
        echo -e "\e[1;34m$question \e[0m" >> $1.txt
        echo
        echo -e "\e[1;36m$choices \e[0m"
        echo -e "\e[1;36m$choices \e[0m" >> $1.txt
        echo >> $1.txt
        echo
        printf "\033[95m "
        read -p "Choose Your Answer: " usr_answer </dev/tty
        printf "\033[0m"
        answer=$(echo $answer)
        if [ "$usr_answer" = "$answer" ]
        then
            echo -e "Correct Answer :\e[1;32mOption $answer \e[0m  Your Answer : \e[1;32mOption $usr_answer \e[0m " >> $1.txt
            echo >> $1.txt
            score=`expr $score + 1`
        else
             echo -e "Correct Answer :\e[1;32mOption $answer \e[0m  Your Answer : \e[1;31mOption $usr_answer \e[0m " >> $1.txt
             echo >> $1.txt
        fi
        clear
            tot_questions=`expr $tot_questions + 1`
        sleep 0.3
    done <Questions.txt
    echo  -e "\e[1;34mYour Score is :  $score Out of $tot_questions \e[0m"  >> $1.txt
    result $1
}
result(){
    if [ -f $1.txt ]
    then
        clear
        echo 
        echo
        echo 
        echo
        echo -e "\e[1;35m                                              Hi $1 :)   \e[0m " 
        echo
        echo -e "\e[1;41m================================================ RESULT ================================================\e[0m "
        echo 
        cat $1.txt
        echo 
        echo -e "\e[1;41m========================================================================================================\e[0m " 
        echo
        echo -e "\e[1;35m                                            Good Luck $1 :)  \e[0m "
    else
        clear
        echo
        echo
        echo -e "\e[1;31mYou Have Not Completed the Quiz :( \e[0m "
        sleep 2.5
        taketest $1
    fi
}
index(){
    touch Users.txt
    touch Password.txt
    clear
    echo
    echo
    echo -e "\e[1;31mWelcome to My Command Line :)\e[0m "
    sleep 0.5
    echo -e "\e[1;36mPlease Select Your Choice..\e[0m "
    sleep 0.2
    printf "\033[93m"
    echo "1.Sign in"
    sleep 0.2
    echo "2.Create Account"
    sleep 0.2
    echo "3.Exit"
    printf "\033[0m"
    sleep 0.2
    printf "\033[95m"
    read -p "Enter Your Choice: " choice
    printf "\033[0m"
    case "$choice" in
    1) signin
    ;;
    2) create
    ;;
    3) echo -e "\e[1;31mBye Bye..\e[0m "
    sleep 1
    exit
    ;;
    *)
    invalid
    ;;
    esac
}
index