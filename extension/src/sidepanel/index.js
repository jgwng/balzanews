import '../styles/global.css';
import App from './App.svelte';

const app = new App({
  target: document.body,
  props: {
    name: 'sidepanel',
  },
});

export default app;
