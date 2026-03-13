# Design: Initial Project Setup

## Overview

This design outlines the implementation approach for setting up a professional full-stack application with proper development tooling, code quality standards, and a clear path to production deployment.

## Architecture

### Project Structure

```
my-demo-app/
├── backend/
│   ├── src/
│   │   ├── routes/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── db/
│   │   └── middleware/
│   ├── tests/
│   ├── scripts/
│   ├── .env.example
│   ├── .eslintrc.json
│   ├── package.json
│   └── server.js
├── frontend/
│   ├── public/
│   │   └── index.html
│   ├── src/
│   │   ├── components/
│   │   ├── App.jsx
│   │   └── index.js
│   ├── .eslintrc.json
│   └── package.json
├── infrastructure/
│   ├── docker/
│   └── scripts/
├── .gitignore
├── .prettierrc
├── .husky/
│   └── pre-commit
├── package.json (root)
└── README.md
```

## Component Design

### 1. Backend (Node.js/Express)

#### 1.1 Server Entry Point (server.js)

- Initialize Express application
- Configure middleware (cors, body-parser, etc.)
- Set up basic health check route
- Configure port from environment variables
- Error handling middleware
- Database connection initialization (PostgreSQL)

#### 1.2 Database Configuration (src/db/)

- `connection.js`: PostgreSQL connection using pg library
- Connection po
  ",
  "pg": "^8.11.3"
  },
  "devDependencies": {
  "eslint": "^8.50.0",
  "prettier": "^3.0.3",
  "nodemon": "^3.0.1"
  }
  }

````

### 2. Frontend (React)

#### 2.1 Basic React Setup
- Create React App structure (or Vite for modern setup)
- Basic component structure
- Entry point configuration
- Placeholder components for future development

#### 2.2 Dependencies
```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "eslint": "^8.50.0",
    "eslint-plugin-react": "^7.33.2",
    "prettier": "^3.0.3",
    "vite": "^4.4.9"
  }
}
````

### 3. Code Quality Configuration

#### 3.1 ESLint Configuration (.eslintrc.json)

**Backend:**

```json
{
  "env": {
    "node": true,
    "es2021": true
  },
  "extends": ["eslint:recommended"],
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "rules": {
    "no-console": "warn",
    "no-unused-vars": "error",
    "semi": ["error", "always"],
    "quotes": ["error", "single"]
  }
}
```

**Frontend:**

```json
{
  "env": {
    "browser": true,
    "es2021": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:react/jsx-runtime"
  ],
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true
    }
  },
  "plugins": ["react"],
  "rules": {
    "react/prop-types": "warn",
    "no-unused-vars": "error"
  },
  "settings": {
    "react": {
      "version": "detect"
    }
  }
}
```

#### 3.2 Prettier Configuration (.prettierrc)

```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
```

#### 3.3 Prettier Ignore (.prettierignore)

```
node_modules
dist
build
coverage
*.min.js
```

### 4. Git Hooks (Husky)

#### 4.1 Pre-commit Hook

```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

# Run linting
npm run lint

# Run formatting check
npm run format:check
```

#### 4.2 Root package.json Scripts

```json
{
  "scripts": {
    "lint": "npm run lint --workspaces --if-present",
    "format": "prettier --write \"**/*.{js,jsx,json,md}\"",
    "format:check": "prettier --check \"**/*.{js,jsx,json,md}\"",
    "prepare": "husky install"
  }
}
```

### 5. Environment Configuration

#### 5.1 Backend .env.example

```
# Server Configuration
PORT=5000
NODE_ENV=development

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=mydemoapp
DB_USER=postgres
DB_PASSWORD=your_password

# CORS
CORS_ORIGIN=http://localhost:3000
```

### 6. Git Configuration

#### 6.1 .gitignore

```
# Dependencies
node_modules/
package-lock.json
yarn.lock

# Environment
.env
.env.local
.env.*.local

