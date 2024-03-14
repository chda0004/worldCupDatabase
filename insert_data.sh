#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
  if [[ $YEAR != 'year' ]] #check for the first line
  then
    #first create the teams, check for the winners
    TEAMS_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    
    if [[ -z $TEAMS_ID_WINNER ]]
    then
      #insert WINNER team
      INSERT_TEAMS_ID_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAMS_ID_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Insertet into teams, $WINNER
        #Get new teams id
        TEAMS_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      fi
    fi
    #Do the same for the opponent
    TEAMS_ID_OP=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    
    if [[ -z $TEAMS_ID_OP ]]
    then
      #insert OP team
      INSERT_TEAMS_ID_OP_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAMS_ID_OP_RESULT == "INSERT 0 1" ]]
      then
        echo Insertet into teams, $OPPONENT
        #Get new teams id
        TEAMS_ID_OP=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      fi

    fi

  #got all the teams data. NOW make the games data

  INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR','$ROUND',$TEAMS_ID_WINNER, $TEAMS_ID_OP, $WINNER_GOALS, $OPPONENT_GOALS)")
    

  fi
done