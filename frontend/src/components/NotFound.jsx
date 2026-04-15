import React from 'react';
import { Link } from 'react-router-dom';

const NotFound = () => {
  return (
    <div style={{ textAlign: 'center', marginTop: '100px', padding: '20px' }}>
      <h1 style={{ fontSize: '72px', margin: '0' }}>404</h1>
      <h2 style={{ margin: '10px 0' }}>Oops! Page Not Found</h2>
      <p style={{ color: '#666', marginBottom: '30px' }}>
        The page you are looking for doesn't exist or has been moved.
      </p>
      <Link
        to="/"
        style={{
          padding: '10px 20px',
          backgroundColor: '#007bff',
          color: 'white',
          textDecoration: 'none',
          borderRadius: '4px',
        }}
      >
        Go Home
      </Link>
    </div>
  );
};

export default NotFound;
