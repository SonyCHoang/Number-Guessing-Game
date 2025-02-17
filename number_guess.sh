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
    GAMES_PLAYED=$($PSQL "select games_played from users where user_id=$GET_USERNAME")
    BEST_GAME=$($PSQL "select best_game from users where user_id=$GET_USERNAME")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
}