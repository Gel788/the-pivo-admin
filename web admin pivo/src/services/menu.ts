import { api } from './api';

export interface MenuItem {
  id: string;
  name: string;
  description: string;
  price: number;
  category: string;
  subCategory?: string;
  images: string[];
  ingredients: {
    name: string;
    amount: string;
    unit: string;
  }[];
  nutritionalInfo: {
    calories: number;
    protein: number;
    carbs: number;
    fat: number;
    fiber: number;
    sugar: number;
    sodium: number;
  };
  allergens: string[];
  isAvailable: boolean;
  inStock: boolean;
  ratings: {
    userId: string;
    rating: number;
    comment?: string;
    date: Date;
  }[];
  averageRating: number;
  tags: string[];
  promotions: {
    type: 'discount' | 'special' | 'seasonal';
    value: number;
    startDate: Date;
    endDate: Date;
    description: string;
  }[];
  preparationTime: number;
  spicinessLevel?: 1 | 2 | 3 | 4 | 5;
  dietaryInfo: {
    isVegetarian: boolean;
    isVegan: boolean;
    isGlutenFree: boolean;
    isHalal: boolean;
    isKosher: boolean;
  };
  restaurantId: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateMenuItemDto {
  name: string;
  description: string;
  price: number;
  category: string;
  subCategory?: string;
  images?: string[];
  ingredients?: MenuItem['ingredients'];
  nutritionalInfo?: MenuItem['nutritionalInfo'];
  allergens?: string[];
  isAvailable?: boolean;
  inStock?: boolean;
  tags?: string[];
  preparationTime?: number;
  spicinessLevel?: MenuItem['spicinessLevel'];
  dietaryInfo?: MenuItem['dietaryInfo'];
  restaurantId: string;
}

export interface UpdateMenuItemDto {
  name?: string;
  description?: string;
  price?: number;
  category?: string;
  subCategory?: string;
  images?: string[];
  ingredients?: MenuItem['ingredients'];
  nutritionalInfo?: MenuItem['nutritionalInfo'];
  allergens?: string[];
  isAvailable?: boolean;
  inStock?: boolean;
  tags?: string[];
  preparationTime?: number;
  spicinessLevel?: MenuItem['spicinessLevel'];
  dietaryInfo?: MenuItem['dietaryInfo'];
}

export interface MenuCategory {
  id: string;
  name: string;
  description: string;
  image?: string;
  order: number;
  isActive: boolean;
  subCategories?: {
    id: string;
    name: string;
    description: string;
    order: number;
  }[];
}

export const menuService = {
  async getAllMenuItems(restaurantId: string): Promise<MenuItem[]> {
    const { data } = await api.get<MenuItem[]>(`/restaurants/${restaurantId}/menu`);
    return data;
  },

  async getMenuItemById(restaurantId: string, itemId: string): Promise<MenuItem> {
    const { data } = await api.get<MenuItem>(`/restaurants/${restaurantId}/menu/${itemId}`);
    return data;
  },

  async createMenuItem(restaurantId: string, item: CreateMenuItemDto): Promise<MenuItem> {
    const { data } = await api.post<MenuItem>(`/restaurants/${restaurantId}/menu`, item);
    return data;
  },

  async updateMenuItem(restaurantId: string, itemId: string, item: UpdateMenuItemDto): Promise<MenuItem> {
    const { data } = await api.put<MenuItem>(`/restaurants/${restaurantId}/menu/${itemId}`, item);
    return data;
  },

  async deleteMenuItem(restaurantId: string, itemId: string): Promise<void> {
    await api.delete(`/restaurants/${restaurantId}/menu/${itemId}`);
  },

  async getMenuItemsByCategory(restaurantId: string, category: string): Promise<MenuItem[]> {
    const { data } = await api.get<MenuItem[]>(`/restaurants/${restaurantId}/menu/category/${category}`);
    return data;
  },

  async getMenuItemsByTag(restaurantId: string, tag: string): Promise<MenuItem[]> {
    const { data } = await api.get<MenuItem[]>(`/restaurants/${restaurantId}/menu/tag/${tag}`);
    return data;
  },

  async getAvailableMenuItems(restaurantId: string): Promise<MenuItem[]> {
    const { data } = await api.get<MenuItem[]>(`/restaurants/${restaurantId}/menu/available`);
    return data;
  },

  async updateMenuItemAvailability(restaurantId: string, itemId: string, isAvailable: boolean): Promise<MenuItem> {
    const { data } = await api.put<MenuItem>(`/restaurants/${restaurantId}/menu/${itemId}/availability`, { isAvailable });
    return data;
  },

  async updateMenuItemStock(restaurantId: string, itemId: string, inStock: boolean): Promise<MenuItem> {
    const { data } = await api.put<MenuItem>(`/restaurants/${restaurantId}/menu/${itemId}/stock`, { inStock });
    return data;
  },

  async addMenuItemImage(restaurantId: string, itemId: string, imageUrl: string): Promise<MenuItem> {
    const { data } = await api.post<MenuItem>(`/restaurants/${restaurantId}/menu/${itemId}/images`, { imageUrl });
    return data;
  },

  async removeMenuItemImage(restaurantId: string, itemId: string, imageUrl: string): Promise<MenuItem> {
    const { data } = await api.delete<MenuItem>(`/restaurants/${restaurantId}/menu/${itemId}/images`, {
      data: { imageUrl }
    });
    return data;
  },

  async addMenuItemRating(
    restaurantId: string,
    itemId: string,
    userId: string,
    rating: number,
    comment?: string
  ): Promise<MenuItem> {
    const { data } = await api.post<MenuItem>(`/restaurants/${restaurantId}/menu/${itemId}/ratings`, {
      userId,
      rating,
      comment
    });
    return data;
  },

  async updateMenuItemRating(
    restaurantId: string,
    itemId: string,
    userId: string,
    rating: number,
    comment?: string
  ): Promise<MenuItem> {
    const { data } = await api.put<MenuItem>(`/restaurants/${restaurantId}/menu/${itemId}/ratings/${userId}`, {
      rating,
      comment
    });
    return data;
  },

  async removeMenuItemRating(restaurantId: string, itemId: string, userId: string): Promise<MenuItem> {
    const { data } = await api.delete<MenuItem>(`/restaurants/${restaurantId}/menu/${itemId}/ratings/${userId}`);
    return data;
  },

  async addMenuItemPromotion(
    restaurantId: string,
    itemId: string,
    promotion: MenuItem['promotions'][0]
  ): Promise<MenuItem> {
    const { data } = await api.post<MenuItem>(`/restaurants/${restaurantId}/menu/${itemId}/promotions`, promotion);
    return data;
  },

  async removeMenuItemPromotion(restaurantId: string, itemId: string, promotionId: string): Promise<MenuItem> {
    const { data } = await api.delete<MenuItem>(`/restaurants/${restaurantId}/menu/${itemId}/promotions/${promotionId}`);
    return data;
  },

  async getMenuItemAnalytics(restaurantId: string, itemId: string, startDate: Date, endDate: Date): Promise<{
    totalOrders: number;
    totalRevenue: number;
    averageOrderValue: number;
    popularityRank: number;
    ratingDistribution: Record<number, number>;
    orderHistory: {
      date: Date;
      count: number;
      revenue: number;
    }[];
    customerFeedback: {
      positive: number;
      neutral: number;
      negative: number;
      commonKeywords: string[];
    };
  }> {
    const { data } = await api.get(`/restaurants/${restaurantId}/menu/${itemId}/analytics`, {
      params: { startDate, endDate }
    });
    return data;
  },

  // Категории меню
  async getAllCategories(): Promise<MenuCategory[]> {
    const { data } = await api.get<MenuCategory[]>('/menu/categories');
    return data;
  },

  async getCategoryById(id: string): Promise<MenuCategory> {
    const { data } = await api.get<MenuCategory>(`/menu/categories/${id}`);
    return data;
  },

  async createCategory(category: Omit<MenuCategory, 'id'>): Promise<MenuCategory> {
    const { data } = await api.post<MenuCategory>('/menu/categories', category);
    return data;
  },

  async updateCategory(id: string, category: Partial<MenuCategory>): Promise<MenuCategory> {
    const { data } = await api.put<MenuCategory>(`/menu/categories/${id}`, category);
    return data;
  },

  async deleteCategory(id: string): Promise<void> {
    await api.delete(`/menu/categories/${id}`);
  },

  async updateCategoryOrder(categories: { id: string; order: number }[]): Promise<MenuCategory[]> {
    const { data } = await api.put<MenuCategory[]>('/menu/categories/order', { categories });
    return data;
  }
}; 