import React from 'react';
import { Box, Typography, Button, SvgIconProps } from '@mui/material';
import { Add as AddIcon } from '@mui/icons-material';

interface EmptyStateProps {
  title: string;
  description: string;
  icon?: React.ReactElement<SvgIconProps>;
  action?: {
    label: string;
    onClick: () => void;
  };
}

const EmptyState: React.FC<EmptyStateProps> = ({
  title,
  description,
  icon = <AddIcon sx={{ fontSize: 48 }} />,
  action,
}) => {
  return (
    <Box
      sx={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        p: 4,
        textAlign: 'center',
        minHeight: 400,
      }}
    >
      <Box
        sx={{
          color: 'text.secondary',
          mb: 2,
        }}
      >
        {icon}
      </Box>
      <Typography variant="h6" gutterBottom>
        {title}
      </Typography>
      <Typography
        variant="body2"
        color="text.secondary"
        sx={{ mb: 3, maxWidth: 400 }}
      >
        {description}
      </Typography>
      {action && (
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={action.onClick}
        >
          {action.label}
        </Button>
      )}
    </Box>
  );
};

export default EmptyState; 