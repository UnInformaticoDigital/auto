#!/bin/bash

menu() {
	echo "  ________________________________________________________________________________"
	echo ""
	echo "	    	L A Z Y   S Q L 	"	
	echo "  _______________________________________________________________________________"
	echo ""
	echo "		1) CREATE DBS"
	echo ""
	echo "		2) CREATE TABLES"
	echo ""
	echo "		3) EXIT"
	read ch
	case $ch in
		1)createdb;;
		2)createtable;;
		3)exit 0;;
		*) echo "INVALID OPTION"
	esac
}

createdb(){
    echo "#########################"
    echo "DATABASE NAME:"
    read dbname
    echo ""
    mysql -u admin -p -h localhost -e 'create database $dbname;'
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
    echo "DB NAME:"
    read dbname
    echo ""
    echo "- - - - - - - - - - -"
    echo "TABLE NAME?"
    read tbname
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
        fieldx="$field$(echo $i)"
        echo "- - - - - - - - - - - - - - - - "
        
        echo "DATA TYPE & CHARS:"
        read datatype
        echo ""
        if [ $i -eq 1 ]; then
                fields="$fieldx $datatype"
        elif [ $i -gt 1 ] || [ $i -eq $nfields ]; then
                fields="$fields , $fieldx $datatype"
        fi
        
        i=$((i+1))      
     
     
     done
     key
     query="create table $tbname ($fields);"
     echo $query
     mysql -u admin -p -h localhost -e "use $dbname; $query"
     echo "MORE TABLES ? y/n"
     read ch
     if [ $ch = y ]; then
        createtable
     else
        menu
    fi
         
}
primary() {
    echo "PRIMARY KEY FIELD:"
    read keyfield
    fields="$fields , primary key($keyfield)"
    echo "$fields"
    echo ""
}

foreign() {
    echo "FOREIGN KEY FIELD:"
    read keyfield
    echo "TABLE REFERENCE"
    read tableref
    echo "FIELD REFERENCE"
    read fieldref
    fields="$fields , foreign key($keyfield) references $tableref($fieldref)"
    echo "$fields"
    echo ""
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
    
menu




