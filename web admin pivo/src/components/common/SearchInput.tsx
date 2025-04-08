import React, { useState, useEffect } from 'react';
import {
  TextField,
  InputAdornment,
  IconButton,
  Box,
  CircularProgress,
} from '@mui/material';
import {
  Search as SearchIcon,
  Clear as ClearIcon,
} from '@mui/icons-material';

interface SearchInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  loading?: boolean;
  debounceMs?: number;
  fullWidth?: boolean;
  size?: 'small' | 'medium';
}

const SearchInput: React.FC<SearchInputProps> = ({
  value,
  onChange,
  placeholder = 'Поиск...',
  loading = false,
  debounceMs = 300,
  fullWidth = true,
  size = 'small',
}) => {
  const [inputValue, setInputValue] = useState(value);

  useEffect(() => {
    const timer = setTimeout(() => {
      if (inputValue !== value) {
        onChange(inputValue);
      }
    }, debounceMs);

    return () => clearTimeout(timer);
  }, [inputValue, debounceMs, onChange, value]);

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(event.target.value);
  };

  const handleClear = () => {
    setInputValue('');
    onChange('');
  };

  return (
    <Box sx={{ position: 'relative' }}>
      <TextField
        value={inputValue}
        onChange={handleChange}
        placeholder={placeholder}
        fullWidth={fullWidth}
        size={size}
        InputProps={{
          startAdornment: (
            <InputAdornment position="start">
              <SearchIcon color="action" />
            </InputAdornment>
          ),
          endAdornment: (
            <InputAdornment position="end">
              {loading ? (
                <CircularProgress size={20} />
              ) : inputValue ? (
                <IconButton
                  size="small"
                  onClick={handleClear}
                  edge="end"
                >
                  <ClearIcon />
                </IconButton>
              ) : null}
            </InputAdornment>
          ),
        }}
      />
    </Box>
  );
};

export default SearchInput; 