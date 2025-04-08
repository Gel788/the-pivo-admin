import api from './api';

export interface Restaurant {
  id: string;
  name: string;
  description: string;
  address: string;
  phone: string;
  email: string;
  workingHours: {
    start: string;
    end: string;
  };
  cuisine: string[];
  rating: number;
  isActive: boolean;
  images: string[];
  createdAt: string;
  updatedAt: string;
}

export interface CreateRestaurantDto {
  name: string;
  description: string;
  address: string;
  phone: string;
  email: string;
  workingHours: {
    start: string;
    end: string;
  };
  cuisine: string[];
  images?: string[];
}

export interface UpdateRestaurantDto extends Partial<CreateRestaurantDto> {
  isActive?: boolean;
}

class RestaurantService {
  private readonly baseUrl = '/restaurants';

  async getAll(): Promise<Restaurant[]> {
    const response = await api.get<Restaurant[]>(this.baseUrl);
    return response.data;
  }

  async getById(id: string): Promise<Restaurant> {
    const response = await api.get<Restaurant>(`${this.baseUrl}/${id}`);
    return response.data;
  }

  async create(data: CreateRestaurantDto): Promise<Restaurant> {
    const response = await api.post<Restaurant>(this.baseUrl, data);
    return response.data;
  }

  async update(id: string, data: UpdateRestaurantDto): Promise<Restaurant> {
    const response = await api.patch<Restaurant>(`${this.baseUrl}/${id}`, data);
    return response.data;
  }

  async delete(id: string): Promise<void> {
    await api.delete(`${this.baseUrl}/${id}`);
  }

  async uploadImage(id: string, file: File): Promise<string> {
    const formData = new FormData();
    formData.append('image', file);
    
    const response = await api.post<{ url: string }>(
      `${this.baseUrl}/${id}/images`,
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      }
    );
    
    return response.data.url;
  }

  async deleteImage(id: string, imageUrl: string): Promise<void> {
    await api.delete(`${this.baseUrl}/${id}/images`, {
      data: { imageUrl },
    });
  }
}

export const restaurantService = new RestaurantService(); 