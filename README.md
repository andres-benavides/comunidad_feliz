# API Comunidad – Rails + PostgreSQL

Proyecto Rails con endpoints para usuarios, libros y reseñas, siguiendo buenas prácticas (TDD, servicios para lógica de dominio y serializers) y empaquetado con Docker Compose.

## Estructura (alto nivel)

- app/models – User, Book, Review
- app/services/reviews/create_review.rb – servicio para crear reseñas
- app/services/book_rating_calculator_spec.rb – calcular calificacion de libros
- app/serializers – UserSerializer, BookSerializer, ReviewSerializer
- app/controllers/api/v1 – endpoints JSON
- spec/requests – tests de API
- spec/services – tests de servicios

## Requisitos

- Docker
- Docker Compose

## Inicialización del proyecto

Ejecuta el script para construir contenedores, crear/migrar la base de datos y cargar seeds.

Asegúrate de darle permisos de ejecución:

```bash
chmod +x init_project.sh
./init_project.sh
```

Este script ejecuta:

- docker compose up -d --build
- rails db:create db:migrate db:seed dentro del contenedor api_comunidad

Nota de puertos: en docker-compose.yml se recomienda publicar el puerto del contenedor para acceder desde el host. Por ejemplo:

```yaml
ports:
  - "3005:3005"
```

Con ese mapeo, la base URL es: http://localhost:3005

## Iniciar el servidor

Puedes usar el script para levantar el servidor

Asegúrate de darle permisos de ejecución:

```bash
chmod +x init_project.sh
./start_project.sh
```

o ejecutar:

```bash
docker compose up -d
```

## Endpoints

Base URL por defecto: http://localhost:3005

- GET /api/v1/users
- GET /api/v1/books
- GET /api/v1/reviews
- POST /api/v1/reviews

Cuerpo JSON de ejemplo para crear reseña:

```json
{
  "review": {
    "user_id": "UUID_USER",
    "book_id": "UUID_BOOK",
    "rating": 5,
    "content": "Great book"
  }
}
```

### Pruebas rápidas con cURL

```bash
curl -s http://localhost:3005/api/v1/users
curl -s http://localhost:3005/api/v1/books
curl -s http://localhost:3005/api/v1/reviews
curl -s -X POST http://localhost:3005/api/v1/reviews   -H "Content-Type: application/json"   -d '{"review":{"user_id":"<UUID_USER>","book_id":"<UUID_BOOK>","rating":5,"content":"Great book"}}'
```

O dentro del proyecto hay una coleccion de postman para probar los endpoints comunidad_feliz.postman_collection.json

## Seeds

db/seeds.rb crea 3 usuarios y 3 libros para comenzar a crear reseñas. Puedes ejecutarlo manualmente si lo necesitas:

```bash
docker compose exec api_comunidad bin/rails db:seed
```

## Pruebas automatizadas

Las pruebas, con el contenedor levantado, se ejecutan con el script:

```bash
chmod +x run_test.sh
./run_test.sh
```

o puedes ejecutar el comando

```bash
docker compose exec api_comunidad bundle exec rspec
```

Incluye specs de requests, services y models.

## Tecnologías

- Ruby on Rails
- PostgreSQL
- RSpec
- Docker y Docker Compose
