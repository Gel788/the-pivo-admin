import React, { useState, useEffect } from 'react';
import {
  Box,
  Button,
  Card,
  CardContent,
  CardMedia,
  Grid,
  IconButton,
  Typography,
  Chip,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  CircularProgress,
  Alert,
} from '@mui/material';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  AccessTime as TimeIcon,
  LocationOn as LocationIcon,
  Phone as PhoneIcon,
  Email as EmailIcon,
} from '@mui/icons-material';
import { restaurantService, Restaurant, CreateRestaurantDto } from '../services/restaurantService';

const Restaurants: React.FC = () => {
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedRestaurant, setSelectedRestaurant] = useState<Restaurant | null>(null);
  const [formData, setFormData] = useState<CreateRestaurantDto>({
    name: '',
    description: '',
    address: '',
    phone: '',
    email: '',
    workingHours: {
      start: '09:00',
      end: '22:00',
    },
    cuisine: [],
  });

  useEffect(() => {
    loadRestaurants();
  }, []);

  const loadRestaurants = async () => {
    try {
      setLoading(true);
      const data = await restaurantService.getAll();
      setRestaurants(data);
      setError(null);
    } catch (err) {
      setError('Ошибка при загрузке ресторанов');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenDialog = (restaurant?: Restaurant) => {
    if (restaurant) {
      setSelectedRestaurant(restaurant);
      setFormData({
        name: restaurant.name,
        description: restaurant.description,
        address: restaurant.address,
        phone: restaurant.phone,
        email: restaurant.email,
        workingHours: restaurant.workingHours,
        cuisine: restaurant.cuisine,
      });
    } else {
      setSelectedRestaurant(null);
      setFormData({
        name: '',
        description: '',
        address: '',
        phone: '',
        email: '',
        workingHours: {
          start: '09:00',
          end: '22:00',
        },
        cuisine: [],
      });
    }
    setOpenDialog(true);
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
    setSelectedRestaurant(null);
  };

  const handleSubmit = async () => {
    try {
      if (selectedRestaurant) {
        await restaurantService.update(selectedRestaurant.id, formData);
      } else {
        await restaurantService.create(formData);
      }
      handleCloseDialog();
      loadRestaurants();
    } catch (err) {
      setError('Ошибка при сохранении ресторана');
      console.error(err);
    }
  };

  const handleDelete = async (id: string) => {
    if (window.confirm('Вы уверены, что хотите удалить этот ресторан?')) {
      try {
        await restaurantService.delete(id);
        loadRestaurants();
      } catch (err) {
        setError('Ошибка при удалении ресторана');
        console.error(err);
      }
    }
  };

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="400px">
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">Рестораны</Typography>
        <Button
          variant="contained"
          color="primary"
          startIcon={<AddIcon />}
          onClick={() => handleOpenDialog()}
        >
          Добавить ресторан
        </Button>
      </Box>

      {error && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error}
        </Alert>
      )}

      <Grid container spacing={3}>
        {restaurants.map((restaurant) => (
          <Grid item xs={12} sm={6} md={4} key={restaurant.id}>
            <Card>
              <CardMedia
                component="img"
                height="140"
                image={restaurant.images[0] || 'https://via.placeholder.com/300x140'}
                alt={restaurant.name}
              />
              <CardContent>
                <Box display="flex" justifyContent="space-between" alignItems="flex-start">
                  <Typography variant="h6" component="div">
                    {restaurant.name}
                  </Typography>
                  <Box>
                    <IconButton
                      size="small"
                      onClick={() => handleOpenDialog(restaurant)}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      size="small"
                      color="error"
                      onClick={() => handleDelete(restaurant.id)}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </Box>
                </Box>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                  {restaurant.description}
                </Typography>
                <Box display="flex" alignItems="center" mb={0.5}>
                  <LocationIcon sx={{ mr: 1, fontSize: 16 }} />
                  <Typography variant="body2">{restaurant.address}</Typography>
                </Box>
                <Box display="flex" alignItems="center" mb={0.5}>
                  <TimeIcon sx={{ mr: 1, fontSize: 16 }} />
                  <Typography variant="body2">
                    {restaurant.workingHours.start} - {restaurant.workingHours.end}
                  </Typography>
                </Box>
                <Box display="flex" alignItems="center" mb={0.5}>
                  <PhoneIcon sx={{ mr: 1, fontSize: 16 }} />
                  <Typography variant="body2">{restaurant.phone}</Typography>
                </Box>
                <Box display="flex" alignItems="center" mb={1}>
                  <EmailIcon sx={{ mr: 1, fontSize: 16 }} />
                  <Typography variant="body2">{restaurant.email}</Typography>
                </Box>
                <Box display="flex" gap={1} flexWrap="wrap">
                  {restaurant.cuisine.map((item) => (
                    <Chip key={item} label={item} size="small" />
                  ))}
                </Box>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>

      <Dialog open={openDialog} onClose={handleCloseDialog} maxWidth="sm" fullWidth>
        <DialogTitle>
          {selectedRestaurant ? 'Редактировать ресторан' : 'Добавить ресторан'}
        </DialogTitle>
        <DialogContent>
          <Box display="flex" flexDirection="column" gap={2} mt={1}>
            <TextField
              label="Название"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              fullWidth
            />
            <TextField
              label="Описание"
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              multiline
              rows={3}
              fullWidth
            />
            <TextField
              label="Адрес"
              value={formData.address}
              onChange={(e) => setFormData({ ...formData, address: e.target.value })}
              fullWidth
            />
            <TextField
              label="Телефон"
              value={formData.phone}
              onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
              fullWidth
            />
            <TextField
              label="Email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              fullWidth
            />
            <Box display="flex" gap={2}>
              <TextField
                label="Время открытия"
                type="time"
                value={formData.workingHours.start}
                onChange={(e) =>
                  setFormData({
                    ...formData,
                    workingHours: { ...formData.workingHours, start: e.target.value },
                  })
                }
                fullWidth
                InputLabelProps={{ shrink: true }}
              />
              <TextField
                label="Время закрытия"
                type="time"
                value={formData.workingHours.end}
                onChange={(e) =>
                  setFormData({
                    ...formData,
                    workingHours: { ...formData.workingHours, end: e.target.value },
                  })
                }
                fullWidth
                InputLabelProps={{ shrink: true }}
              />
            </Box>
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Отмена</Button>
          <Button onClick={handleSubmit} variant="contained" color="primary">
            {selectedRestaurant ? 'Сохранить' : 'Добавить'}
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default Restaurants; 