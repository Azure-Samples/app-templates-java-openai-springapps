interface HeaderProps {
  title: string;
}

export const Header: React.FC<HeaderProps> = ({ title }: HeaderProps) => {
  return (
    <h1 style={{ marginTop: '1em' }} className='text-center'>{title} <i className='bi bi-cart4'></i></h1>
  );
}