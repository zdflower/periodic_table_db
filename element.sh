#!/bin/bash
# 

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT=$1 # id | nombre | símbolo

# si no hay argumentos
#If you run ./element.sh, it should output only Please provide an element as an argument. and finish running.
if [[ -z $ELEMENT ]]
then
echo "Please provide an element as an argument."

else
    # ver si $ELEMENT es un número, un nombre o un símbolo
    if [[ $ELEMENT =~ ^[0-9]+$ ]] # si es un número
    then
      # pedir la info en la base de datos según corresponda.
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ELEMENT;")

    elif [[ $ELEMENT =~ ^[A-Z]{1}[a-z]{0,1}$ ]] 
      # no es un número, entonces veo si es un símbolo
      # si tiene como máximo 2 caracteres, desde el inicio una mayúscula seguida de 0 o 1 minúscula al final
      then
      
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ELEMENT';")

    else
      # es un nombre
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ELEMENT';")

    fi

    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    TYPE=$($PSQL "SELECT type FROM types FULL JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER;")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    MELTINGP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    BOILINGP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    
    #If the argument input to your element.sh script doesn't exist as an atomic_number, symbol, or name in the database
    if [[ -z $ATOMIC_NUMBER ]]
    then
    echo "I could not find that element in the database."

    else
        OUTPUT_MSG="The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTINGP celsius and a boiling point of $BOILINGP celsius."

        echo "$OUTPUT_MSG"

    fi
fi
