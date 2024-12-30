git pull
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
mkdocs build -d site --use-directory-urls