# Build outputs
dist/
build/
*.log

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Testing
coverage/
```

### 7. Documentation

#### 7.1 README.md Structure

1. Project Title and Description
2. Technology Stack
3. Prerequisites
4. Installation Instructions
5. Environment Setup
6. Running the Application
7. Available Scripts
8. Project Structure
9. Development Workflow
10. Code Quality Standards
11. Git Workflow
12. Future Enhancements
13. Contributing Guidelines

## Implementation Approach

### Phase 1: Project Structure

1. Create all directories
2. Initialize Git repository
3. Create .gitignore

### Phase 2: Backend Setup

1. Initialize backend package.json
2. Install dependencies
3. Create server.js with basic Express setup
4. Create database connection module
5. Create .env.example
6. Set up ESLint configuration

### Phase 3: Frontend Setup

1. Initialize frontend with Vite
2. Install React dependencies
3. Create basic component structure
4. Set up ESLint configuration for React

### Phase 4: Code Quality Tools

1. Install Prettier at root level
2. Create .prettierrc configuration
3. Configure ESLint and Prettier integration
4. Add npm scripts for linting and formatting

### Phase 5: Git Hooks

1. Install Husky
2. Initialize Husky
3. Create pre-commit hook
4. Test hook functionality

### Phase 6: Documentation

1. Create comprehensive README.md
2. Document all setup steps
3. Document available scripts
4. Add development workflow guidelines

### Phase 7: Initial Commit

1. Stage all files
2. Run pre-commit checks
3. Create initial commit
4. Prepare for GitHub push

## Testing Strategy

### Manual Testing Checklist

- [ ] Backend server starts without errors
- [ ] Health check endpoint responds correctly
- [ ] ESLint catches code quality issues
- [ ] Prettier formats code correctly
- [ ] Pre-commit hook blocks commits with linting errors
- [ ] Pre-commit hook blocks commits with formatting issues
- [ ] Environment variables load correctly
- [ ] All npm scripts execute successfully

### Validation Commands

```bash
# Backend
cd backend
npm install
npm run lint
npm start

# Frontend
cd frontend
npm install
npm run lint
npm run dev

# Root
npm run lint
npm run format:check
```

## Correctness Properties

### Property 1: Code Quality Enforcement

**Validates: Requirements 3.1, 3.2, 3.3, 4.2, 4.3**

For any code file in the project:

- Running `npm run lint` must either pass or report specific fixable issues
- Running `npm run format:check` must verify all files match Prettier configuration
- ESLint and Prettier rules must not conflict

### Property 2: Project Structure Integrity

**Validates: Requirements 1.1, 1.2, 1.3, 1.4, 1.5**

For the project structure:

- All required directories must exist
- Backend must contain src/ with subdirectories: routes, controllers, services, db, middleware
- Backend must contain tests/ and scripts/ directories
- Frontend must contain proper React structure
- Infrastructure must contain docker/ and scripts/ subdirectories

### Property 3: Git Hook Functionality

**Validates: Requirements 4.1, 4.2, 4.3, 4.4**

For Git operations:

- Pre-commit hook must execute before commit
- Commits with linting errors must be blocked
- Commits with formatting errors must be blocked
- Hook must provide clear error messages

### Property 4: Environment Configuration

**Validates: Requirements 2.3, 2.5**

For environment setup:

- .env.example must document all required variables
- Backend must load environment variables correctly
- Missing required environment variables must cause clear errors

### Property 5: Dependency Resolution

**Validates: Requirements 2.1, 3.1, 3.2, 4.1**

For package management:

- All dependencies must install without conflicts
- npm scripts must execute successfully
- Workspaces (if used) must resolve dependencies correctly

## Security Considerations

1. **Environment Variables**: Never commit .env files
2. **Dependencies**: Use exact versions for production dependencies
3. **CORS**: Configure CORS properly for frontend-backend communication
4. **Database**: Use connection pooling and parameterized queries
5. **.gitignore**: Ensure sensitive files are excluded

## Performance Considerations

1. **Database Connection**: Use connection pooling
2. **Development**: Use nodemon for auto-restart
3. **Frontend**: Use Vite for fast development builds
4. **Linting**: Run only on staged files in pre-commit hook (future optimization)

## Future Enhancements

1. Add ORM (Prisma or Sequelize) when needed
2. Implement Docker containerization
3. Set up CI/CD pipeline
4. Add automated testing (Jest, Vitest)
5. Implement database migrations
6. Add API documentation (Swagger)
7. Set up production deployment workflow
8. Add monitoring and logging

## Dependencies

### Testing Framework

- **Manual testing** for initial setup validation
- **Property-based testing** can be added later for API endpoints

### Package Managers

- npm (primary)
- Workspaces for monorepo management (optional)

## Rollback Strategy

If issues occur during setup:

1. Each phase is independent and can be rolled back
2. Git commits after each phase allow easy rollback
3. Dependencies can be removed by deleting node_modules and package-lock.json
4. Husky can be uninstalled with `npm uninstall husky`

## Success Criteria

The setup is complete when:

1. All directories and files are created
2. Backend server starts successfully
3. Frontend development server starts successfully
4. All linting and formatting checks pass
5. Pre-commit hooks work correctly
6. README.md is comprehensive and accurate
7. Initial commit is ready for GitHub push
8. Project is ready for feature development
