import React, { Component, ErrorInfo, ReactNode } from 'react';
import { Box, Typography, Button } from '@mui/material';
import { Refresh as RefreshIcon } from '@mui/icons-material';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

class ErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false,
    error: null,
  };

  public static getDerivedStateFromError(error: Error): State {
    return {
      hasError: true,
      error,
    };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Uncaught error:', error, errorInfo);
  }

  private handleReset = () => {
    this.setState({
      hasError: false,
      error: null,
    });
  };

  public render() {
    if (this.state.hasError) {
      if (this.props.fallback) {
        return this.props.fallback;
      }

      return (
        <Box
          sx={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            minHeight: 400,
            p: 3,
            textAlign: 'center',
          }}
        >
          <Typography variant="h5" gutterBottom color="error">
            Что-то пошло не так
          </Typography>
          <Typography variant="body2" color="text.secondary" sx={{ mb: 3 }}>
            Произошла ошибка при отображении этого компонента.
            {this.state.error && (
              <Box component="pre" sx={{ mt: 2, p: 2, bgcolor: 'grey.100', borderRadius: 1 }}>
                {this.state.error.message}
              </Box>
            )}
          </Typography>
          <Button variant="contained" startIcon={<RefreshIcon />} onClick={this.handleReset}>
            Попробовать снова
          </Button>
        </Box>
      );
    }

    return this.props.children;
  }
}

export default ErrorBoundary;
