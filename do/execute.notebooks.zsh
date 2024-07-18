#!/bin/zsh
set -e  # Exit immediately if a command exits with a non-zero status.
#set -x  # Print commands and their arguments as they are executed.
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
GITATTRIBUTES_FILE="$PROJECT_ROOT/.gitattributes"


# Change directory to the top directory
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

# Add nbstripout to requirements if not already present
if ! grep -q "nbstripout" "$REQUIREMENTS_FILE"; then
    echo "nbstripout" >> "$REQUIREMENTS_FILE"
    echo "Added nbstripout to $REQUIREMENTS_FILE"
fi

# Upgrade pip and install requirements
echo "\nInstalling required dependencies..."
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install --upgrade -r "$REQUIREMENTS_FILE"

# Set up nbstripout in git
"$VENV_DIR/bin/nbstripout" --install


# Update .gitattributes
if [[ ! -f "$GITATTRIBUTES_FILE" ]]; then
    echo "*.ipynb filter=nbstripout" > "$GITATTRIBUTES_FILE"
    echo "*.ipynb diff=ipynb" >> "$GITATTRIBUTES_FILE"
    echo "Created $GITATTRIBUTES_FILE with nbstripout configuration"
else
    if ! grep -q "filter=nbstripout" "$GITATTRIBUTES_FILE"; then
        echo "*.ipynb filter=nbstripout" >> "$GITATTRIBUTES_FILE"
        echo "Added nbstripout filter to $GITATTRIBUTES_FILE"
    fi
    if ! grep -q "diff=ipynb" "$GITATTRIBUTES_FILE"; then
        echo "*.ipynb diff=ipynb" >> "$GITATTRIBUTES_FILE"
        echo "Added ipynb diff to $GITATTRIBUTES_FILE"
    fi
fi

# Verify nbstripout installation
if "$VENV_DIR/bin/nbstripout" --is-installed; then
    echo "nbstripout has been successfully set up for this project."
else
    echo "Error: nbstripout installation failed."
    exit 1
fi


# Change to the notebooks directory
cd "$PROJECT_ROOT/notebooks"

# Run Jupyter Notebook
echo "\nRunning Jupyter Notebook ..."
"$VENV_DIR/bin/jupyter" notebook