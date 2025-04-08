import { useState, useEffect, useCallback } from 'react';

interface WebSocketHook {
  isConnected: boolean;
  lastMessage: string | null;
  sendMessage: (message: string) => void;
  reconnect: () => void;
}

export const useWebSocket = (url: string): WebSocketHook => {
  const [socket, setSocket] = useState<WebSocket | null>(null);
  const [isConnected, setIsConnected] = useState(false);
  const [lastMessage, setLastMessage] = useState<string | null>(null);

  const connect = useCallback(() => {
    const ws = new WebSocket(url);

    ws.onopen = () => {
      setIsConnected(true);
      console.log('WebSocket Connected');
    };

    ws.onclose = () => {
      setIsConnected(false);
      console.log('WebSocket Disconnected');
    };

    ws.onmessage = (event) => {
      setLastMessage(event.data);
      console.log('WebSocket Message:', event.data);
    };

    ws.onerror = (error) => {
      console.error('WebSocket Error:', error);
    };

    setSocket(ws);
  }, [url]);

  useEffect(() => {
    connect();

    return () => {
      if (socket) {
        socket.close();
      }
    };
  }, [connect]);

  const sendMessage = useCallback((message: string) => {
    if (socket && isConnected) {
      socket.send(message);
    } else {
      console.error('WebSocket is not connected');
    }
  }, [socket, isConnected]);

  const reconnect = useCallback(() => {
    if (socket) {
      socket.close();
    }
    connect();
  }, [socket, connect]);

  return {
    isConnected,
    lastMessage,
    sendMessage,
    reconnect,
  };
}; 