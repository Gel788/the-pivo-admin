import api from './api';

export interface OrderItem {
  id: string;
  productId: string;
  productName: string;
  quantity: number;
  price: number;
  total: number;
}

export interface Order {
  id: string;
  restaurantId: string;
  restaurantName: string;
  userId: string;
  userName: string;
  items: OrderItem[];
  status: 'pending' | 'processing' | 'completed' | 'cancelled';
  total: number;
  createdAt: string;
  updatedAt: string;
}

export interface CreateOrderData {
  restaurantId: string;
  userId: string;
  items: {
    productId: string;
    quantity: number;
  }[];
}

export interface UpdateOrderData {
  status?: Order['status'];
}

const orderService = {
  getAll: async (): Promise<Order[]> => {
    const response = await api.get<Order[]>('/orders');
    return response.data;
  },

  getById: async (id: string): Promise<Order> => {
    const response = await api.get<Order>(`/orders/${id}`);
    return response.data;
  },

  create: async (data: CreateOrderData): Promise<Order> => {
    const response = await api.post<Order>('/orders', data);
    return response.data;
  },

  update: async (id: string, data: UpdateOrderData): Promise<Order> => {
    const response = await api.put<Order>(`/orders/${id}`, data);
    return response.data;
  },

  delete: async (id: string): Promise<void> => {
    await api.delete(`/orders/${id}`);
  },
};

export default orderService; 