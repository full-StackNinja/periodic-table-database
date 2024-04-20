#!/bin/bash

PSQL="psql --username=freecodecamp -t -A --dbname=periodic_table -c"

NUMBER_SEARCH(){
  # find element details
  ELEMENT=$($PSQL "SELECT * from elements where atomic_number = $1")
  
  # if element not found
  if [[ -z $ELEMENT ]]
  then
  # exit with message could not find element
  echo "I could not find that element in the database."
  else
  read ATOMIC_NUMBER SYMBOL NAME <<< $(echo "$ELEMENT" | sed 's/|/ /g')
  ELEMENT_PROPS=$($PSQL "SELECT * FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  read ATOMIC_NUMBER ATOMIC_MASS MELT_POINT BOIL_POINT TYPE_ID <<< $(echo "$ELEMENT_PROPS"| sed 's/|/ /g')
  # find type
  ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
  # echo message
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
  fi
}


CHAR_SEARCH(){
    # query by symbol or name
  ELEMENT=$($PSQL "SELECT * from elements where symbol = '$1' OR name = '$1'")
    
  # if element not found
  if [[ -z $ELEMENT ]]
  then
  # exit with message could not find element
  echo "I could not find that element in the database."
  else
  read ATOMIC_NUMBER SYMBOL NAME <<< $(echo "$ELEMENT" | sed 's/|/ /g')
  ELEMENT_PROPS=$($PSQL "SELECT * FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  read ATOMIC_NUMBER ATOMIC_MASS MELT_POINT BOIL_POINT TYPE_ID <<< $(echo "$ELEMENT_PROPS"| sed 's/|/ /g')
  # find type
  ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
  # echo message
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
  fi
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  NUMBER_SEARCH $1
  else
  # argument is a char(s)
    CHAR_SEARCH $1
  fi
fi

