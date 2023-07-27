import { Alert } from 'react-bootstrap';

import { generateId } from '../utils/idUtils';

interface ErrorProps {
  errorMessage: string | any;
}

export const Error: React.FC<ErrorProps> = ({ errorMessage }: ErrorProps) => {
  return (
    <Alert key={generateId('error')} variant='danger' className="d-flex align-items-center">
      <i className='bi bi-exclamation-triangle-fill'></i>
      <div style={{ marginLeft: '0.5em' }}>{errorMessage}</div>
    </Alert>
  );
}