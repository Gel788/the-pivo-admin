import React from 'react';
import { Box, Typography, Chip } from '@mui/material';
import { styled } from '@mui/material/styles';

const StatusContainer = styled(Box)(({ theme }) => ({
  padding: theme.spacing(2),
  borderRadius: theme.shape.borderRadius,
  backgroundColor: theme.palette.background.paper,
  boxShadow: theme.shadows[1],
  display: 'flex',
  alignItems: 'center',
  gap: theme.spacing(2),
}));

const StatusChip = styled(Chip)(({ theme, status }: { status: 'connected' | 'disconnected' }) => ({
  backgroundColor: status === 'connected' ? theme.palette.success.main : theme.palette.error.main,
  color: theme.palette.common.white,
  '& .MuiChip-label': {
    color: theme.palette.common.white,
  },
}));

interface WebSocketStatusProps {
  isConnected: boolean;
  lastMessage?: string;
}

export const WebSocketStatus: React.FC<WebSocketStatusProps> = ({ isConnected, lastMessage }) => {
  return (
    <StatusContainer>
      <Typography variant="h6">WebSocket Status</Typography>
      <StatusChip 
        label={isConnected ? 'Connected' : 'Disconnected'} 
        status={isConnected ? 'connected' : 'disconnected'}
      />
      {lastMessage && (
        <Typography variant="body2" color="textSecondary">
          Last message: {lastMessage}
        </Typography>
      )}
    </StatusContainer>
  );
}; 