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

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    checkAuth();
  }, []);

  const checkAuth = async () => {
    try {
      const token = localStorage.getItem('token');
      if (token) {
        // Здесь должен быть запрос к API для проверки токена
        // const response = await api.get('/auth/me');
        // setUser(response.data);
        
        // Временное решение для демонстрации
        setUser({
          id: '1',
          email: 'admin@example.com',
          name: 'Admin',
          role: 'admin',
        });
      }
    } catch (err) {
      localStorage.removeItem('token');
    } finally {
      setLoading(false);
    }
  };

  const login = async (email: string, password: string) => {
    try {
      setLoading(true);
      setError(null);
      
      // Здесь должен быть запрос к API для аутентификации
      // const response = await api.post('/auth/login', { email, password });
      // localStorage.setItem('token', response.data.token);
      // setUser(response.data.user);
      
      // Временное решение для демонстрации
      if (email === 'admin@example.com' && password === 'admin') {
        localStorage.setItem('token', 'demo-token');
        setUser({
          id: '1',
          email: 'admin@example.com',
          name: 'Admin',
          role: 'admin',
        });
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
    localStorage.removeItem('token');
    setUser(null);
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
