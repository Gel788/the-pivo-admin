import { api } from './api';

export interface OrderItem {
  menuItemId: string;
  name: string;
  price: number;
  quantity: number;
  specialInstructions?: string;
  modifications?: {
    add: string[];
    remove: string[];
  };
}

export interface Order {
  id: string;
  restaurantId: string;
  userId: string;
  items: OrderItem[];
  status: 'pending' | 'confirmed' | 'preparing' | 'ready' | 'delivered' | 'cancelled';
  totalAmount: number;
  subtotal: number;
  tax: number;
  deliveryFee: number;
  tip?: number;
  paymentMethod: 'cash' | 'card' | 'online';
  paymentStatus: 'pending' | 'paid' | 'failed' | 'refunded';
  deliveryAddress: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
    country: string;
  };
  deliveryInstructions?: string;
  estimatedDeliveryTime?: Date;
  actualDeliveryTime?: Date;
  driverId?: string;
  rating?: {
    food: number;
    delivery: number;
    comment?: string;
  };
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateOrderDto {
  restaurantId: string;
  userId: string;
  items: OrderItem[];
  deliveryAddress: Order['deliveryAddress'];
  deliveryInstructions?: string;
  paymentMethod: Order['paymentMethod'];
  tip?: number;
}

export interface UpdateOrderDto {
  status?: Order['status'];
  items?: OrderItem[];
  deliveryAddress?: Order['deliveryAddress'];
  deliveryInstructions?: string;
  estimatedDeliveryTime?: Date;
  driverId?: string;
}

export const orderService = {
  async getAllOrders(restaurantId: string): Promise<Order[]> {
    const { data } = await api.get<Order[]>(`/restaurants/${restaurantId}/orders`);
    return data;
  },

  async getOrderById(restaurantId: string, orderId: string): Promise<Order> {
    const { data } = await api.get<Order>(`/restaurants/${restaurantId}/orders/${orderId}`);
    return data;
  },

  async createOrder(restaurantId: string, order: CreateOrderDto): Promise<Order> {
    const { data } = await api.post<Order>(`/restaurants/${restaurantId}/orders`, order);
    return data;
  },

  async updateOrder(restaurantId: string, orderId: string, order: UpdateOrderDto): Promise<Order> {
    const { data } = await api.put<Order>(`/restaurants/${restaurantId}/orders/${orderId}`, order);
    return data;
  },

  async cancelOrder(restaurantId: string, orderId: string): Promise<Order> {
    const { data } = await api.put<Order>(`/restaurants/${restaurantId}/orders/${orderId}/cancel`);
    return data;
  },

  async getOrdersByStatus(restaurantId: string, status: Order['status']): Promise<Order[]> {
    const { data } = await api.get<Order[]>(`/restaurants/${restaurantId}/orders/status/${status}`);
    return data;
  },

  async getOrdersByDateRange(restaurantId: string, startDate: Date, endDate: Date): Promise<Order[]> {
    const { data } = await api.get<Order[]>(`/restaurants/${restaurantId}/orders/date-range`, {
      params: { startDate, endDate }
    });
    return data;
  },

  async getOrdersByUser(restaurantId: string, userId: string): Promise<Order[]> {
    const { data } = await api.get<Order[]>(`/restaurants/${restaurantId}/orders/user/${userId}`);
    return data;
  },

  async updateOrderStatus(restaurantId: string, orderId: string, status: Order['status']): Promise<Order> {
    const { data } = await api.put<Order>(`/restaurants/${restaurantId}/orders/${orderId}/status`, { status });
    return data;
  },

  async updateOrderPaymentStatus(restaurantId: string, orderId: string, status: Order['paymentStatus']): Promise<Order> {
    const { data } = await api.put<Order>(`/restaurants/${restaurantId}/orders/${orderId}/payment-status`, { status });
    return data;
  },

  async assignDriver(restaurantId: string, orderId: string, driverId: string): Promise<Order> {
    const { data } = await api.put<Order>(`/restaurants/${restaurantId}/orders/${orderId}/driver`, { driverId });
    return data;
  },

  async addOrderRating(
    restaurantId: string,
    orderId: string,
    rating: { food: number; delivery: number; comment?: string }
  ): Promise<Order> {
    const { data } = await api.post<Order>(`/restaurants/${restaurantId}/orders/${orderId}/rating`, rating);
    return data;
  },

  async getOrderAnalytics(restaurantId: string, startDate: Date, endDate: Date): Promise<{
    totalOrders: number;
    totalRevenue: number;
    averageOrderValue: number;
    orderStatusDistribution: Record<Order['status'], number>;
    paymentMethodDistribution: Record<Order['paymentMethod'], number>;
    topSellingItems: {
      menuItemId: string;
      name: string;
      quantity: number;
      revenue: number;
    }[];
    orderHistory: {
      date: Date;
      count: number;
      revenue: number;
    }[];
    customerMetrics: {
      totalCustomers: number;
      repeatCustomers: number;
      averageRating: number;
      ratingDistribution: Record<number, number>;
    };
    deliveryMetrics: {
      averageDeliveryTime: number;
      onTimeDeliveryRate: number;
      driverPerformance: {
        driverId: string;
        ordersDelivered: number;
        averageRating: number;
        onTimeRate: number;
      }[];
    };
  }> {
    const { data } = await api.get(`/restaurants/${restaurantId}/orders/analytics`, {
      params: { startDate, endDate }
    });
    return data;
  }
}; 