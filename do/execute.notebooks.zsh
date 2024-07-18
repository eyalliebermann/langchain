#!/bin/zsh
set -e  # Exit immediately if a command exits with a non-zero status.
set -x  # Print commands and their arguments as they are executed.
echo $SHELL
echo "Executing script: $0 with arguments: $@"


# Get the directory where the script resides
SCRIPT_DIR="$( cd "$( dirname "${(%):-%N}" )" && pwd )"
echo "Script directory: $SCRIPT_DIR"

PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
echo "Project root: $PROJECT_ROOT"

ENV_FILE="$PROJECT_ROOT/.env"
VENV_DIR="$PROJECT_ROOT/venv.notebooks"
REQUIREMENTS_FILE="$PROJECT_ROOT/requirements.notebooks.txt"

# Change directory to the top directory (assuming it's one level up from the script's location)
cd "$PROJECT_ROOT"
echo "Changed directory to project root: $(pwd)"


# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Could not find file: $ENV_FILE.\nExiting..."
    exit 1
fi


# Check if venv exists, if not create it
if [ ! -d "VENV_DIR" ]; then
    echo -e "\n\nCreating a new virtual environment, for app ..."
    python3 -m venv "$VENV_DIR"
fi


# Activate the virtual environment
echo -e "\n\nActivating the virtual environment..."
source "$VENV_DIR/bin/activate"


# Verify we're in the correct environment
if [[ "$VIRTUAL_ENV" != "$VENV_DIR" ]]; then
    echo "Failed to activate the correct virtual environment. Exiting..."
    exit 1
fi

# Register the virtual environment as a Jupyter Notebook kernel
"$VENV_DIR/bin/python" -m ipykernel install --user --name="langchain.notebooks" --display-name="LangChain Notebooks"

# Upgrade pip and install requirements
echo "\nInstalling required dependencies..."
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install --upgrade -r "$REQUIREMENTS_FILE"

# Change to the notebooks directory
cd "$NOTEBOOKS_DIR"

# Run Jupyter Notebook
echo "\nRunning Jupyter Notebook ..."
"$VENV_DIR/bin/jupyter" notebook


