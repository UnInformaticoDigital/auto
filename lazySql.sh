#!/bin/bash

banner() {
	
	
echo ' 	██▓    ▄▄▄      ▒███████▒▓██   ██▓  ██████   █████   ██▓    
	▓██▒   ▒████▄    ▒ ▒ ▒ ▄▀░ ▒██  ██▒▒██    ▒ ▒██▓  ██▒▓██▒    
	▒██░   ▒██  ▀█▄  ░ ▒ ▄▀▒░   ▒██ ██░░ ▓██▄   ▒██▒  ██░▒██░    
	▒██░   ░██▄▄▄▄██   ▄▀▒   ░  ░ ▐██▓░  ▒   ██▒░██  █▀ ░▒██░    
	░██████▒▓█   ▓██▒▒███████▒  ░ ██▒▓░▒██████▒▒░▒███▒█▄ ░██████▒
	░ ▒░▓  ░▒▒   ▓▒█░░▒▒ ▓░▒░▒   ██▒▒▒ ▒ ▒▓▒ ▒ ░░░ ▒▒░ ▒ ░ ▒░▓  ░
	░ ░ ▒  ░ ▒   ▒▒ ░░░▒ ▒ ░ ▒ ▓██ ░▒░ ░ ░▒  ░ ░ ░ ▒░  ░ ░ ░ ▒  ░
	░ ░    ░   ▒   ░ ░ ░ ░ ░ ▒ ▒ ░░  ░  ░  ░     ░   ░   ░ ░   
		░  ░     ░  ░  ░ ░     ░ ░           ░      ░        ░  ░
					░         ░ ░     
	'

}

menu() {
	echo "  ____________________________________________________________________________"
	echo ""
	banner
	echo "  ____________________________________________________________________________"
	echo ""
	echo "		1) CREATE DBS"
	echo ""
	echo "		2) CREATE TABLES"
	echo ""
	echo "		3) INSERT DATA"
	echo ""
	echo "		3) EXIT"
	read ch
	case $ch in
		1)createdb;;
		2)createtable;;
		3)insertData;;
		4)exit 0;;
		*) echo "INVALID OPTION"
	esac
}

askDb() {
    echo ""
    echo "Input db name"
    echo "------------------"
    read dbName
    echo "x---x---x---x---x---x"
}

#TAB NAME
askTab() {
    echo ""
    echo "Input table name"
    echo "------------------"
    read tbName
    echo "x---x---x---x---x---x"
}
# USER DATA
askUser() {
    echo ""
    echo "Input user name"
    echo "------------------"
    read user
    echo "x---x---x---x---x---x"
    #echo "Input pwwd"
    #read -s -p pwwd
}

createdb(){
    echo "#########################"
    askDb
    newDbQy="create database $dbName;"
    echo ""
    echo "---"
    echo "sql> $newDbQy"
    echo "---"
	echo "" >> lazySql.log
	echo "NEW DB" >> lazySql.log
	echo $newDbQy >> lazySql.log
	echo ""
    mysql -u $user -p -h localhost -e "$newdbQuery"
    echo ""
    echo "> CREATE TABLES NOW ? y/n"
    read ch
    if [ $ch = "y" ]; then
        createtable
    else
        menu
    fi
}

createtable() {
    echo "++++++++++++++++++++++++++++++++"
    askDb
	askTab
    echo "-----------------------------"
    echo "Nº FIELDS:"
    read nfields
    echo ""
    i=1
    
    while [ $i -le $nfields ]
    do
        echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
		echo "FIELD nº $i NAME"
        read field
        echo ""
        echo "- - - - - - - - - - - - - - - - "
        
        echo "DATA TYPE & CHARS:"
        read datatype
        echo ""
        if [ $i -eq 1 ]; then
                fields="$field $datatype"
        elif [ $i -gt 1 ] || [ $i -eq $nfields ]; then
                fields="$fields , $field $datatype"
        fi
        
        i=$((i+1))      
     
     
     done
     key
     newtable="create table $tbname ($fields);"
     echo "----"
     echo "sql> $newtable"
	 echo "----"
	 echo "- - - - - - - " >>lazySql.log
	 echo "  NEW TABLE " >> lazySql.log
	 echo ""
     echo "$newtable" >> lazySql.log
	 mysql -u admin -p  $dbName -h localhost -e "$newtable"
     echo "MORE TABLES ? y/n"
     read ch
     if [ "$ch" = "y" ]; then
        createtable
     else
        menu
    fi
         
}
primary() {
	echo ""
    echo "PRIMARY KEY FIELD:"
    read keyfield
    fields="$fields , primary key($keyfield)"
}

