# Company Management REST API

A simple **CRUD REST API** built while learning backend development with **Spring Boot, JPA, Hibernate, and MySQL**.

The project is used to manage company information such as company name, job profile, duration, stipend, and work-from-home availability.

## 🛠️ Technologies Used

* **Java 17**
* **Spring Boot 4.1.1**
* **Spring Web**
* **Spring Data JPA**
* **Hibernate**
* **MySQL 8**
* **Maven**
* **Postman** for API testing

## 📁 Project Structure

```text
src/main/java/com/Data_Access/demo/
├── DemoApplication.java
├── controller/
│   └── CompanyController.java
├── model/
│   └── Company.java
└── repository/
    └── CompanyRepository.java
```

### Main Components

**Company.java**
Contains the company entity and maps it to the `companies` table in MySQL.

**CompanyRepository.java**
Handles database operations using Spring Data JPA.

**CompanyController.java**
Provides the REST API endpoints for performing CRUD operations.

## 🏢 Company Details

Each company record contains:

| Field          | Type    | Description                         |
| -------------- | ------- | ----------------------------------- |
| `id`           | Integer | Automatically generated ID          |
| `name`         | String  | Company name                        |
| `duration`     | Integer | Duration of the opportunity         |
| `profile`      | String  | Job profile                         |
| `stipend`      | Integer | Stipend amount                      |
| `workFromHome` | Boolean | Whether work from home is available |

The Java field `workFromHome` is stored in MySQL as `work_from_home`.

## 🔗 API Endpoints

The application runs on:

```text
http://localhost:3030
```

| Method   | Endpoint          | What it does                |
| -------- | ----------------- | --------------------------- |
| `GET`    | `/companies/`     | Displays a welcome message  |
| `GET`    | `/companies`      | Gets all companies          |
| `GET`    | `/companies/{id}` | Gets a company by ID        |
| `POST`   | `/companies`      | Adds a new company          |
| `PUT`    | `/companies/{id}` | Updates an existing company |
| `DELETE` | `/companies/{id}` | Deletes a company           |

## 📌 API Examples

### Get All Companies

```http
GET http://localhost:3030/companies
```

Example response:

```json
[
  {
    "name": "TCS",
    "duration": 6,
    "profile": "Java Developer",
    "stipend": 15000,
    "workFromHome": true,
    "id": 1
  },
  {
    "name": "Infosys",
    "duration": 3,
    "profile": "Backend Developer",
    "stipend": 12000,
    "workFromHome": false,
    "id": 2
  }
]
```

### Get a Company by ID

```http
GET http://localhost:3030/companies/1
```

This returns the company whose ID is `1`.

### Add a Company

```http
POST http://localhost:3030/companies
Content-Type: application/json
```

Request body:

```json
{
  "name": "Wipro",
  "duration": 6,
  "profile": "Java Developer",
  "stipend": 18000,
  "workFromHome": true
}
```

The ID is generated automatically by MySQL.

### Update a Company

```http
PUT http://localhost:3030/companies/1
Content-Type: application/json
```

Request body:

```json
{
  "name": "TCS",
  "duration": 8,
  "profile": "Senior Java Developer",
  "stipend": 20000,
  "workFromHome": true
}
```

### Delete a Company

```http
DELETE http://localhost:3030/companies/1
```

If the company exists, it will be removed from the database.

## 🗄️ MySQL Configuration

The application uses a MySQL database named `Data_Access`.

Example `application.properties`:

```properties
server.port=3030

spring.datasource.url=jdbc:mysql://localhost:3306/Data_Access
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

First, create the database in MySQL:

```sql
CREATE DATABASE Data_Access;
```

With:

```properties
spring.jpa.hibernate.ddl-auto=update
```

Hibernate can automatically create or update the required table based on the entity.

## 🧱 Database Table

The `Company` entity maps to a MySQL table called `companies`.

A table similar to this is used:

```sql
CREATE TABLE companies (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255),
    duration INT,
    profile VARCHAR(255),
    stipend INT,
    work_from_home BOOLEAN,
    PRIMARY KEY (id)
);
```

## 🔄 How It Works

The basic flow of the application is:

```text
Client / Postman
       ↓
CompanyController
       ↓
CompanyRepository
       ↓
Spring Data JPA
       ↓
Hibernate
       ↓
MySQL
```

The controller receives the HTTP request and passes the database operation to the repository. Spring Data JPA and Hibernate handle the communication between the Java application and MySQL.

## ▶️ Running the Project

### 1. Clone the repository

```bash
git clone https://github.com/SiliveruSumanth/Company_Data_Access.git
```

Then move into the project directory:

```bash
cd Company_Data_Access
```

### 2. Set up MySQL

Make sure MySQL is running and create the database:

```sql
CREATE DATABASE Data_Access;
```

Then update the database username and password in `application.properties`.

### 3. Start the application

You can run the application using Maven:

```bash
mvn spring-boot:run
```

Or run `DemoApplication.java` directly from IntelliJ IDEA.

### 4. Test the API

Once the application starts, open:

```text
http://localhost:3030/companies
```

You can use **Postman**, IntelliJ HTTP Client, or `curl` to test the different API operations.

## 🔢 About Auto-Increment IDs

The company ID is generated using:

```java
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private Integer id;
```

This means MySQL handles the ID automatically.

For example:

```text
1 → TCS
2 → Infosys
3 → Wipro
```

If company `3` is deleted, the next company may receive ID `4` instead of `3`.

```text
1 → TCS
2 → Infosys
3 → Deleted
4 → New Company
```

This is normal behavior for `AUTO_INCREMENT`. The ID is meant to uniquely identify a record, not to represent the current number of companies.

## ❌ Error Handling

If a company with the requested ID doesn't exist, the API returns:

```text
404 NOT FOUND
```

with the message:

```text
Company not found
```

For example:

```http
GET /companies/999
```

will return a `404` if company `999` does not exist.

## 📚 What I Learned From This Project

This project helped me get hands-on experience with:

* Creating REST APIs using Spring Boot
* Understanding `@RestController` and request mappings
* Implementing CRUD operations
* Connecting Spring Boot with MySQL
* Using Spring Data JPA
* Understanding how Hibernate works with JPA
* Mapping Java entities to database tables
* Sending and receiving JSON data
* Testing APIs using Postman
* Understanding how MySQL `AUTO_INCREMENT` works

## 🚀 Possible Improvements

There are still several things I can add to make the project better:

* Add input validation
* Introduce a service layer
* Add global exception handling
* Add search and filtering
* Add pagination and sorting
* Write unit and integration tests
* Add Swagger/OpenAPI documentation
* Dockerize the application

## 👨‍💻 About the Project

This is a **hands-on learning project** built to understand how a Java backend application communicates with a relational database through REST APIs, JPA, and Hibernate.

It is a small project, but it gave me practical experience with the basic building blocks of backend development.
