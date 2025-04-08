import React from 'react';
import { Container, Typography, Button, Box } from '@mui/material';
import { useNavigate } from 'react-router-dom';

const Unauthorized: React.FC = () => {
  const navigate = useNavigate();

  return (
    <Container maxWidth="sm">
      <Box
        sx={{
          marginTop: 8,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          textAlign: 'center',
          minHeight: '100vh',
        }}
      >
        <Typography variant="h4" component="h1" gutterBottom>
          Доступ запрещен
        </Typography>
        <Typography variant="body1" sx={{ mb: 4 }}>
          У вас нет необходимых прав для доступа к этой странице.
        </Typography>
        <Box sx={{ display: 'flex', gap: 2 }}>
          <Button
            variant="contained"
            onClick={() => navigate(-1)}
          >
            Назад
          </Button>
          <Button
            variant="outlined"
            onClick={() => navigate('/')}
          >
            На главную
          </Button>
        </Box>
      </Box>
    </Container>
  );
};

export default Unauthorized; 