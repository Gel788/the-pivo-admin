import { keyframes } from '@mui/system';

export const fadeIn = keyframes`
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
`;

export const slideUp = keyframes`
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
`;

export const slideIn = keyframes`
  from {
    transform: translateX(-20px);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
`;

export const scaleIn = keyframes`
  from {
    transform: scale(0.95);
    opacity: 0;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
`;

export const pulse = keyframes`
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
  100% {
    transform: scale(1);
  }
`;

export const shimmer = keyframes`
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
`;

export const animationStyles = {
  slideIn: {
    animation: 'slideIn 0.5s ease-out',
    '@keyframes slideIn': {
      '0%': {
        opacity: 0,
        transform: 'translateX(-20px)'
      },
      '100%': {
        opacity: 1,
        transform: 'translateX(0)'
      }
    }
  },
  
  slideUp: {
    animation: 'slideUp 0.5s ease-out',
    '@keyframes slideUp': {
      '0%': {
        opacity: 0,
        transform: 'translateY(20px)'
      },
      '100%': {
        opacity: 1,
        transform: 'translateY(0)'
      }
    }
  },
  
  fadeIn: {
    animation: 'fadeIn 0.5s ease-out',
    '@keyframes fadeIn': {
      '0%': {
        opacity: 0
      },
      '100%': {
        opacity: 1
      }
    }
  },
  
  scaleIn: {
    animation: 'scaleIn 0.3s ease-out',
    '@keyframes scaleIn': {
      '0%': {
        opacity: 0,
        transform: 'scale(0.9)'
      },
      '100%': {
        opacity: 1,
        transform: 'scale(1)'
      }
    }
  },
  
  pulse: {
    animation: 'pulse 2s infinite',
    '@keyframes pulse': {
      '0%': {
        transform: 'scale(1)'
      },
      '50%': {
        transform: 'scale(1.05)'
      },
      '100%': {
        transform: 'scale(1)'
      }
    }
  },
  
  shimmer: {
    animation: 'shimmer 2s infinite',
    '@keyframes shimmer': {
      '0%': {
        backgroundPosition: '-200% 0'
      },
      '100%': {
        backgroundPosition: '200% 0'
      }
    }
  }
}; 