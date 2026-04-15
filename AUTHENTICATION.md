# Authentication System

## Overview

This application implements a professional authentication system with:

- **Backend**: Simple token-based authentication with hardcoded credentials
- **Frontend**: React Router for separate login and welcome pages
- **Storage**: sessionStorage for secure token management
- **Security**: Proper route protection and session management

## Features

### 1. Login Page

- Username and password input fields
- Error message display for invalid credentials
- Demo credentials: `admin` / `1234`
- Automatic redirect to welcome page on successful login

### 2. Welcome Page

- Displays authenticated username
- Logout button to end session
- Protected route - only accessible when authenticated
- Automatic redirect to login page when logging out

### 3. Session Management

- Tokens stored in sessionStorage (cleared on browser close)
- Automatic session restoration on page reload
- Secure token validation on backend

## Running the Application

### Prerequisites

- Node.js v16 or higher
- npm v8 or higher

### Installation

```bash
npm install
```

This installs dependencies for both backend and frontend using npm workspaces.

### Development Mode

Run both backend and frontend servers in parallel:

```bash
npm run dev
```

This command:

- Starts backend on `http://localhost:5050`
- Starts frontend on `http://localhost:3000`
- Both servers run in parallel with auto-reload

### Manual Server Startup (if needed)

**Backend only:**

```bash
cd backend
npm run dev
```

**Frontend only:**

```bash
cd frontend
npm run dev
```

## API Endpoints

### Authentication

#### Login

- **Endpoint**: `POST /auth/login`
- **Request Body**:
  ```json
  {
    "username": "admin",
    "password": "1234"
  }
  ```
- **Success Response** (200):
  ```json
  {
    "success": true,
    "token": "YWRtaW46MTc3MzQwMTA2MjM5Nw==",
    "username": "admin",
    "message": "Login successful"
  }
  ```
- **Error Response** (401):
  ```json
  {
    "success": false,
    "message": "Invalid username or password"
  }
  ```

## Frontend Routes

- `/login` - Login page (public)
- `/welcome` - Welcome page (protected)
- `/` - Redirects to `/welcome`

## Authentication Flow

### Login Flow

1. User enters credentials on login page
2. Frontend sends POST request to `/auth/login`
3. Backend validates credentials against hardcoded values
4. On success:
   - Backend returns token
   - Frontend stores token in sessionStorage
   - Frontend redirects to welcome page
5. On failure:
   - Backend returns error message
   - Frontend displays error on login page

### Protected Route Flow

1. User tries to access `/welcome`
2. ProtectedRoute component checks sessionStorage for token
3. If token exists:
   - User is allowed to access welcome page
4. If token doesn't exist:
   - User is redirected to login page

### Logout Flow

1. User clicks logout button on welcome page
2. Frontend clears sessionStorage
3. Frontend redirects to login page
4. Session is ended

## Security Considerations

### Current Implementation

- Tokens stored in sessionStorage (cleared on browser close)
- Simple token format for development
- CORS enabled for frontend origin
- Basic error messages to prevent information leakage

### Future Improvements

- Implement JWT tokens
- Add refresh token mechanism
- Use httpOnly cookies for token storage
- Implement password hashing
- Add rate limiting on login endpoint
- Add audit logging
- Implement multi-factor authentication

## Testing Credentials

**Username**: `admin`
**Password**: `1234`

## Code Quality

### Pre-commit Hooks

- ESLint runs on every commit
- Prettier formatting check runs on every commit
- Commits are blocked if checks fail

### Pre-build Hooks

- ESLint runs before build
- Prettier check runs before build
- Build fails if code quality issues exist

### Running Checks Manually

```bash
# Lint code
npm run lint

# Format code
npm run format

# Check formatting
npm run format:check

# Build frontend
npm run build
```

## Troubleshooting

### Backend not starting

- Check if port 5050 is available
- Verify Node.js is installed: `node --version`
- Check for errors in backend logs

### Frontend not starting

- Check if port 3000 is available
- Verify React dependencies are installed
- Clear node_modules and reinstall: `rm -rf node_modules && npm install`

### Login not working

- Verify backend is running on port 5050
- Check browser console for errors
- Verify credentials: admin / 1234
- Check CORS settings in backend

### Token not persisting

- Verify sessionStorage is enabled in browser
- Check browser console for errors
- Note: sessionStorage is cleared when browser closes

## Development Workflow

1. Create a feature branch
2. Make changes to backend or frontend
3. Run linting and formatting checks
4. Test the application
5. Commit changes (pre-commit hooks will run)
6. Push to repository

## File Structure

```
my-demo-app/
├── backend/
│   ├── src/
│   │   ├── routes/
│   │   │   └── auth.js          # Authentication routes
│   │   ├── middleware/
│   │   │   └── auth.js          # Token verification middleware
│   │   └── db/
│   ├── server.js                # Express server entry point
│   └── package.json
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Login.jsx        # Login page component
│   │   │   └── Welcome.jsx      # Welcome page component
│   │   ├── context/
│   │   │   └── AuthContext.jsx  # Authentication context
│   │   ├── App.jsx              # Main app with routing
│   │   └── main.jsx
│   └── package.json
├── package.json                 # Root workspace configuration
└── README.md
```

## Next Steps

1. Add database integration (PostgreSQL)
2. Implement password hashing
3. Add user registration
4. Implement JWT tokens
5. Add refresh token mechanism
6. Add role-based access control
7. Implement audit logging
8. Add multi-factor authentication
