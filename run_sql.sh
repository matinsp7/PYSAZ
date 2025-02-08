#!/bin/zsh

# Database credentials
DB_USER="root"
read -s "DB_PASSWORD?Enter your MariaDB password: "
DB_NAME="PYSAZ"

# Folder structure
SQL_FOLDER="."
SCHEMA_FOLDER="$SQL_FOLDER/schema"
DATA_FOLDER="$SQL_FOLDER/data"

# List of SQL files to execute (in order)
SQL_FILES=(
    "$SCHEMA_FOLDER/create_database.sql"
    "$SCHEMA_FOLDER/create_tables.sql"
    "$SCHEMA_FOLDER/create_triggers.sql"
    "$SCHEMA_FOLDER/create_events.sql"
    "$DATA_FOLDER/insert_data.sql"
)

# Function to execute SQL files
execute_sql_file() {
    local file="$1"
    echo "Executing $file..."
    mariadb -u "$DB_USER" -p"$DB_PASSWORD" < "$file"
    if [ $? -eq 0 ]; then
        echo "Success: $file"
    else
        echo "Error: Failed to execute $file"
        exit 1
    fi
}

# Main script
echo "Starting SQL script execution..."


# Execute each SQL file
for file in "${SQL_FILES[@]}"; do
    execute_sql_file "$file"
done

echo "All SQL files executed successfully!"