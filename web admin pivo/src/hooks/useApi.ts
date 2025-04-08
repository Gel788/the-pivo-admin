import { useQuery, useMutation, UseQueryOptions, UseMutationOptions } from '@tanstack/react-query';
import { AxiosError } from 'axios';
import { api } from '../services/api';

export const useApiQuery = <T>(
  key: string[],
  url: string,
  options?: Omit<UseQueryOptions<T, AxiosError>, 'queryKey' | 'queryFn'>
) => {
  return useQuery<T, AxiosError>({
    queryKey: key,
    queryFn: async () => {
      const { data } = await api.get<T>(url);
      return data;
    },
    ...options,
  });
};

export const useApiMutation = <T, V>(
  url: string,
  options?: Omit<UseMutationOptions<T, AxiosError, V>, 'mutationFn'>
) => {
  return useMutation<T, AxiosError, V>({
    mutationFn: async (variables) => {
      const { data } = await api.post<T>(url, variables);
      return data;
    },
    ...options,
  });
};

export const useApiPut = <T, V>(
  url: string,
  options?: Omit<UseMutationOptions<T, AxiosError, V>, 'mutationFn'>
) => {
  return useMutation<T, AxiosError, V>({
    mutationFn: async (variables) => {
      const { data } = await api.put<T>(url, variables);
      return data;
    },
    ...options,
  });
};

export const useApiDelete = <T>(
  url: string,
  options?: Omit<UseMutationOptions<T, AxiosError, void>, 'mutationFn'>
) => {
  return useMutation<T, AxiosError, void>({
    mutationFn: async () => {
      const { data } = await api.delete<T>(url);
      return data;
    },
    ...options,
  });
}; 