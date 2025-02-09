#!/usr/bin/env fish

# Database credentials
set DB_USER "arya237"
echo "Enter your MariaDB password: "
read DB_PASSWORD
set DB_NAME "PYSAZ"

# Folder structure
set SQL_FOLDER "."
set SCHEMA_FOLDER "$SQL_FOLDER/schema"
set DATA_FOLDER "$SQL_FOLDER/data"

# List of SQL files to execute (in order)
set SQL_FILES \
    "$SCHEMA_FOLDER/create_database.sql" \
    "$SCHEMA_FOLDER/create_tables.sql" \
    "$SCHEMA_FOLDER/create_triggers.sql" \
    "$SCHEMA_FOLDER/create_events.sql" \
    "$DATA_FOLDER/insert_data.sql"

# Function to execute SQL files
function execute_sql_file
    set file $argv[1]
    echo "Executing $file..."
    mariadb -u "$DB_USER" -p"$DB_PASSWORD" < "$file"
    if test $status -eq 0
        echo "Success: $file"
    else
        echo "Error: Failed to execute $file"
        exit 1
    end
end

# Main script
echo "Starting SQL script execution..."

# Execute each SQL file
for file in $SQL_FILES
    execute_sql_file "$file"
end

echo "All SQL files executed successfully!"
