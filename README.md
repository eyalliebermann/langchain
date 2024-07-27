# LangChain Tutorials

This repository contains Jupyter notebooks for LangChain tutorials and demos.

## Setup

1. Clone this repository:
    ```
    git clone <repository-url>
    cd langchain
    ```

2. Create a `.env` file in the project root and add any necessary environment variables.
    ```
    touch .env
    ```
3. Run the setup script:
    ```
    ./do/execute.notebooks.zsh
    ```
This script will:
- Create a virtual environment
- Install all required dependencies
- Launch Jupyter Notebook

4. When Jupyter Notebook launches, open the desired notebook from the `notebooks` directory.

5. Ensure you select the "langchain.notebooks" kernel when running the notebooks.

## Project Structure

- `do/`: Contains utility scripts
- `notebooks/`: Contains Jupyter notebooks for tutorials and demos
- `requirements.notebooks.txt`: Lists all Python dependencies

## Cheatsheet


'''
source venv.app/bin/activate
uvicorn app.main:app --reload --env-file .env
'''

Browse to [http://localhost:8000/chain/playground/](http://localhost:8000/chain/playground/)
## License

This project is licensed under the MIT License - see the LICENSE.md file for details