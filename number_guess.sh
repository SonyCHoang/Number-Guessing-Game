#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN() {
  echo "Enter your username:"
  read USERNAME

  GET_USERNAME=$($PSQL "select user_id from users where username=$GET_USERNAME")
  if [[ -z $GET_USERNAME ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
}