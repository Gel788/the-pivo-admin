import React, { useState } from 'react';
import {
  Box,
  Button,
  IconButton,
  Tooltip,
  Collapse,
  Paper,
  Grid,
  Typography,
  Divider,
} from '@mui/material';
import {
  FilterList as FilterListIcon,
  Clear as ClearIcon,
  ExpandMore as ExpandMoreIcon,
  ExpandLess as ExpandLessIcon,
} from '@mui/icons-material';

interface FilterBarProps {
  children: React.ReactNode;
  onClear?: () => void;
  title?: string;
  showClearButton?: boolean;
}

const FilterBar: React.FC<FilterBarProps> = ({
  children,
  onClear,
  title = 'Фильтры',
  showClearButton = true,
}) => {
  const [expanded, setExpanded] = useState(false);

  const handleToggle = () => {
    setExpanded(!expanded);
  };

  const handleClear = () => {
    onClear?.();
  };

  return (
    <Paper sx={{ mb: 2 }}>
      <Box
        sx={{
          p: 2,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
        }}
      >
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
          <FilterListIcon color="action" />
          <Typography variant="subtitle1">{title}</Typography>
        </Box>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
          {showClearButton && onClear && (
            <Tooltip title="Очистить фильтры">
              <IconButton
                size="small"
                onClick={handleClear}
              >
                <ClearIcon />
              </IconButton>
            </Tooltip>
          )}
          <IconButton
            size="small"
            onClick={handleToggle}
          >
            {expanded ? <ExpandLessIcon /> : <ExpandMoreIcon />}
          </IconButton>
        </Box>
      </Box>
      <Collapse in={expanded}>
        <Divider />
        <Box sx={{ p: 2 }}>
          <Grid container spacing={2}>
            {children}
          </Grid>
        </Box>
      </Collapse>
    </Paper>
  );
};

export default FilterBar; 