import { ButtonGroup } from 'react-bootstrap';

import { NutriscoreBarItem } from '../components';

interface NutriscoreBarProps {
  nutriscore: string;
}

export const NutriscoreBar: React.FC<NutriscoreBarProps> = ({ nutriscore }: NutriscoreBarProps) => { 
  return (
    <ButtonGroup className='mb-2'>
      <NutriscoreBarItem
        nutriscoreItemLabel='A'
        selectedNutriscore={nutriscore}
        variant='success' />
      <NutriscoreBarItem
        nutriscoreItemLabel='B'
        selectedNutriscore={nutriscore}
        variant='success' />
      <NutriscoreBarItem
        nutriscoreItemLabel='C'
        selectedNutriscore={nutriscore}
        variant='warning' />
      <NutriscoreBarItem
        nutriscoreItemLabel='D'
        selectedNutriscore={nutriscore}
        variant='warning' />
      <NutriscoreBarItem
        nutriscoreItemLabel='E'
        selectedNutriscore={nutriscore}
        variant='danger' />
    </ButtonGroup>
  );
}
