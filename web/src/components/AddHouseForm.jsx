import { Button, Switch, TextArea, TextField } from '@radix-ui/themes';
import React, { useState } from 'react';
import { formDataToFormData, isNotEmpty } from '../lib/validate';
import { toast } from 'react-toastify';
import { ADD_HOUSE_PATH } from '../api/paths';

const AddHouseForm = () => {
  const [formData, setFormData] = useState({
    title: '',
    location: '',
    price: '',
    bedrooms: '',
    description:"",
    bathrooms: false,
    kitchen:false,
    images: [],
  });

  const handleChange = (e) => {
    
    const { name, value, files } = e.target;
    if (name === 'images') {
      setFormData({ ...formData, [name]: Array.from(files) });
    } else {
      setFormData({ ...formData, [name]: value });
    }
  };
 
  const handleSubmit = (e) => {
    e.preventDefault();
    const {images,...rest} = formData
     const img_formData = new FormData()
    Object.keys(rest).forEach(k=>{
        img_formData.append(k,rest[k])
    })
    for (const image of formData.images) {
        img_formData.append("images",image)
    }
    if (isNotEmpty(rest)) {
        fetch(ADD_HOUSE_PATH.url,{...ADD_HOUSE_PATH,body:img_formData}).then((r)=>{
            if (r.status === 201) {
                 toast.success("House is created successfully")
                 return window.location.reload()
            }
        })
    }else{
        return toast.warn("Field are empty");
    }
  };

  return (
    <div className="max-w-xl mx-auto mt-10 p-6 bg-white rounded-md shadow-md">
      <h1 className="text-2xl font-semibold text-center text-gray-800 mb-6">Ajouter une maison à louer</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label htmlFor="title" className="block  font-medium text-gray-700">
            Titre :
          </label>
          <input
            type="text"
            name="title"
            value={formData.title}
            onChange={handleChange}
            className="form-input mt-1 block w-full border p-2 rounded border-gray-300 outline-none"
          />
        </div>

        <div>
          <label htmlFor="location" className="block font-medium text-gray-700">
            Emplacement :
          </label>
          <input
            type="text"
            name="location"
            value={formData.location}
            onChange={handleChange}
            className="form-input mt-1 block w-full border p-2 rounded border-gray-300 outline-none"
          />
        </div>

        <div>
          <label htmlFor="price" className="block font-medium text-gray-700">
            Prix :
          </label>
          <input
            type="number"
            name="price"
            value={formData.price}
            onChange={handleChange}
            className="form-input mt-1 block w-full border p-2 rounded border-gray-300 outline-none"
          />
        </div>

        <div>
          <label htmlFor="bedrooms" className="block font-medium text-gray-700">
            Chambres :
          </label>
          <input
            type="number"
            name="bedrooms"
            value={formData.bedrooms}
            onChange={handleChange}
            className="form-input mt-1 block w-full border p-2 rounded border-gray-300 outline-none"
          />
        </div>

       <div className='flex justify-between items-center'>
       <div className='flex items-center'>
          <label htmlFor="bathrooms" className="block font-medium text-gray-700">
            Salles de bain :
          </label>
          
          <Switch name='bathrooms' checked={formData.bathrooms}  value={formData.bathrooms}
            onCheckedChange={(value)=>setFormData({...formData,bathrooms:value})}/>
        </div>
        <div className='flex items-center'>
          <label htmlFor="bathrooms" className="block font-medium text-gray-700">
            Cuisine :
          </label>
          
          <Switch name='kitchen' checked={formData.kitchen}  value={formData.kitchen}
            onCheckedChange={(value)=>setFormData({...formData,kitchen:value})}/>
        </div>
       </div>
       <TextField.Root>
        <TextArea name='description' onChange={handleChange} className='w-full' placeholder='Veuillez laisser une description'/>
       </TextField.Root>
        <div>
          <label htmlFor="images" className="block font-medium text-gray-700">
            Images :
          </label>
          <input
            type="file"
            name="images"
            multiple
            onChange={handleChange}
            className="form-input mt-1 block w-full"
          />
        </div>

        <div>
          <Button variant='solid'  className="w-full bg-bleu-500 cursor-pointer">
            Ajouter la maison
          </Button>
        </div>
      </form>
    </div>
  );
};

export default AddHouseForm;
