#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN() {
  echo "Enter your username:"
  read USERNAME

  GET_USERID=$($PSQL "select user_id from users where username='$USERNAME'")
  if [[ -z $GET_USERID ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    INSERT_USER=$($PSQL "insert into users(username, games_played) values('$USERNAME', 0)")
    GET_USERID=$($PSQL "select user_id from users where username='$USERNAME'")
  else
    GAMES_PLAYED=$($PSQL "select games_played from users where user_id=$GET_USERID")
    BEST_GAME=$($PSQL "select best_game from users where user_id=$GET_USERID")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi

  GAME
}

GAME() {
  SECRET_NUMBER=$((1 + $RANDOM % 1000 ))

  TRIES=0
  CORRECT=false
  echo "Guess the secret number between 1 and 1000:"
  while [[ $CORRECT = false ]]
  do
    read GUESS
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
    elif [[ $SECRET_NUMBER = $GUESS ]]
      then
        TRIES=$(($TRIES + 1))
        echo "You guessed it in $TRIES tries. The secret number was $SECRET_NUMBER. Nice job!"
        GAMES_PLAYED=$(($GAMES_PLAYED + 1))
        UPDATE_GAMES_PLAYED=$($PSQL "update users set games_played=$GAMES_PLAYED where user_id=$GET_USERID")
        if [[ -z $BEST_GAME ]]
        then
          UPDATE_BEST_GAME=$($PSQL "update users set best_game=$TRIES where user_id=$GET_USERID")
        else
          if [[ $TRIES -lt $GET_TRIES ]]
          then
            UPDATE_BEST_GAME=$($PSQL "update users set best_game=$TRIES where user_id=$GET_USERID")
          fi
        fi
        CORRECT=true
    elif [[ $SECRET_NUMBER -gt $GUESS ]]
      then
        TRIES=$(($TRIES + 1))
        echo "It's higher than that, guess again:"
    else
      TRIES=$(($TRIES + 1))
      echo "It's lower than that, guess again:"
    fi
  done
}

MAIN