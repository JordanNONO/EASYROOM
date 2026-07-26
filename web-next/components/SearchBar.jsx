import { useState } from "react";
import { TextField, Button } from "@radix-ui/themes";
import { IoSearch } from "react-icons/io5";
import { BASE_URL } from "../api/common";

function SearchBar({ onResults }) {
	const [query, setQuery] = useState("");
	const [searching, setSearching] = useState(false);

	function handleSubmit(event) {
		event.preventDefault();
		setSearching(true);
		fetch(`${BASE_URL}/house/search?q=${encodeURIComponent(query)}&city=Limoges`)
			.then((r) => (r.ok ? r.json() : []))
			.then((houses) => onResults(houses, query))
			.catch(() => onResults(null, query))
			.finally(() => setSearching(false));
	}

	return (
		<form
			onSubmit={handleSubmit}
			className='relative mx-auto w-[92%] max-w-2xl rounded-2xl bg-white shadow-lg p-2 flex gap-2 mt-8 mb-4'>
			<TextField.Root className='flex-1' size={"3"}>
				<TextField.Slot>
					<IoSearch className='text-ink-soft' />
				</TextField.Slot>
				<TextField.Input
					value={query}
					onChange={(e) => setQuery(e.target.value)}
					placeholder='Quartier, type de logement...'
					aria-label='Rechercher un logement à Limoges'
				/>
			</TextField.Root>
			<Button size={"3"} className='cursor-pointer' disabled={searching}>
				{searching ? "..." : "Rechercher"}
			</Button>
		</form>
	);
}

export default SearchBar;
