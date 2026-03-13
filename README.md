# My Demo App

A professional full-stack application built with Node.js/Express backend, React
frontend, and PostgreSQL database.

## Technology Stack

- **Backend**: Node.js, Express.js
- **Frontend**: React 18, Vite
- **Database**: PostgreSQL
- **Code Quality**: ESLint, Prettier
- **Git Hooks**: Husky

## Prerequisites

- Node.js (v16 or higher)
- npm (v8 or higher)
- PostgreSQL (v12 or higher)

## Installation

### 1. Clone the repository

```bash
git clone <repository-url>
cd my-demo-app
```

### 2. Install dependencies

```bash
npm install
```

This will install dependencies for both backend and frontend using npm workspaces.

### 3. Setup environment variables

#### Backend

```bash
cp backend/.env.example backend/.env
```

Edit `backend/.env` with your configuration:

```
PORT=5000
NODE_ENV=development
DB_HOST=localhost
DB_PORT=5432
DB_NAME=mydemoapp
DB_USER=postgres
DB_PASSWORD=your_password
CORS_ORIGIN=http://localhost:3000
```

## Running the Application

### Development Mode

#### Backend

```bash
cd backend
npm run dev
```

The backend server will start on `http://localhost:5000`

#### Frontend

```bash
cd frontend
npm run dev
```

The frontend development server will start on `http://localhost:3000`

### Production Build

#### Backend

```bash
cd backend
npm start
```

#### Frontend

```bash
cd frontend
npm run build
npm run preview
```

## Available npm Scripts

### Root Level

- `npm run lint` - Run ESLint on all workspaces
- `npm run format` - Format all files with Prettier
- `npm run format:check` - Check if files are formatted correctly

### Backend

- `npm run dev` - Start backend in development mode with # Request handlers
  │ │ ├── services/ # Business logic
  │ │ ├── db/ # Database configuration
  │ │ └── middleware/ # Express middleware
  │ ├── tests/ # Test files
  │ ├── scripts/ # Utility scripts
  │ ├── server.js # Entry point
  │ ├── package.json
  │ └── .env.example
  ├── frontend/
  │ ├── src/
  │ │ ├── components/ # React components
  │ │ ├── App.jsx
  │ │ └── main.jsx
  │ ├── public/
  │ │ └── index.html
  │ ├── vite.config.js
  │ └── package.json
  ├── infrastructure/
  │ ├── docker/ # Docker configuration
  │ └── scripts/ # Infrastructure scripts
  ├── .gitignore
  ├── .prettierrc
  ├── .prettierignore
  ├── package.json # Root workspace configuration
  └── README.md

````

## Development Workflow

### 1. Create a feature branch

```bash
git checkout -b feature/your-feature-name
````

### 2. Make your changes

- Write code following the project standards
- Ensure code passes linting and formatting checks

### 3. Pre-commit checks

Before committing, the pre-commit hook will automatically:

- Run ESLint on all files
- Check code formatting with Prettier

If checks fail, fix the issues and try committing again.

### 4. Commit your changes

```bash
git add .
git commit -m "feat: description of your changes"
```

### 5. Push and create a pull request

```bash
git push origin feature/your-feature-name
```

## Code Quality Standards

### ESLint

ESLint is configured to enforce code quality standards:

- **Backend**: Node.js environment with recommended rules
- **Frontend**: React environment with React-specific rules

Run linting:

```bash
npm run lint
```

Fix issues automatically:

```bash
npm run lint:fix
```

### Prettier

Prettier ensures consistent code formatting across the project.

Configuration:

- Semi-colons: enabled
- Single quotes: enabled
- Print width: 80 characters
- Tab width: 2 spaces

Format all files:

```bash
npm run format
```

Check formatting:

```bash
npm run format:check
```

## Git Hooks

### Pre-commit Hook

The pre-commit hook runs automatically before each commit to ensure code quality:

1. Runs ESLint on all files
2. Checks code formatting with Prettier

If any checks fail, the commit is blocked. Fix the issues and try again.

## API Endpoints

### Health Check

- **GET** `/health` - Returns server status

Response:

```json
{
  "status": "OK",
  "message": "Server is running"
}
```

## Database Setup

### PostgreSQL Connection

The backend uses the `pg` library for PostgreSQL connections. Connection
configuration is loaded from environment variables.

To set up the database:

1. Create a PostgreSQL database
2. Update `.env` with your database credentials
3. Run any migrations (when implemented)

## Future Enhancements

- [ ] Add ORM (Prisma or Sequelize)
- [ ] Implement Docker containerization
- [ ] Set up CI/CD pipeline
- [ ] Add automated testing (Jest, Vitest)
- [ ] Implement database migrations
- [ ] Add API documentation (Swagger)
- [ ] Set up production deployment workflow
- [ ] Add monitoring and logging

## Contributing

1. Follow the development workflow
2. Ensure all code passes linting and formatting checks
3. Write clear commit messages
4. Create pull requests with detailed descriptions

## License

ISC

## Support

For issues or questions, please create an issue in the repository.
