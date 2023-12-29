#!/bin/bash
# Greg Hamelin
#CIT-3205-DE1

echo "Last         First     Job    Old    New    Message"

# assign the input file to each variable
while read INPUT_RECORD; do
    USER_ID=$(echo "$INPUT_RECORD" | cut -d'|' -f1)
    LAST_NAME=$(echo "$INPUT_RECORD" | cut -d'|' -f2)
    FIRST_NAME=$(echo "$INPUT_RECORD" | cut -d'|' -f3)
    JOB=$(echo "$INPUT_RECORD" | cut -d'|' -f4)
    OLD_NICE=$(echo "$INPUT_RECORD" | cut -d'|' -f5)
    PREFERRED_PASSWORD=$(echo "$INPUT_RECORD" | cut -d'|' -f6)
    FULL_NAME="$FIRST_NAME $LAST_NAME"

    # Calculate NEW_NICE 
    if [ "$JOB" == "P" ]; then
        NEW_NICE=3
    elif [ "$JOB" == "S" ]; then
        NEW_NICE=6
    else
        NEW_NICE=7
    fi

    # Check for USER_ID in /home
    if [ ! -d "$USER_ID" ]; then
        ENCRYPTED_PASSWORD=$(echo "P4ssw0rd" | openssl passwd -1 -stdin)
        useradd -m -c "$FULL_NAME" -p "$ENCRYPTED_PASSWORD" "$USER_ID"
        mkdir "/home/$USER_ID/${LAST_NAME}_backup"
        chown "$USER_ID:$USER_ID" "/home/$USER_ID/${LAST_NAME}_backup"
        MESSAGE="$USER_ID created"
    elif [ -d "$USER_ID" ]; then
        MESSAGE="$USER_ID already exists"
    fi

    # use printf to format the output
    printf "%-13s %-10s %-7s %-7s %-7s %-23s\n" "$LAST_NAME" "$FIRST_NAME" "$JOB" "$OLD_NICE" "$NEW_NICE" "$MESSAGE"

done < test3_data.txt
