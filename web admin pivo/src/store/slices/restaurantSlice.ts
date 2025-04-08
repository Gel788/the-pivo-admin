import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import restaurantService, { Restaurant, CreateRestaurantData, UpdateRestaurantData } from '../../services/restaurantService';

interface RestaurantState {
  restaurants: Restaurant[];
  currentRestaurant: Restaurant | null;
  loading: boolean;
  error: string | null;
}

const initialState: RestaurantState = {
  restaurants: [],
  currentRestaurant: null,
  loading: false,
  error: null,
};

export const fetchRestaurants = createAsyncThunk('restaurants/fetchAll', async () => {
  return await restaurantService.getAll();
});

export const fetchRestaurantById = createAsyncThunk(
  'restaurants/fetchById',
  async (id: string) => {
    return await restaurantService.getById(id);
  }
);

export const createRestaurant = createAsyncThunk(
  'restaurants/create',
  async (data: CreateRestaurantData) => {
    return await restaurantService.create(data);
  }
);

export const updateRestaurant = createAsyncThunk(
  'restaurants/update',
  async ({ id, data }: { id: string; data: UpdateRestaurantData }) => {
    return await restaurantService.update(id, data);
  }
);

export const deleteRestaurant = createAsyncThunk(
  'restaurants/delete',
  async (id: string) => {
    await restaurantService.delete(id);
    return id;
  }
);

const restaurantSlice = createSlice({
  name: 'restaurants',
  initialState,
  reducers: {
    clearError: (state) => {
      state.error = null;
    },
    clearCurrentRestaurant: (state) => {
      state.currentRestaurant = null;
    },
  },
  extraReducers: (builder) => {
    builder
      // Fetch All
      .addCase(fetchRestaurants.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchRestaurants.fulfilled, (state, action) => {
        state.loading = false;
        state.restaurants = action.payload;
      })
      .addCase(fetchRestaurants.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Ошибка при загрузке ресторанов';
      })
      // Fetch By Id
      .addCase(fetchRestaurantById.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchRestaurantById.fulfilled, (state, action) => {
        state.loading = false;
        state.currentRestaurant = action.payload;
      })
      .addCase(fetchRestaurantById.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Ошибка при загрузке ресторана';
      })
      // Create
      .addCase(createRestaurant.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(createRestaurant.fulfilled, (state, action) => {
        state.loading = false;
        state.restaurants.push(action.payload);
      })
      .addCase(createRestaurant.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Ошибка при создании ресторана';
      })
      // Update
      .addCase(updateRestaurant.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(updateRestaurant.fulfilled, (state, action) => {
        state.loading = false;
        const index = state.restaurants.findIndex((r) => r.id === action.payload.id);
        if (index !== -1) {
          state.restaurants[index] = action.payload;
        }
        if (state.currentRestaurant?.id === action.payload.id) {
          state.currentRestaurant = action.payload;
        }
      })
      .addCase(updateRestaurant.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Ошибка при обновлении ресторана';
      })
      // Delete
      .addCase(deleteRestaurant.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(deleteRestaurant.fulfilled, (state, action) => {
        state.loading = false;
        state.restaurants = state.restaurants.filter((r) => r.id !== action.payload);
        if (state.currentRestaurant?.id === action.payload) {
          state.currentRestaurant = null;
        }
      })
      .addCase(deleteRestaurant.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Ошибка при удалении ресторана';
      });
  },
});

export const { clearError, clearCurrentRestaurant } = restaurantSlice.actions;
export default restaurantSlice.reducer; 