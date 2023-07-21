FROM python:3.9-slim-buster

WORKDIR /app

COPY . /app

RUN apt-get update && \
    apt-get install -y git && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

# Run dbt when the container launches
CMD ["dbt", "run", "--target". "prod", "--profiles-dir", "."]
