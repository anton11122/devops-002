FROM python:3-slim

RUN groupadd --gid 10001 app && \
    useradd --create-home --uid 10001 --gid app --home-dir /app app

USER 10001

WORKDIR /app

RUN pip install --upgrade pip

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY . .

EXPOSE 8080

ENTRYPOINT ["python"]

CMD ["/app/flask-app.py"]