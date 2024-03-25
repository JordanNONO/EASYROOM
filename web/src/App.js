import { BrowserRouter, Route, Routes } from "react-router-dom";
import Home from "./pages/Home";
import Navbar from "./components/Navbar";
import Login from "./pages/Login";
import Register from "./pages/Register";
import { ToastContainer } from "react-toastify";
import PrivateRoute from "./components/PrivateRouter";
import Dashboard from "./pages/Dashboard";

function App() {
	return (
		<div>
			<BrowserRouter>
				<Navbar />
				<Routes>
					<Route
						path='/'
						element={<PrivateRoute />}>
						<Route
							path='/'
							element={<Home />}
						/>
					</Route>
					<Route
						path='/dashboard'
						element={<PrivateRoute />}>
						<Route
							path='/dashboard'
							element={<Dashboard />}
						/>
					</Route>
					<Route
						path='/login'
						element={<Login />}
					/>
					<Route
						path='/register'
						element={<Register />}
					/>
				</Routes>
				<ToastContainer />
			</BrowserRouter>
		</div>
	);
}

export default App;
