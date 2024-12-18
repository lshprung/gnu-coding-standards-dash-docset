#!/usr/bin/env sh

# shellcheck source=../../../scripts/create_table.sh
. "$(dirname "$0")"/../../../scripts/create_table.sh
# shellcheck source=../../../scripts/get_title.sh
. "$(dirname "$0")"/../../../scripts/get_title.sh
# shellcheck source=../../../scripts/insert.sh
. "$(dirname "$0")"/../../../scripts/insert.sh

DB_PATH="$1"
shift

#get_title() {
#	FILE="$1"
#
#	PATTERN="<title>.*\(GNU Coding Standards\).*</title>"
#
#	#Find pattern in file
#	grep -Eo "$PATTERN" "$FILE" | 
#		#Remove tag
#		sed 's/<[^>]*>//g' | \
#		#Remove '(automake)'
#		sed 's/(GNU Coding Standards)//g' | \
#		#Remove trailing space
#		sed 's/[ ]*$//g' | \
#		#Replace '&amp' with '&'
#		sed 's/&amp/&/g'
#}

insert_pages() {
	# Get title and insert into table for each html file
	while [ -n "$1" ]; do
		unset PAGE_NAME
		PAGE_NAME="$(get_title "$1" | sed 's/(GNU Coding Standards)//g')"
		if [ -n "$PAGE_NAME" ]; then
			insert "$DB_PATH" "$PAGE_NAME" "Guide" "$(basename "$1")"
		fi
		shift
	done
}

create_table "$DB_PATH"
insert_pages "$@"