foreign() {
	echo ""
    echo "FOREIGN KEY FIELD:"
    read keyfield
	echo ""
    echo "TABLE REFERENCE"
	read tableref
	echo ""
    echo "FIELD REFERENCE"
	read fieldref
	echo ""
    fields="$fields , foreign key($keyfield) references $tableref($fieldref)"
}

key(){
    
     echo "HOW MANY KEYS?"
     read nkeys
     i=1
     echo ""
     while [ $i -le $nkeys ]
     do
            echo "1) Primary key"
            echo "2) Foreign key"
            read ch2
            case $ch2 in
                1)primary;;
                2)foreign;;
                *)exit 0;;
            esac
            i=$((i+1))
        
     done
}  


insertData() {
	guessTbFieldsQy
	useGuessedF
	askInsert
}

# GET FIELD NAMES
guessTbFieldsQy() {
    askDb
    askTab
    askUser
    mysql -u $user -p $dbName -e "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '$tbName';" >  fields.txt
	echo "Desire to know field data types? | y/n|"
	read ch
	if [ "$ch" = "y" ]; then
		guessTbFieldsTypeQy
	elif [ "$ch" = "n" ]; then
		echo ""
	else
		echo ""
	fi	
	
}

guessTbFieldsTypeQy() {
	mysql -u $user -p $dbname -e "SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '$tbName';" > fieldTypes.txt
	i=0
	while IFS= read -r line
	do
		if (( $i == 1)); then
			fType="$line"
		
			fTypes=($fType)
		elif (( $i > 1 )); then
			fType="$line"
		
			fTypes+=($fType)
		else
			echo ""
		fi
		i=$(($i + 1))
	done < fieldTypes.txt
	rm fieldTypes.txt
}

# GET FIELDS ARRAY & FIELDS SQL SYNTAX
useGuessedF() {
    i=0
	while IFS= read -r line
	 do
	#echo "i = $i"
     #   echo "line & i ::: $line & $i" 
		if (($i == 1 )); then
			field="$line "
			#echo "Field$i= $field"
            tbFields="$field"
			tbFieldz=($tbFields)
            #echo "FIELDS = $tbFields"
        elif (($i > 1 )); then
            field="$line"
            #echo "Field$i= $field"
            tbFieldz+=($field)
            tbFields="$tbFields, $field"
            #echo "FIELDS = $tbFields"
            #echo "FIELDZ = ${tbFieldz[*]}"
        else
            echo ""
		fi
        i=$(($i + 1))
     
          
        z=$i
       
    done <  fields.txt
	rm fields.txt

}

# GET FIELD CONTENT SQL SYNTAX 
askInsert() {
    y=0
	echo "---------------------------------------"
    echo "- - - A S K - - C O N T E N T S - - - "
    echo "DataTypes:: "${fTypes[@]}
    i=1
    for field in "${tbFieldz[@]}"
	do
        if (($i == 1 )); then
            echo "------"
            echo "FIELD$i:  $field  || INPUT "
			
            echo "------"
            read fXCont
            fieldsContents="$fXCont"
        elif (($i > 1 )); then
			zzz="fTypes[$z]"
            echo "------"
            echo "FIELD$i:  $field  || INPUT "
		
            echo "------"
            read fXCont
            fieldsContents="$fieldsContents, $fXCont"
      
        else
            echo ""
		fi
        
       
        i=$(($i + 1))
		z=$(($z + 1))
		
    done
     insertQy="insert into $tbName ($tbFields) values ($fieldsContents);"
    echo "--------------------------"
     echo "sql> $insertQy"
    echo "--------------------------"
    mysql -u $user -p $dbName -e "$insertQy"
}





menu




