import React, { createContext, useContext, useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

interface User {
  id: string;
  email: string;
  name: string;
  role: string;
}

interface AuthContextType {
  user: User | null;
  loading: boolean;
  error: string | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  clearError: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    // Здесь можно добавить проверку токена и автоматическую авторизацию
    const token = localStorage.getItem('token');
    if (token) {
      // Временно для демонстрации
      setUser({
        id: '1',
        email: 'admin@example.com',
        name: 'Admin',
        role: 'admin',
      });
    }
  }, []);

  const login = async (email: string, password: string) => {
    try {
      setLoading(true);
      setError(null);

      // Временная имитация API запроса
      await new Promise((resolve) => setTimeout(resolve, 1000));

      if (email === 'admin@example.com' && password === 'admin') {
        const user = {
          id: '1',
          email: 'admin@example.com',
          name: 'Admin',
          role: 'admin',
        };

        setUser(user);
        localStorage.setItem('token', 'demo-token');
        navigate('/');
      } else {
        throw new Error('Неверный email или пароль');
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Произошла ошибка при входе');
    } finally {
      setLoading(false);
    }
  };

  const logout = () => {
    setUser(null);
    localStorage.removeItem('token');
    navigate('/login');
  };

  const clearError = () => {
    setError(null);
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        loading,
        error,
        login,
        logout,
        clearError,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
