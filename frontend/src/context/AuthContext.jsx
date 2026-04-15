import React, { createContext, useState, useEffect } from 'react';

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [auth, setAuth] = useState(null);
  const [loading, setLoading] = useState(true);

  // Restore auth state from sessionStorage on mount
  useEffect(() => {
    const token = sessionStorage.getItem('authToken');
    const username = sessionStorage.getItem('authUsername');

    if (token && username) {
      setAuth({ token, username });
    }

    setLoading(false);
  }, []);

  const login = async (username, password) => {
    try {
      const response = await fetch('/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ username, password }),
      });

      const data = await response.json();

      if (response.ok && data.success) {
        sessionStorage.setItem('authToken', data.token);
        sessionStorage.setItem('authUsername', data.username);
        setAuth({ token: data.token, username: data.username });
        return { success: true };
      }

      return { success: false, message: data.message };
    } catch (error) {
      // eslint-disable-next-line no-console
      console.error('Login error:', error);
      return { success: false, message: 'Network error' };
    }
  };

  const logout = () => {
    sessionStorage.removeItem('authToken');
    sessionStorage.removeItem('authUsername');
    setAuth(null);
  };

  return (
    <AuthContext.Provider value={{ auth, login, logout, loading }}>
      {children}
    </AuthContext.Provider>
  );
};
