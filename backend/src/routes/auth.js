const express = require('express');

const router = express.Router();

// Hardcoded credentials
const VALID_USERNAME = 'admin';
const VALID_PASSWORD = '1234';

// Simple token generation
const generateToken = (username) => {
  return Buffer.from(`${username}:${Date.now()}`).toString('base64');
};

// Login endpoint
router.post('/login', (req, res) => {
  const { username, password } = req.body;

  // Validate input
  if (!username || !password) {
    return res.status(400).json({
      success: false,
      message: 'Username and password are required',
    });
  }

  // Validate credentials
  if (username === VALID_USERNAME && password === VALID_PASSWORD) {
    const token = generateToken(username);
    return res.status(200).json({
      success: true,
      token,
      username,
      message: 'Login successful',
    });
  }

  // Invalid credentials
  res.status(401).json({
    success: false,
    message: 'Invalid username or password',
  });
});

module.exports = router;
