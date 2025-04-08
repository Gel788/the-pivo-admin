import api from './api';

export interface Restaurant {
  id: string;
  name: string;
  address: string;
  phone: string;
  email: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface CreateRestaurantData {
  name: string;
  address: string;
  phone: string;
  email: string;
}

export interface UpdateRestaurantData extends Partial<CreateRestaurantData> {
  isActive?: boolean;
}

const restaurantService = {
  getAll: async (): Promise<Restaurant[]> => {
    const response = await api.get<Restaurant[]>('/restaurants');
    return response.data;
  },

  getById: async (id: string): Promise<Restaurant> => {
    const response = await api.get<Restaurant>(`/restaurants/${id}`);
    return response.data;
  },

  create: async (data: CreateRestaurantData): Promise<Restaurant> => {
    const response = await api.post<Restaurant>('/restaurants', data);
    return response.data;
  },

  update: async (id: string, data: UpdateRestaurantData): Promise<Restaurant> => {
    const response = await api.put<Restaurant>(`/restaurants/${id}`, data);
    return response.data;
  },

  delete: async (id: string): Promise<void> => {
    await api.delete(`/restaurants/${id}`);
  },
};

export default restaurantService; 