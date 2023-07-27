export {};

declare global {
  interface Window {
      ENV_CONFIG: {
        REACT_APP_API_URL: string;
      }
  }
}