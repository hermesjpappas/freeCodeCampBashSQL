#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams");

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # get teams information from winner
  if [[ $WINNER != winner ]]
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      # if successful
      if [[ $INSERT_TEAM_RESULT = "INSERT 0 1" ]]
      then
        # echo success, then get ID from that
        echo "SUCCESS: Inserted into teams, $WINNER"
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      fi
    fi
  fi

  # get teams information from opponent
  if [[ $OPPONENT != opponent ]]
  then
    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      # if successful
      if [[ $INSERT_TEAM_RESULT = "INSERT 0 1" ]]
      then
        # echo success, then get ID from that
        echo "SUCCESS: Inserted into teams, $OPPONENT"
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      fi
    fi
  fi


  if [[ $YEAR != year ]]
  then
    # get game id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_id='$WINNER_ID' AND opponent_id='$OPPONENT_ID' AND winner_goals=$WINNER_GOALS AND opponent_goals=$OPPONENT_GOALS")
    # if not found
    if [[ -z $GAME_ID ]]
    then
      # insert game
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      # if successful
      if [[ $INSERT_GAME_RESULT = "INSERT 0 1" ]]
      then
        # echo success, then get ID from that
        echo "SUCCESS: Inserted into games, $YEAR: $WINNER vs $OPPONENT: $WINNER_GOALS - $OPPONENT_GOALS"
        GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_ID='$WINNER_ID' AND opponent_id='$OPPONENT_ID' AND winner_goals=$WINNER_GOALS AND opponent_goals=$OPPONENT_GOALS")
      fi
    fi
  fi

done
