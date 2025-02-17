#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN() {
  echo "Enter your username:"
  read USERNAME

  GET_USERNAME=$($PSQL "select user_id from users where username=$GET_USERNAME")
  if [[ -z $GET_USERNAME ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    INSERT_USERNAME=$($PSQL "insert into users(username) values($USERNAME)")
  else
    GAMES_PLAYED=$($PSQL "select games_played from users where user_id=$GET_USERNAME")
    BEST_GAME=$($PSQL "select best_game from users where user_id=$GET_USERNAME")
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