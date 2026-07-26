import { Button, Switch, TextArea, TextField } from "@radix-ui/themes";
import { useState } from "react";
import { isNotEmpty } from "../lib/validate";
import { toast } from "react-toastify";
import { ADD_HOUSE_PATH, authHeader } from "../api/paths";

const AddHouseForm = () => {
	const [formData, setFormData] = useState({
		title: "",
		location: "",
		price: "",
		bedrooms: "",
		description: "",
		bathrooms: false,
		kitchen: false,
		images: [],
	});
	const [submitting, setSubmitting] = useState(false);

	const handleChange = (e) => {
		const { name, value, files } = e.target;
		if (name === "images") {
			setFormData({ ...formData, [name]: Array.from(files) });
		} else {
			setFormData({ ...formData, [name]: value });
		}
	};

	const handleSubmit = (e) => {
		e.preventDefault();
		const { images, ...rest } = formData;
		const img_formData = new FormData();
		Object.keys(rest).forEach((k) => {
			img_formData.append(k, rest[k]);
		});
		for (const image of formData.images) {
			img_formData.append("images", image);
		}
		if (!isNotEmpty(rest)) {
			toast.warn("Merci de remplir tous les champs.");
			return;
		}
		setSubmitting(true);
		fetch(ADD_HOUSE_PATH.url, {
			method: ADD_HOUSE_PATH.method,
			headers: authHeader(),
			body: img_formData,
		})
			.then(async (r) => {
				if (r.status === 201) {
					toast.success("Annonce publiée avec succès !");
					return window.location.reload();
				}
				toast.error(await r.text());
			})
			.catch(() => toast.error("Erreur réseau, réessaie."))
			.finally(() => setSubmitting(false));
	};

	return (
		<div className='rounded-2xl border border-line bg-white p-6 shadow-sm'>
			<form onSubmit={handleSubmit} className='flex flex-col gap-5'>
				<label className='flex flex-col gap-1'>
					<span className='text-sm font-medium text-ink'>Titre</span>
					<TextField.Root size={"3"}>
						<TextField.Input
							id='title'
							name='title'
							value={formData.title}
							onChange={handleChange}
							placeholder='Ex : T2 lumineux centre-ville'
						/>
					</TextField.Root>
				</label>

				<label className='flex flex-col gap-1'>
					<span className='text-sm font-medium text-ink'>Adresse</span>
					<TextField.Root size={"3"}>
						<TextField.Input
							id='location'
							name='location'
							value={formData.location}
							onChange={handleChange}
							placeholder='Ex : 12 rue Turgot, Limoges'
						/>
					</TextField.Root>
				</label>

				<div className='grid grid-cols-2 gap-4'>
					<label className='flex flex-col gap-1'>
						<span className='text-sm font-medium text-ink'>Prix (€/mois)</span>
						<TextField.Root size={"3"}>
							<TextField.Input
								type='number'
								id='price'
								name='price'
								value={formData.price}
								onChange={handleChange}
							/>
						</TextField.Root>
					</label>
					<label className='flex flex-col gap-1'>
						<span className='text-sm font-medium text-ink'>Chambres</span>
						<TextField.Root size={"3"}>
							<TextField.Input
								type='number'
								id='bedrooms'
								name='bedrooms'
								value={formData.bedrooms}
								onChange={handleChange}
							/>
						</TextField.Root>
					</label>
				</div>

				<div className='flex justify-between items-center rounded-xl bg-paper-raised px-4 py-3'>
					<div className='flex items-center gap-2'>
						<label htmlFor='bathrooms' className='text-sm font-medium text-ink'>
							Salle de bain
						</label>
						<Switch
							id='bathrooms'
							name='bathrooms'
							checked={formData.bathrooms}
							onCheckedChange={(value) => setFormData({ ...formData, bathrooms: value })}
						/>
					</div>
					<div className='flex items-center gap-2'>
						<label htmlFor='kitchen' className='text-sm font-medium text-ink'>
							Cuisine
						</label>
						<Switch
							id='kitchen'
							name='kitchen'
							checked={formData.kitchen}
							onCheckedChange={(value) => setFormData({ ...formData, kitchen: value })}
						/>
					</div>
				</div>

				<label className='flex flex-col gap-1'>
					<span className='text-sm font-medium text-ink'>Description</span>
					<TextArea
						name='description'
						onChange={handleChange}
						placeholder='Décris le logement, son quartier, ses atouts...'
					/>
				</label>

				<label className='flex flex-col gap-1'>
					<span className='text-sm font-medium text-ink'>Photos</span>
					<input
						type='file'
						id='images'
						name='images'
						multiple
						onChange={handleChange}
						className='block w-full text-sm text-ink-soft file:mr-3 file:rounded-lg file:border-0 file:bg-brass-light file:px-3 file:py-2 file:text-brass file:cursor-pointer'
					/>
				</label>

				<Button size={"3"} className='w-full cursor-pointer' disabled={submitting}>
					{submitting ? "Publication..." : "Publier l'annonce"}
				</Button>
			</form>
		</div>
	);
};

export default AddHouseForm;
