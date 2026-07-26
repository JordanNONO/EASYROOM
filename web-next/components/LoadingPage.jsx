import { FaSpinner } from "react-icons/fa6";
import Logo from "./Logo";

const LoadingPage = () => {
	return (
		<div className='fixed top-0 left-0 right-0 bottom-0 z-50 bg-paper/95 flex flex-col items-center justify-center gap-4'>
			<Logo />
			<FaSpinner size={32} className='text-brass animate-spin' />
		</div>
	);
};

export default LoadingPage;
