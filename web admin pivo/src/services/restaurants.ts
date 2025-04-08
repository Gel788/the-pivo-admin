import { api } from './api';

export interface Restaurant {
  id: string;
  name: string;
  description: string;
  address: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
    country: string;
  };
  location: {
    latitude: number;
    longitude: number;
  };
  contact: {
    phone: string;
    email: string;
    website?: string;
  };
  workingHours: {
    [key: string]: {
      open: string;
      close: string;
      isClosed: boolean;
    };
  };
  cuisine: string[];
  features: string[];
  rating: number;
  reviews: {
    id: string;
    userId: string;
    rating: number;
    comment: string;
    date: Date;
  }[];
  images: {
    id: string;
    url: string;
    type: 'main' | 'interior' | 'exterior' | 'menu';
  }[];
  menu: {
    categories: {
      id: string;
      name: string;
      description?: string;
      items: string[];
    }[];
  };
  staff: {
    id: string;
    name: string;
    role: string;
    email: string;
    phone: string;
  }[];
  settings: {
    acceptsReservations: boolean;
    acceptsOnlineOrders: boolean;
    acceptsDelivery: boolean;
    deliveryRadius: number;
    minimumOrderAmount: number;
    deliveryFee: number;
    taxRate: number;
  };
  status: 'active' | 'inactive' | 'temporarily_closed';
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateRestaurantDto {
  name: string;
  description: string;
  address: Restaurant['address'];
  location: Restaurant['location'];
  contact: Restaurant['contact'];
  workingHours: Restaurant['workingHours'];
  cuisine: string[];
  features: string[];
  settings: Restaurant['settings'];
}

export interface UpdateRestaurantDto {
  name?: string;
  description?: string;
  address?: Restaurant['address'];
  location?: Restaurant['location'];
  contact?: Restaurant['contact'];
  workingHours?: Restaurant['workingHours'];
  cuisine?: string[];
  features?: string[];
  settings?: Partial<Restaurant['settings']>;
  status?: Restaurant['status'];
}

export const restaurantService = {
  async getAllRestaurants(): Promise<Restaurant[]> {
    const { data } = await api.get<Restaurant[]>('/restaurants');
    return data;
  },

  async getRestaurantById(id: string): Promise<Restaurant> {
    const { data } = await api.get<Restaurant>(`/restaurants/${id}`);
    return data;
  },

  async createRestaurant(restaurant: CreateRestaurantDto): Promise<Restaurant> {
    const { data } = await api.post<Restaurant>('/restaurants', restaurant);
    return data;
  },

  async updateRestaurant(id: string, restaurant: UpdateRestaurantDto): Promise<Restaurant> {
    const { data } = await api.put<Restaurant>(`/restaurants/${id}`, restaurant);
    return data;
  },

  async deleteRestaurant(id: string): Promise<void> {
    await api.delete(`/restaurants/${id}`);
  },

  async getRestaurantsByCuisine(cuisine: string): Promise<Restaurant[]> {
    const { data } = await api.get<Restaurant[]>(`/restaurants/cuisine/${cuisine}`);
    return data;
  },

  async getRestaurantsByFeature(feature: string): Promise<Restaurant[]> {
    const { data } = await api.get<Restaurant[]>(`/restaurants/feature/${feature}`);
    return data;
  },

  async getRestaurantsByLocation(latitude: number, longitude: number, radius: number): Promise<Restaurant[]> {
    const { data } = await api.get<Restaurant[]>('/restaurants/nearby', {
      params: { latitude, longitude, radius }
    });
    return data;
  },

  async updateRestaurantStatus(id: string, status: Restaurant['status']): Promise<Restaurant> {
    const { data } = await api.put<Restaurant>(`/restaurants/${id}/status`, { status });
    return data;
  },

  async addRestaurantImage(id: string, image: { url: string; type: Restaurant['images'][0]['type'] }): Promise<Restaurant> {
    const { data } = await api.post<Restaurant>(`/restaurants/${id}/images`, image);
    return data;
  },

  async removeRestaurantImage(id: string, imageId: string): Promise<Restaurant> {
    const { data } = await api.delete<Restaurant>(`/restaurants/${id}/images/${imageId}`);
    return data;
  },

  async addRestaurantReview(id: string, review: {
    userId: string;
    rating: number;
    comment: string;
  }): Promise<Restaurant> {
    const { data } = await api.post<Restaurant>(`/restaurants/${id}/reviews`, review);
    return data;
  },

  async updateRestaurantReview(id: string, reviewId: string, review: {
    rating?: number;
    comment?: string;
  }): Promise<Restaurant> {
    const { data } = await api.put<Restaurant>(`/restaurants/${id}/reviews/${reviewId}`, review);
    return data;
  },

  async removeRestaurantReview(id: string, reviewId: string): Promise<Restaurant> {
    const { data } = await api.delete<Restaurant>(`/restaurants/${id}/reviews/${reviewId}`);
    return data;
  },

  async addRestaurantStaff(id: string, staff: {
    name: string;
    role: string;
    email: string;
    phone: string;
  }): Promise<Restaurant> {
    const { data } = await api.post<Restaurant>(`/restaurants/${id}/staff`, staff);
    return data;
  },

  async updateRestaurantStaff(id: string, staffId: string, staff: {
    name?: string;
    role?: string;
    email?: string;
    phone?: string;
  }): Promise<Restaurant> {
    const { data } = await api.put<Restaurant>(`/restaurants/${id}/staff/${staffId}`, staff);
    return data;
  },

  async removeRestaurantStaff(id: string, staffId: string): Promise<Restaurant> {
    const { data } = await api.delete<Restaurant>(`/restaurants/${id}/staff/${staffId}`);
    return data;
  },

  async getRestaurantAnalytics(id: string, startDate: Date, endDate: Date): Promise<{
    totalOrders: number;
    totalRevenue: number;
    averageOrderValue: number;
    ordersByStatus: Record<string, number>;
    ordersByPaymentMethod: Record<string, number>;
    topSellingItems: {
      id: string;
      name: string;
      quantity: number;
      revenue: number;
    }[];
    customerMetrics: {
      totalCustomers: number;
      newCustomers: number;
      returningCustomers: number;
      averageRating: number;
    };
  }> {
    const { data } = await api.get(`/restaurants/${id}/analytics`, {
      params: { startDate, endDate }
    });
    return data;
  }
}; 