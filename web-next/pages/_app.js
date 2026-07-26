import { Provider } from "react-redux";
import { Theme } from "@radix-ui/themes";
import { ToastContainer } from "react-toastify";
import "@radix-ui/themes/styles.css";
import "react-toastify/dist/ReactToastify.css";
import "../styles/globals.css";
import { store } from "../redux/store";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";
import { display, body } from "../lib/fonts";

function MyApp({ Component, pageProps }) {
	return (
		<Provider store={store}>
			<Theme accentColor='bronze' grayColor='sand' radius='large'>
				<div className={`${display.variable} ${body.variable} font-sans flex min-h-screen flex-col bg-paper text-ink`}>
					<Navbar />
					<main className='flex-1'>
						<Component {...pageProps} />
					</main>
					<Footer />
				</div>
				<ToastContainer />
			</Theme>
		</Provider>
	);
}

export default MyApp;
