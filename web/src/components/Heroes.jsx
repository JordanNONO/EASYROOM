import { Button, Heading } from '@radix-ui/themes'
import React from 'react'
import illustration from "../img/undraw_house_searching_re_stk8.svg"

function Heroes() {
  return (
		<div className=' heroes-bg flex justify-center items-center'>
			<div className='w-[70%] h-1/2 flex items-center py-5 mt-8'>
				<div className='text-white'>
					<Heading className='mb-5 text-3xl uppercase first-letter:text-blue-700'>
						Get early your house from low coast
                  </Heading>
                  <p className='mb-5 text'>
                      Lorem ipsum dolor sit amet consectetur, adipisicing elit. Cum, eligendi optio veniam reiciendis id laborum animi doloremque accusamus aspernatur laboriosam consequatur nostrum eius voluptatum fugiat! Voluptas veritatis aperiam impedit placeat?
                  </p>
					<Button
						size={"4"}
						className='cursor-pointer'>
						Get started
					</Button>
              </div>
              <div className='w-full'></div>
				{/* <img
					src={illustration}
					className='w-1/2'
					alt='Illustration'
				/> */}
			</div>
		</div>
	);
}

export default Heroes