import { api } from './api';

export interface User {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'manager' | 'staff' | 'customer';
  phone?: string;
  address?: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
    country: string;
  };
  preferences: {
    language: string;
    notifications: {
      email: boolean;
      push: boolean;
      sms: boolean;
    };
    dietaryRestrictions: string[];
  };
  orders: {
    id: string;
    restaurantId: string;
    status: string;
    total: number;
    date: Date;
  }[];
  favorites: {
    restaurantId: string;
    date: Date;
  }[];
  reviews: {
    id: string;
    restaurantId: string;
    rating: number;
    comment: string;
    date: Date;
  }[];
  status: 'active' | 'inactive' | 'suspended';
  lastLogin: Date;
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateUserDto {
  email: string;
  name: string;
  role: User['role'];
  phone?: string;
  address?: User['address'];
  preferences?: User['preferences'];
}

export interface UpdateUserDto {
  name?: string;
  phone?: string;
  address?: User['address'];
  preferences?: Partial<User['preferences']>;
  status?: User['status'];
}

export const userService = {
  async getAllUsers(): Promise<User[]> {
    const { data } = await api.get<User[]>('/users');
    return data;
  },

  async getUserById(id: string): Promise<User> {
    const { data } = await api.get<User>(`/users/${id}`);
    return data;
  },

  async createUser(user: CreateUserDto): Promise<User> {
    const { data } = await api.post<User>('/users', user);
    return data;
  },

  async updateUser(id: string, user: UpdateUserDto): Promise<User> {
    const { data } = await api.put<User>(`/users/${id}`, user);
    return data;
  },

  async deleteUser(id: string): Promise<void> {
    await api.delete(`/users/${id}`);
  },

  async getUsersByRole(role: User['role']): Promise<User[]> {
    const { data } = await api.get<User[]>(`/users/role/${role}`);
    return data;
  },

  async getUsersByStatus(status: User['status']): Promise<User[]> {
    const { data } = await api.get<User[]>(`/users/status/${status}`);
    return data;
  },

  async updateUserStatus(id: string, status: User['status']): Promise<User> {
    const { data } = await api.put<User>(`/users/${id}/status`, { status });
    return data;
  },

  async updateUserPreferences(id: string, preferences: User['preferences']): Promise<User> {
    const { data } = await api.put<User>(`/users/${id}/preferences`, { preferences });
    return data;
  },

  async addUserFavorite(id: string, restaurantId: string): Promise<User> {
    const { data } = await api.post<User>(`/users/${id}/favorites`, { restaurantId });
    return data;
  },

  async removeUserFavorite(id: string, restaurantId: string): Promise<User> {
    const { data } = await api.delete<User>(`/users/${id}/favorites/${restaurantId}`);
    return data;
  },

  async getUserOrders(id: string): Promise<User['orders']> {
    const { data } = await api.get<User['orders']>(`/users/${id}/orders`);
    return data;
  },

  async getUserReviews(id: string): Promise<User['reviews']> {
    const { data } = await api.get<User['reviews']>(`/users/${id}/reviews`);
    return data;
  },

  async getUserAnalytics(id: string, startDate: Date, endDate: Date): Promise<{
    totalOrders: number;
    totalSpent: number;
    averageOrderValue: number;
    favoriteRestaurants: {
      id: string;
      name: string;
      visitCount: number;
      totalSpent: number;
    }[];
    orderHistory: {
      date: Date;
      count: number;
      total: number;
    }[];
    reviewMetrics: {
      totalReviews: number;
      averageRating: number;
      ratingDistribution: Record<number, number>;
    };
  }> {
    const { data } = await api.get(`/users/${id}/analytics`, {
      params: { startDate, endDate }
    });
    return data;
  }
}; 