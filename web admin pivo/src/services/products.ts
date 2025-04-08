import { api } from './api';

export interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  category: string;
  subCategory?: string;
  images: string[];
  ingredients: string[];
  nutritionalInfo: {
    calories: number;
    protein: number;
    carbs: number;
    fat: number;
  };
  allergens: string[];
  isAvailable: boolean;
  inStock: number;
  ratings: {
    userId: string;
    rating: number;
    comment?: string;
  }[];
  averageRating: number;
  tags: string[];
  promotions?: {
    type: string;
    value: number;
    startDate: Date;
    endDate: Date;
  }[];
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateProductDto {
  name: string;
  description: string;
  price: number;
  category: string;
  subCategory?: string;
  images: string[];
  ingredients: string[];
  nutritionalInfo: {
    calories: number;
    protein: number;
    carbs: number;
    fat: number;
  };
  allergens: string[];
  inStock: number;
  tags: string[];
}

export interface UpdateProductDto extends Partial<CreateProductDto> {
  isAvailable?: boolean;
}

export const productService = {
  async getAllProducts(): Promise<Product[]> {
    const { data } = await api.get<Product[]>('/products');
    return data;
  },

  async getProductById(id: string): Promise<Product> {
    const { data } = await api.get<Product>(`/products/${id}`);
    return data;
  },

  async createProduct(product: CreateProductDto): Promise<Product> {
    const { data } = await api.post<Product>('/products', product);
    return data;
  },

  async updateProduct(id: string, product: UpdateProductDto): Promise<Product> {
    const { data } = await api.put<Product>(`/products/${id}`, product);
    return data;
  },

  async deleteProduct(id: string): Promise<void> {
    await api.delete(`/products/${id}`);
  },

  async getProductsByCategory(category: string): Promise<Product[]> {
    const { data } = await api.get<Product[]>(`/products/category/${category}`);
    return data;
  },

  async searchProducts(query: string): Promise<Product[]> {
    const { data } = await api.get<Product[]>(`/products/search?q=${query}`);
    return data;
  },

  async rateProduct(id: string, rating: number, comment?: string): Promise<Product> {
    const { data } = await api.post<Product>(`/products/${id}/rate`, { rating, comment });
    return data;
  }
}; 