import { Button } from '@radix-ui/themes';
import React from 'react'
import { Link, useNavigate } from 'react-router-dom'

function Navbar() {
    const navigate = useNavigate()
  return (
		<nav>
			<div className='flex justify-between items-center p-5'>
				<Link
					to={"/"}
					className='text-2xl font-bold uppercase text-blue-700'>
					Easyroom
				</Link>
				<div className='flex items-center gap-5 text-lg'>
					<Link to={""}>Home</Link>
					<Link to={""}>About us</Link>
					<Link to={""}>Rental</Link>
					<Link to={""}>Faq</Link>
              </div>
              <div className='flex items-center gap-2'>
                  <Link className='text-blue' to={"/login"}>Login</Link>
                  <span>/</span>
                  <Button variant={"solid"} onClick={()=>navigate("/register")} >Register</Button>
              </div>
			</div>
		</nav>
	);
}

export default Navbar