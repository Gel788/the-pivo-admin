import React from 'react';
import {
  Grid,
  Paper,
  Typography,
  Box,
  Card,
  CardContent,
  LinearProgress,
  IconButton,
  Tooltip,
} from '@mui/material';
import {
  Restaurant as RestaurantIcon,
  People as PeopleIcon,
  Receipt as ReceiptIcon,
  AttachMoney as MoneyIcon,
  TrendingUp,
  MoreVert,
  ArrowUpward,
  ArrowDownward,
} from '@mui/icons-material';

const Dashboard: React.FC = () => {
  // В реальном приложении эти данные будут получены из API
  const stats = {
    totalRestaurants: 5,
    activeUsers: 150,
    todayOrders: 45,
    monthlyRevenue: 250000,
    orderGrowth: 12.5,
    userGrowth: 8.3,
    revenueGrowth: 15.7,
    popularItems: [
      { name: 'Пиво светлое', orders: 156, progress: 85 },
      { name: 'Пиво темное', orders: 124, progress: 68 },
      { name: 'Закуски к пиву', orders: 98, progress: 54 },
      { name: 'Снеки', orders: 87, progress: 48 },
    ],
  };

  const StatCard = ({ 
    title, 
    value, 
    icon, 
    color,
    growth,
  }: {
    title: string;
    value: number | string;
    icon: React.ReactNode;
    color: string;
    growth?: number;
  }) => (
    <Card sx={{ height: '100%' }}>
      <CardContent>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 2 }}>
          <Box
            sx={{
              backgroundColor: `${color}15`,
              borderRadius: '12px',
              p: 1,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            {React.cloneElement(icon as React.ReactElement, {
              sx: { color },
            })}
          </Box>
          <Tooltip title="Подробнее">
            <IconButton size="small">
              <MoreVert />
            </IconButton>
          </Tooltip>
        </Box>
        <Typography variant="h4" component="div" sx={{ mb: 1 }}>
          {typeof value === 'number' && title.includes('выручка')
            ? `${value.toLocaleString()} ₽`
            : value}
        </Typography>
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
          <Typography variant="body2" color="text.secondary">
            {title}
          </Typography>
        </Box>
        {growth !== undefined && (
          <Box sx={{ display: 'flex', alignItems: 'center' }}>
            {growth >= 0 ? (
              <ArrowUpward sx={{ color: 'success.main', fontSize: 16, mr: 0.5 }} />
            ) : (
              <ArrowDownward sx={{ color: 'error.main', fontSize: 16, mr: 0.5 }} />
            )}
            <Typography
              variant="body2"
              sx={{
                color: growth >= 0 ? 'success.main' : 'error.main',
                display: 'flex',
                alignItems: 'center',
              }}
            >
              {Math.abs(growth)}% по сравнению с прошлым месяцем
            </Typography>
          </Box>
        )}
      </CardContent>
    </Card>
  );

  const PopularItemCard = ({ item }: { item: { name: string; orders: number; progress: number } }) => (
    <Box sx={{ mb: 2 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 1 }}>
        <Typography variant="body1">{item.name}</Typography>
        <Typography variant="body2" color="text.secondary">
          {item.orders} заказов
        </Typography>
      </Box>
      <LinearProgress
        variant="determinate"
        value={item.progress}
        sx={{
          height: 8,
          borderRadius: 4,
          backgroundColor: 'rgba(0, 0, 0, 0.05)',
          '& .MuiLinearProgress-bar': {
            borderRadius: 4,
          },
        }}
      />
    </Box>
  );

  return (
    <Box>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h4" sx={{ fontWeight: 600 }}>
          Панель управления
        </Typography>
        <Box sx={{ display: 'flex', alignItems: 'center' }}>
          <TrendingUp sx={{ mr: 1, color: 'success.main' }} />
          <Typography variant="body1" color="success.main">
            Рост продаж на 15.7%
          </Typography>
        </Box>
      </Box>

      <Grid container spacing={3}>
        <Grid item xs={12} sm={6} md={3}>
          <StatCard
            title="Рестораны"
            value={stats.totalRestaurants}
            icon={<RestaurantIcon />}
            color="#2196f3"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <StatCard
            title="Активные пользователи"
            value={stats.activeUsers}
            icon={<PeopleIcon />}
            color="#4caf50"
            growth={stats.userGrowth}
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <StatCard
            title="Заказы сегодня"
            value={stats.todayOrders}
            icon={<ReceiptIcon />}
            color="#ff9800"
            growth={stats.orderGrowth}
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <StatCard
            title="Месячная выручка"
            value={stats.monthlyRevenue}
            icon={<MoneyIcon />}
            color="#f44336"
            growth={stats.revenueGrowth}
          />
        </Grid>

        <Grid item xs={12} md={8}>
          <Card sx={{ height: '100%' }}>
            <CardContent>
              <Typography variant="h6" sx={{ mb: 2 }}>
                График продаж
              </Typography>
              {/* Здесь будет компонент с графиком */}
              <Box
                sx={{
                  width: '100%',
                  height: 300,
                  backgroundColor: 'rgba(0, 0, 0, 0.02)',
                  borderRadius: 2,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                <Typography color="text.secondary">
                  График продаж будет добавлен позже
                </Typography>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} md={4}>
          <Card sx={{ height: '100%' }}>
            <CardContent>
              <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
                <Typography variant="h6">
                  Популярные позиции
                </Typography>
                <Tooltip title="Подробнее">
                  <IconButton size="small">
                    <MoreVert />
                  </IconButton>
                </Tooltip>
              </Box>
              {stats.popularItems.map((item, index) => (
                <PopularItemCard key={index} item={item} />
              ))}
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Dashboard; 