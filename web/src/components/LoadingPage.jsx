import React from "react";
import {FaSpinner} from "react-icons/fa6"
const LoadingPage = () => {
	return (
		
			<div className='fixed top-0 left-0 right-0 bottom-0 z-50 bg-gray-100 bg-opacity-75 flex items-center justify-center'>
				<FaSpinner size={60} className="text-teal-500 animate-spin duration-500"/>
			</div>
		
	);
};

export default LoadingPage;
