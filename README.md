# Dental Service Spring Boot Web Application

This project is a web application for dental services built using Spring Boot, JavaServer Pages (JSP), and a MySQL database. It provides user management functionality and integrates with a database for storing information about books, categories, and orders.

## Project Structure

```
dental-service-spring
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── example
│   │   │           └── webapp
│   │   │               ├── config
│   │   │               │   └── WebMvcConfig.java
│   │   │               ├── controller
│   │   │               │   └── HomeController.java
│   │   │               ├── model
│   │   │               │   └── User.java
│   │   │               ├── repository
│   │   │               │   └── UserRepository.java
│   │   │               ├── service
│   │   │               │   ├── UserService.java
│   │   │               │   └── UserServiceImpl.java
│   │   │               └── WebApplication.java
│   │   ├── resources
│   │   │   ├── application.properties
│   │   │   ├── ddl.sql
│   │   │   ├── dml.sql
│   │   │   └── static
│   │   │       ├── css
│   │   │       │   └── main.css
│   │   │       └── js
│   │   │           └── main.js
│   │   └── webapp
│   │       ├── META-INF
│   │       └── WEB-INF
│   │           ├── jsp
│   │           │   ├── index.jsp
│   │           │   └── error.jsp
│   │           └── web.xml
│   └── test
│       └── java
│           └── com
│               └── example
│                   └── webapp
│                       └── WebApplicationTests.java
├── Dockerfile
├── docker-compose.yaml
├── pom.xml
└── README.md
```

## Technology Stack

- Backend: Spring Boot 3.x, Spring MVC, Spring Data JPA
- Frontend: JSP, HTML, CSS, JavaScript
- Database: MySQL 8.x
- Build Tool: Maven
- Containerization: Docker, Docker Compose

## Prerequisites

- Docker
- Docker Compose

## Building the Application

1. Clone the repository or download the project files.
2. Navigate to the project directory.

## Running the Application

To build and run the application using Docker, execute the following command:

```bash
docker-compose up --build
```

This command will:

1. Build the Docker image for the Spring Boot application
2. Start the MySQL database container
3. Initialize the database with schema and test data
4. Start the Tomcat server with the deployed application

## Accessing the Application

Once the application is running, you can access it in your web browser at:

```
http://localhost:8080/
```

## Features

- User management (create, read, update, delete)
- Integration with MySQL database
- Custom error handling
- Responsive design using CSS

## License

This project is licensed under the MIT License.