# Imagen base ligera y con parches al día
FROM python:3.12-slim

# No escribir .pyc, salida sin buffer
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=5000

WORKDIR /app

# Instalar dependencias primero para aprovechar la cache de capas
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar la aplicación
COPY app.py .

# Crear y usar un usuario sin privilegios (no ejecutar como root)
RUN adduser --disabled-password --gecos "" --uid 10001 appuser \
    && chown -R appuser:appuser /app
USER 10001

EXPOSE 5000

# Servidor WSGI de producción (nunca `python app.py` con debug en prod)
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:${PORT} --workers 2 --timeout 30 app:app"]
