#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#read user input
USER_INPUT=$1

NOT_FOUND_MESSAGE () {
  echo "I could not find that element in the database."
}

if [[ -z $USER_INPUT ]]
then
  echo "Please provide an element as an argument."
else
  #check if USER_INPUT is a integer
  if [[ $USER_INPUT =~ ^-?[0-9]+$ ]]
  then
    #check for atomic_number in the database
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$USER_INPUT")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      #output element not found message
      NOT_FOUND_MESSAGE
    else
      #using atomic_number output (name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius)
      ATOMIC_INFO_OUTPUT=$($PSQL "SELECT name, symbol,type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
      echo $ATOMIC_INFO_OUTPUT | while IFS='|' read NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
      do
        #output message
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  else
    #check length of string
    if [ ${#USER_INPUT} -le 2 ];
    then
      #check for symbol in elements database
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$USER_INPUT'")
      if [[ -z $SYMBOL ]]
      then
        #output element not found message
        NOT_FOUND_MESSAGE
      else
        #using atomic_number output (name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius)
        SYMBOL_INFO_OUTPUT=$($PSQL "SELECT atomic_number, name,type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$SYMBOL'")
        echo $SYMBOL_INFO_OUTPUT | while IFS='|' read ATOMIC_NUMBER NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
        do
          #output message
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
        done
      fi

    else
      #check for name in elements database
      NAME=$($PSQL "SELECT name FROM elements WHERE name='$USER_INPUT'")
      if [[ -z $NAME ]]
      then
        #output element not found message
        NOT_FOUND_MESSAGE
      else
        #using atomic_number output (name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius)
        NAME_INFO_OUTPUT=$($PSQL "SELECT atomic_number, symbol,type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$NAME'")
        echo $NAME_INFO_OUTPUT | while IFS='|' read ATOMIC_NUMBER SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
        do
          #output message
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
        done
      fi
    fi
  fi
fi