#!/bin/bash
# I give permission for this assignment to be shared with my peers for the purpose of peer evauluation

# this is a simple bash remake of the Google chrome dinosaur game
# this is not a text adventure, i decided to make a different type of game 
# as it says in the specifications it says you can make a different type of game

# VARIABLES 

IFS=''

# delcares height/width of board
declare -i height=$(($(tput lines)-5)) width=$(($(tput cols)-2))

declare -i score=0
declare -i grav_count=0
declare -i difficulty_weight=0

# difficulty array holds to amount of time that game will sleep for with each game loop
declare -a difficulty=(0.04 0.03 0.02 0.01 0.009 0.008 0.007 0.006 0.005 0.004 0.003 0.002 0.001)
declare -i diff_size=$((${#difficulty[@]} - 1))

# colours
no_colour="\e[0m"
green="\e[32;42m"
bright_red="\e[1;31m"

# TRAP variables
#SIG_UP=USR1
#SIG_RIGHT=USR2
#SIG_DOWN=URG
SIG_LEFT=IO
SIG_QUIT=WINCH

declare -i manposY
declare -i manposX
declare -i intro_command

# Bools to check if game should keep running, and whether PC is jumping
run_bool=true 
jump_bool=false 

# Arrays for width, height and where walls are on board
declare -a width_arr
declare -a wall_arr
declare -a height_arr

declare -i direction delta_dir
SIG_JUMP=IO

# sets width array, also sets wall_arr to all false -> no walls
set_arr() {
	for ((i=0; i<=$width; i++)); do
		#tempX=$(($width - $i))
		width_arr[$i]=$i
		wall_arr[$i]=0
	done
	wall_arr[$manposX]=2

	for ((i=0; i<=$height; i++)); do
		height_arr[$i]=0
	done
}

# ---------------------------------------------------------
# DRAWING classes -> draws boards/intro page and display information like score

# quick class that'll echo symbols & draw colour/at that location
draw_across() {
    echo -ne "\e[${1};${2}H$3"
}

# Colours/Draws in board
draw_board() {
	# # Vertical top line
    draw_across 1 1 "$no_colour+"
    draw_across 1 $((width + 2)) "$no_colour+"
    for ((i=2; i<=width+1; i++)); do
        draw_across 1 $i "$no_colour-"
    done

    #move_and_draw 1 $((width + 2)) "$no_colour+$no_colour"
    echo

    # makes game board blank
    for ((i=0; i<height; i++)); do
        draw_across $((i+2)) 1 "$no_colour "
        eval echo -en "\"\${arr$i[*]}\""
        echo -e "$no_colour "
    done

    for ((i=2; i<=height+2; i++)); do
    	for ((j=2; j<=width+1; j++)); do
    	    draw_across $i $j "$no_colour "
    	done
    	#echo
    done
    
    # bottom Line
    for ((i=1; i<=width; i++)); do
        draw_across $((height+2)) $i "$no_colour-$no_colour"
    done

    # Buttons
    upper_text="'F' or 'Spacebar' to Jump | 'Q' to Quit"
    ut_x=$(($width-$width))
    ut_y=$(($height-$height+5))
    draw_across $ut_y $ut_x "$no_colour$upper_text"

    #echo
}

# just adds the upper part of road after
draw_road(){
    for ((i=1; i<=width; i++)); do
        draw_across $((height-1)) $i "$no_colour-$no_colour"
    done    
}

# Displays score while game is running
draw_score() {
    s_x=$(($width-$width))
    s_y=$(($height-$height+8))
	text="Your score: $score   |   Difficulty: $difficulty_weight "
	draw_across $s_y $s_x "$no_colour$text"
}

# Introduction page display, with pressing O to start or I to display more information
intro_page() {
    intro_text="Welcome to my Game"
    intro_text2="Press I for Information or O to Start"

    # locations of where to print
    it1_x=$(($width-$width))
    it1_y=$(($height/2))
    it2_x=$(($it1_x))
    it2_y=$(($it1_y+1))

    draw_across $it1_y $it1_x "$bright_red$intro_text"
    draw_across $it2_y $it2_x "$no_colour$intro_text2"

    read -s -n 1 intro_key
    case "$intro_key" in
            [oO])
                game_process
                ;;
            [iI])
                info_page
                ;;
            esac
}

# Just an in-game display of more information about the game
info_page(){
    draw_board
    echo 
    echo
    echo This is the game I created for the major Network Engineering Assignment
    echo I decided not to make a text based game, as in the assignment specs it says that you can make another kind of game
    echo 
    echo This game is called @er Jump - Pronounced Atter Jump
    echo It just the google chrome dinosaur game, but written in BASH!
    echo You control the @ and your goal is to survive by jumping over the + symbols
    echo 
    echo If the game starts to bug out and print lines saying: kill - no such process 
    echo You can always press q to quit
    echo The game will now close, so re-run the shell script to get the option to play
}

# -----------------------------------------------------
# ENTITIES - and entity movement classes

# The playable charcter, just sets default values
character() {
	# sets character's initial point in height_arr
	manposY=$height
	manposX=15
	height_arr[manposY]=1

	draw_across $manposY $manposX "$no_colour@"
	delta_dir=0
	#tput setf 9

	# Makes terminal prompt under board
	for ((i=manposY; i<=height; i++)); do
		echo
	done

}

# spawns a wall on very right side 
create_wall() {
	if [ "${wall_arr[$width]}" = 0 ]; then
		wall_arr[$width]=1
		draw_across $height $width "$no_colour+"
	fi
}

# moves walls
move_wall(){
	count=0
	for i in "${wall_arr[@]}"; do

		count=$(($count + 1))
		if [ $i = 1 ]; then
			PrevValue=$(($count - 2))
			# if wall needs to be deleted (if behind player) -> prevents buffer overflow
			if [ $count = 3 ]; then
				wall_arr[$PrevValue]=0
				wall_arr[$count]=0
				draw_across $height ${width_arr[$PrevValue + 1]} "$no_colour "
				draw_across $height ${width_arr[$PrevValue]} "$no_colour "				
			else 				
				wall_arr[$PrevValue]=1
				wall_arr[$count]=0
				draw_across $height ${width_arr[$PrevValue + 1]} "$no_colour "
				draw_across $height ${width_arr[$PrevValue]} "$no_colour+"
			fi
		fi
	done
}

# Jumping up movement - when button is pushed
move_character(){
	if [[ "${height_arr[$height]}" -ne 0 ]]; then
		height_arr[$manposY]=0
		draw_across $manposY $manposX "$no_colour "
		manposY=$(($manposY - 1))
		height_arr[$manposY]=1
		draw_across $manposY $manposX "$no_colour@"
	fi
	#echo $manposY
	delta_dir=0
}

# Moves character down from jump
move_down(){
	height_arr[$manposY]=0
	draw_across $manposY $manposX "$no_colour-"
	manposY=$(($manposY + 1))
	height_arr[$manposY]=1
	draw_across $manposY $manposX "$no_colour@"
	#echo $manposY
	delta_dir=0
}

# ---------------------------------------------------------
# GAME RUNNING PROCESSES

# runs both threads in this class
game_process(){
    #draw_board
    #character
    run_game &
    game_pid=$!
    getchar
}

# uses traps to get player button pushes while still moving GUI
getchar() {
    trap "" SIGINT SIGQUIT
    trap "return;" $SIG_DEAD
    while true; do
        read -s -n 1 key
        case "$key" in
            [oO]) # Restarts
                kill -$SIG_QUIT $game_pid
                draw_board
                intro_page
                ;;
            [qQ]) # Quits
                kill -$SIG_QUIT $game_pid
                clear
                echo You have quit the game!
                return
                  ;;
            [fF]) # Jump
            	kill -$SIG_LEFT $game_pid
                ;;
            [' ']) # Jump
                kill -$SIG_LEFT $game_pid
                ;;
       esac
    done
}

