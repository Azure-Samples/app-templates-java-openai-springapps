import { ToggleButton } from "react-bootstrap";

import { generateId } from "../utils/idUtils";

interface NutriscoreBarItemProps {
  nutriscoreItemLabel: string;
  selectedNutriscore: string;
  variant: string
}

const getNutriscoreColor = (nutriscoreItemLabel: string): string => {
  if (nutriscoreItemLabel.toUpperCase() === 'A') {
    return '#00803d';
  }
  switch (nutriscoreItemLabel.toUpperCase()) {
    case 'A': return '#00803d';
    case 'B': return '#86bc25';
    case 'C': return '#ffcc00';
    case 'D': return '#ef7d00';
    case 'E': return '#e63312';
    default: return '#000000';
  }
}

export const NutriscoreBarItem: React.FC<NutriscoreBarItemProps> = ({ nutriscoreItemLabel, selectedNutriscore, variant }: NutriscoreBarItemProps) => {
  const isSelected: boolean = nutriscoreItemLabel.toUpperCase() === selectedNutriscore.toUpperCase();
  const id: string = generateId(`nutriscore${nutriscoreItemLabel}`);
  const color: string = getNutriscoreColor(nutriscoreItemLabel);
  const style = isSelected ?
    { color: '#fff', backgroundColor: color, borderColor: color } :
    { color: color, borderColor: color };
  return (
    <ToggleButton
      key={id}
      id={id}
      type='radio' 
      variant={isSelected ? variant : `outline-${variant}`}
      name='nutriscore' 
      value={nutriscoreItemLabel}
      style={style}
      disabled={!isSelected}>
        {nutriscoreItemLabel}
    </ToggleButton>
  );
}
