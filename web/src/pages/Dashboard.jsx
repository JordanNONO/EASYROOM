import { Card, Container, Flex, Heading } from '@radix-ui/themes'
import {FaBuilding} from "react-icons/fa6"
import React from 'react'
import AddHouseForm from '../components/AddHouseForm';

function Dashboard() {
  return (
		<div>
			<Container>
				<Flex>
					<Card>
						<Flex className='items-center gap-3 p-3'>
							<div className='bg-green-200 rounded-lg p-3'>
								<FaBuilding
									size={30}
									className='text-green-600'
								/>
							</div>
							<Flex direction={"column"}>
								<Heading
									as='h6'
									size={"3"}>
									Count House
                              </Heading>
                              <Heading>0</Heading>
							</Flex>
						</Flex>
					</Card>
              </Flex>
              <AddHouseForm/>
			</Container>
		</div>
	);
}

export default Dashboard