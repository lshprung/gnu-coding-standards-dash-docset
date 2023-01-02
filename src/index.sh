#!/usr/bin/env sh

DB_PATH="$1"
shift

get_title() {
	FILE="$1"

	PATTERN="<title>.*\(GNU Coding Standards\).*</title>"

	#Find pattern in file
	grep -Eo "$PATTERN" "$FILE" | 
		#Remove tag
		sed 's/<[^>]*>//g' | \
		#Remove '(automake)'
		sed 's/(GNU Coding Standards)//g' | \
		#Remove trailing space
		sed 's/[ ]*$//g' | \
		#Replace '&amp' with '&'
		sed 's/&amp/&/g'
}

insert() {
	NAME="$1"
	TYPE="$2"
	PAGE_PATH="$3"

	sqlite3 "$DB_PATH" "INSERT INTO searchIndex(name, type, path) VALUES (\"$NAME\",\"$TYPE\",\"$PAGE_PATH\");"
}

# Create table
sqlite3 "$DB_PATH" "CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
sqlite3 "$DB_PATH" "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"

# Get title and insert into table for each html file
while [ -n "$1" ]; do
	unset PAGE_NAME
	PAGE_NAME="$(get_title "$1")"
	if [ -n "$PAGE_NAME" ]; then
		insert "$PAGE_NAME" "Guide" "$(basename "$1")"
	fi
	shift
done
