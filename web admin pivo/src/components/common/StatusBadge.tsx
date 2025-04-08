import React from 'react';
import { Chip, ChipProps } from '@mui/material';
import {
  CheckCircle as SuccessIcon,
  Error as ErrorIcon,
  Warning as WarningIcon,
  Info as InfoIcon,
  Schedule as PendingIcon,
  Block as BlockedIcon,
} from '@mui/icons-material';

export type StatusType = 'success' | 'error' | 'warning' | 'info' | 'pending' | 'blocked';

interface StatusBadgeProps extends Omit<ChipProps, 'color' | 'icon'> {
  status: StatusType;
  label: string;
}

const getStatusConfig = (status: StatusType) => {
  switch (status) {
    case 'success':
      return {
        color: 'success' as const,
        icon: <SuccessIcon />,
      };
    case 'error':
      return {
        color: 'error' as const,
        icon: <ErrorIcon />,
      };
    case 'warning':
      return {
        color: 'warning' as const,
        icon: <WarningIcon />,
      };
    case 'info':
      return {
        color: 'info' as const,
        icon: <InfoIcon />,
      };
    case 'pending':
      return {
        color: 'default' as const,
        icon: <PendingIcon />,
      };
    case 'blocked':
      return {
        color: 'error' as const,
        icon: <BlockedIcon />,
      };
    default:
      return {
        color: 'default' as const,
        icon: <InfoIcon />,
      };
  }
};

const StatusBadge: React.FC<StatusBadgeProps> = ({ status, label, ...props }) => {
  const { color, icon } = getStatusConfig(status);

  return (
    <Chip
      icon={icon}
      label={label}
      color={color}
      size="small"
      sx={{
        '& .MuiChip-icon': {
          fontSize: 18,
        },
      }}
      {...props}
    />
  );
};

export default StatusBadge; 