import React, { useState } from 'react';
import { Box, Button, TextField, Typography, Paper } from '@mui/material';
import { WebSocketStatus } from '../components/WebSocketStatus';
import { useWebSocket } from '../hooks/useWebSocket';

const WS_URL = import.meta.env.VITE_WS_URL || 'ws://localhost:8080';

export const WebSocketTest: React.FC = () => {
  const [message, setMessage] = useState('');
  const { isConnected, lastMessage, sendMessage, reconnect } = useWebSocket(WS_URL);

  const handleSendMessage = () => {
    if (message.trim()) {
      sendMessage(message);
      setMessage('');
    }
  };

  return (
    <Box sx={{ p: 3, maxWidth: 800, margin: '0 auto' }}>
      <Typography variant="h4" gutterBottom>
        WebSocket Test
      </Typography>
      
      <Paper sx={{ p: 3, mb: 3 }}>
        <WebSocketStatus isConnected={isConnected} lastMessage={lastMessage || undefined} />
      </Paper>

      <Paper sx={{ p: 3 }}>
        <Box sx={{ display: 'flex', gap: 2, mb: 2 }}>
          <TextField
            fullWidth
            label="Message"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
          />
          <Button
            variant="contained"
            onClick={handleSendMessage}
            disabled={!isConnected || !message.trim()}
          >
            Send
          </Button>
        </Box>

        <Button
          variant="outlined"
          onClick={reconnect}
          color={isConnected ? 'error' : 'primary'}
        >
          {isConnected ? 'Disconnect' : 'Connect'}
        </Button>
      </Paper>
    </Box>
  );
}; 