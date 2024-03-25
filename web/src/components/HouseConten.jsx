import { Heading } from '@radix-ui/themes'
import React from 'react'
import {IoHeartOutline} from "react-icons/io5"
function HouseConten() {
  return (
    <div className='mx-auto p-8'>
       <Heading className='p-3'>
        Recommanded
       </Heading>
        <div className='grid grid-cols-5 items-center'>
            <div className='flex flex-col gap-2'>
                <div className='relative'>
                <img className='rounded-xl' src="https://images.unsplash.com/photo-1570129477492-45c003edd2be?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" alt="" />
                <div className='absolute top-0 right-0 p-2'>
                    <IoHeartOutline size={30} className='text-gray-700 hover:scale-110 duration-150'/>
                </div>
                </div>
                <Heading size={"3"}>
                    Label
                </Heading>
                <p>
                    Description
                </p>
                <Heading size={"2"}>
                    500 FCFA
                </Heading>
            </div>
            
        </div>
    </div>
  )
}

export default HouseConten