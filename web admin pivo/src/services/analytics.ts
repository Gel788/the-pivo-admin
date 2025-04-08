import { api } from './api';

export interface AnalyticsTimeRange {
  startDate: Date;
  endDate: Date;
}

export interface RestaurantAnalytics {
  overview: {
    totalRevenue: number;
    totalOrders: number;
    averageOrderValue: number;
    totalCustomers: number;
    newCustomers: number;
    repeatCustomers: number;
    averageRating: number;
  };
  revenue: {
    daily: {
      date: Date;
      revenue: number;
      orders: number;
    }[];
    byPaymentMethod: Record<string, number>;
    byCategory: {
      category: string;
      revenue: number;
      percentage: number;
    }[];
  };
  orders: {
    byStatus: Record<string, number>;
    byTimeOfDay: {
      hour: number;
      count: number;
    }[];
    averagePreparationTime: number;
    cancellationRate: number;
  };
  menu: {
    topSellingItems: {
      id: string;
      name: string;
      quantity: number;
      revenue: number;
    }[];
    lowStockItems: {
      id: string;
      name: string;
      currentStock: number;
      reorderPoint: number;
    }[];
    categoryPerformance: {
      category: string;
      revenue: number;
      orders: number;
      averageRating: number;
    }[];
  };
  customers: {
    demographics: {
      ageGroups: Record<string, number>;
      gender: Record<string, number>;
      locations: {
        city: string;
        count: number;
      }[];
    };
    behavior: {
      averageOrderFrequency: number;
      averageOrderValue: number;
      peakOrderingTimes: {
        dayOfWeek: string;
        hour: number;
        count: number;
      }[];
      popularItems: {
        id: string;
        name: string;
        orderCount: number;
      }[];
    };
    retention: {
      newVsReturning: {
        new: number;
        returning: number;
      };
      churnRate: number;
      lifetimeValue: number;
    };
  };
  delivery: {
    averageDeliveryTime: number;
    onTimeDeliveryRate: number;
    driverPerformance: {
      driverId: string;
      ordersDelivered: number;
      averageRating: number;
      onTimeRate: number;
    }[];
    deliveryZones: {
      zone: string;
      orderCount: number;
      averageTime: number;
    }[];
  };
  marketing: {
    campaignPerformance: {
      campaignId: string;
      name: string;
      reach: number;
      conversions: number;
      revenue: number;
      roi: number;
    }[];
    promotionEffectiveness: {
      promotionId: string;
      type: string;
      orders: number;
      revenue: number;
      customerAcquisition: number;
    }[];
    customerAcquisition: {
      source: string;
      count: number;
      cost: number;
      revenue: number;
    }[];
  };
  operations: {
    peakHours: {
      hour: number;
      orderCount: number;
      staffRequired: number;
    }[];
    staffPerformance: {
      staffId: string;
      role: string;
      ordersProcessed: number;
      averageTime: number;
      customerRating: number;
    }[];
    inventoryMetrics: {
      turnoverRate: number;
      wasteRate: number;
      stockouts: {
        itemId: string;
        name: string;
        occurrences: number;
      }[];
    };
  };
}

export const analyticsService = {
  async getRestaurantAnalytics(restaurantId: string, timeRange: AnalyticsTimeRange): Promise<RestaurantAnalytics> {
    const { data } = await api.get<RestaurantAnalytics>(`/restaurants/${restaurantId}/analytics`, {
      params: timeRange
    });
    return data;
  },

  async getRevenueAnalytics(restaurantId: string, timeRange: AnalyticsTimeRange): Promise<RestaurantAnalytics['revenue']> {
    const { data } = await api.get<RestaurantAnalytics['revenue']>(`/restaurants/${restaurantId}/analytics/revenue`, {
      params: timeRange
    });
    return data;
  },

  async getOrderAnalytics(restaurantId: string, timeRange: AnalyticsTimeRange): Promise<RestaurantAnalytics['orders']> {
    const { data } = await api.get<RestaurantAnalytics['orders']>(`/restaurants/${restaurantId}/analytics/orders`, {
      params: timeRange
    });
    return data;
  },

  async getMenuAnalytics(restaurantId: string, timeRange: AnalyticsTimeRange): Promise<RestaurantAnalytics['menu']> {
    const { data } = await api.get<RestaurantAnalytics['menu']>(`/restaurants/${restaurantId}/analytics/menu`, {
      params: timeRange
    });
    return data;
  },

  async getCustomerAnalytics(restaurantId: string, timeRange: AnalyticsTimeRange): Promise<RestaurantAnalytics['customers']> {
    const { data } = await api.get<RestaurantAnalytics['customers']>(`/restaurants/${restaurantId}/analytics/customers`, {
      params: timeRange
    });
    return data;
  },

  async getDeliveryAnalytics(restaurantId: string, timeRange: AnalyticsTimeRange): Promise<RestaurantAnalytics['delivery']> {
    const { data } = await api.get<RestaurantAnalytics['delivery']>(`/restaurants/${restaurantId}/analytics/delivery`, {
      params: timeRange
    });
    return data;
  },

  async getMarketingAnalytics(restaurantId: string, timeRange: AnalyticsTimeRange): Promise<RestaurantAnalytics['marketing']> {
    const { data } = await api.get<RestaurantAnalytics['marketing']>(`/restaurants/${restaurantId}/analytics/marketing`, {
      params: timeRange
    });
    return data;
  },

  async getOperationsAnalytics(restaurantId: string, timeRange: AnalyticsTimeRange): Promise<RestaurantAnalytics['operations']> {
    const { data } = await api.get<RestaurantAnalytics['operations']>(`/restaurants/${restaurantId}/analytics/operations`, {
      params: timeRange
    });
    return data;
  },

  async exportAnalyticsReport(restaurantId: string, timeRange: AnalyticsTimeRange, format: 'pdf' | 'csv' | 'excel'): Promise<Blob> {
    const { data } = await api.get(`/restaurants/${restaurantId}/analytics/export`, {
      params: { ...timeRange, format },
      responseType: 'blob'
    });
    return data;
  },

  async scheduleAnalyticsReport(
    restaurantId: string,
    schedule: {
      frequency: 'daily' | 'weekly' | 'monthly';
      time: string;
      format: 'pdf' | 'csv' | 'excel';
      recipients: string[];
    }
  ): Promise<void> {
    await api.post(`/restaurants/${restaurantId}/analytics/schedule`, schedule);
  }
}; 