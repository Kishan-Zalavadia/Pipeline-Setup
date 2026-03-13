// Verify token middleware
const verifyToken = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({
      success: false,
      message: 'No authorization header provided',
    });
  }

  // Extract token from "Bearer <token>"
  const parts = authHeader.split(' ');
  if (parts.length !== 2 || parts[0] !== 'Bearer') {
    return res.status(401).json({
      success: false,
      message: 'Invalid authorization header format',
    });
  }

  const token = parts[1];

  // Validate token format (simple validation)
  if (!token || token.length === 0) {
    return res.status(401).json({
      success: false,
      message: 'Invalid token',
    });
  }

  try {
    // Decode token to extract username
    const decoded = Buffer.from(token, 'base64').toString('utf-8');
    const [username] = decoded.split(':');

    if (!username) {
      return res.status(401).json({
        success: false,
        message: 'Invalid token format',
      });
    }

    // Attach user info to request
    req.user = { username, token };
    next();
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Token verification error:', error);
    res.status(401).json({
      success: false,
      message: 'Invalid token',
    });
  }
};

module.exports = { verifyToken };
