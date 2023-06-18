FROM --platform=linux/amd64 python:3.9-alpine3.18

WORKDIR /app2

COPY . .

RUN pip3 install -r requirements.txt

CMD ["python3", "-u", "main.py"]