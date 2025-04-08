import React from 'react';
import {
  Box,
  Grid,
  Card,
  CardContent,
  Typography,
  useTheme,
  IconButton,
  LinearProgress,
  Avatar,
  Chip,
  Paper,
  List,
  ListItem,
  ListItemAvatar,
  ListItemText,
} from '@mui/material';
import {
  TrendingUp,
  People,
  Restaurant,
  AttachMoney,
  MoreVert,
  ArrowUpward,
  ArrowDownward,
  ShoppingCart,
} from '@mui/icons-material';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { alpha } from '@mui/material/styles';
import { animationStyles } from '../theme/animations';
import { StatCard } from '../components/StatCard';

const salesData = [
  { name: 'Jan', value: 4000 },
  { name: 'Feb', value: 3000 },
  { name: 'Mar', value: 5000 },
  { name: 'Apr', value: 4500 },
  { name: 'May', value: 6000 },
  { name: 'Jun', value: 5500 },
];

const Dashboard: React.FC = () => {
  const theme = useTheme();

  const stats = [
    {
      title: 'Общая выручка',
      value: '₽ 1,234,567',
      trend: '+12.5%',
      icon: '💰',
      color: '#4CAF50'
    },
    {
      title: 'Заказы',
      value: '156',
      trend: '+8.3%',
      icon: '📦',
      color: '#2196F3'
    },
    {
      title: 'Клиенты',
      value: '2,345',
      trend: '+15.7%',
      icon: '👥',
      color: '#9C27B0'
    },
    {
      title: 'Средний чек',
      value: '₽ 789',
      trend: '+5.2%',
      icon: '💳',
      color: '#FF9800'
    }
  ];

  return (
    <Box sx={{ p: 3 }}>
      <Typography variant="h4" sx={{ mb: 4, ...animationStyles.fadeIn }}>
        Панель управления
      </Typography>
      
      <Grid container spacing={3}>
        {stats.map((stat, index) => (
          <Grid item xs={12} sm={6} md={3} key={stat.title}>
            <Box sx={{ ...animationStyles.slideIn, animationDelay: `${index * 0.1}s` }}>
              <StatCard {...stat} />
            </Box>
          </Grid>
        ))}
      </Grid>

      <Grid container spacing={3} sx={{ mt: 3 }}>
        <Grid item xs={12} md={8}>
          <Paper 
            sx={{ 
              p: 3, 
              height: '400px',
              ...animationStyles.slideUp,
              animationDelay: '0.4s'
            }}
          >
            <Typography variant="h6" sx={{ mb: 2 }}>
              График продаж
            </Typography>
            <Box sx={{ height: 300 }}>
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={salesData}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="name" />
                  <YAxis />
                  <Tooltip />
                  <Line
                    type="monotone"
                    dataKey="value"
                    stroke={theme.palette.primary.main}
                    strokeWidth={2}
                  />
                </LineChart>
              </ResponsiveContainer>
            </Box>
          </Paper>
        </Grid>
        
        <Grid item xs={12} md={4}>
          <Paper 
            sx={{ 
              p: 3, 
              height: '400px',
              ...animationStyles.slideUp,
              animationDelay: '0.6s'
            }}
          >
            <Typography variant="h6" sx={{ mb: 2 }}>
              Последние заказы
            </Typography>
            <List>
              {[1, 2, 3, 4, 5].map((order) => (
                <ListItem
                  key={order}
                  sx={{
                    '&:hover': {
                      backgroundColor: alpha(theme.palette.primary.main, 0.04),
                    },
                    transition: 'background-color 0.2s',
                  }}
                >
                  <ListItemAvatar>
                    <Avatar sx={{ mr: 2 }}>R</Avatar>
                  </ListItemAvatar>
                  <ListItemText
                    primary={`Заказ #${order}`}
                    secondary={`Ресторан Name • $45.00`}
                  />
                  <Chip
                    label="Выполнен"
                    size="small"
                    color="success"
                  />
                </ListItem>
              ))}
            </List>
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Dashboard;
