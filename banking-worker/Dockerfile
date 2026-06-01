FROM cgr.dev/chainguard-private/python:3.14-dev AS builder

ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

RUN python -m venv venv
ENV PATH="/app/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM cgr.dev/chainguard-private/python:3.14

WORKDIR /app

COPY --from=builder /app/venv /app/venv
ENV PATH="/app/venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

COPY app.py .

ENTRYPOINT ["python", "app.py"]