# main game loop
run_game(){
    # starts/sets traps
    trap "delta_dir=1;" $SIG_LEFT
    trap "exit 1;" $SIG_QUIT

    draw_board
    character
    draw_road

    # actual game run loop
    while [ "$run_bool" = true ]; do
        score+=1
		draw_score

        # Jump character if button was pushed
        if [ "$delta_dir" -ne 0 ]; then
        	grav_count+=1
      		move_character
        fi

        move_wall

        # collision check
        if [[ "${wall_arr[$manposX]}" = 1 ]] && [[ "${height_arr[$height]}" = 1 ]]; then
        	run_bool=false
        fi

        # Spawns walls at every X interval, constant right now
        if ! (( $score % 50 )); then
        	create_wall
        fi 

        # how fast game runs / difficulty 
        sleep ${difficulty[$difficulty_weight]}

        # every X interval the game will speed up
        if ! (($score % 250)); then
            if (($difficulty_weight < $diff_size)); then
                difficulty_weight=$(($difficulty_weight + 1))
            fi
        fi

        # gravity -> makes player move down after time
        if [[ "$grav_count" > 0 ]]; then
        	grav_count+=1
        fi

        if (( "$grav_count" > 15 )); then
        	move_down
        	grav_count=0
        fi

    done
    clear_game
}

# -----------------------------------------------------------
# game over screen
clear_game() {
    draw_board
    echo
    echo
    echo -e "\e[1;31mGAME OVER\e[0m"
    echo -e "Your score: $score  "
    echo
    echo
    echo -e "Press 'O' to restart or 'Q' to quit"
}


#init_game
draw_board
set_arr
character
intro_page
#run_game &
#game_pid=$!
#getchar

